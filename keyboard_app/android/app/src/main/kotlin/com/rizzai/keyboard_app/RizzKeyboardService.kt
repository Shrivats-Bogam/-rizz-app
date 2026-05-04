package com.rizzai.keyboard_app

import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputConnection
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class RizzKeyboardService : InputMethodService() {

    private var flutterEngine: FlutterEngine? = null
    private var flutterView: FlutterView? = null
    private val CHANNEL = "rizz_keyboard"
    private var methodChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()

        // Initialize Flutter Engine
        flutterEngine = FlutterEngine(this)
        flutterEngine?.navigationChannel?.setInitialRoute("/keyboard")
        flutterEngine?.dartExecutor?.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Setup Method Channel
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            val ic = currentInputConnection
            if (ic == null) {
                result.success(false)
                return@setMethodCallHandler
            }

            when (call.method) {
                "insertText" -> {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        ic.commitText(text, 1)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Text is null", null)
                    }
                }
                "deleteBackward" -> {
                    ic.deleteSurroundingText(1, 0)
                    result.success(true)
                }
                "getTextBeforeCursor" -> {
                    val length = call.argument<Int>("length") ?: 50
                    val text = ic.getTextBeforeCursor(length, 0)?.toString() ?: ""
                    result.success(text)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreateInputView(): View {
        val view = FlutterView(this)
        flutterView = view
        flutterView?.attachToFlutterEngine(flutterEngine!!)

        // Force the layout to have a reasonable keyboard height
        val layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            (350 * resources.displayMetrics.density).toInt() // Approx 350dp
        )
        view.layoutParams = layoutParams

        return view
    }

    override fun onDestroy() {
        flutterView?.detachFromFlutterEngine()
        flutterEngine?.destroy()
        flutterEngine = null
        super.onDestroy()
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        // Notify Flutter that input has started, if necessary
    }

    override fun onUpdateSelection(oldSelStart: Int, oldSelEnd: Int, newSelStart: Int, newSelEnd: Int, candidatesStart: Int, candidatesEnd: Int) {
        super.onUpdateSelection(oldSelStart, oldSelEnd, newSelStart, newSelEnd, candidatesStart, candidatesEnd)

        // Get text before cursor to send for predictions
        val ic = currentInputConnection
        val textBeforeCursor = ic?.getTextBeforeCursor(50, 0)?.toString() ?: ""

        // Send this context to Flutter
        methodChannel?.invokeMethod("updateTextContext", mapOf("text" to textBeforeCursor))
    }
}
