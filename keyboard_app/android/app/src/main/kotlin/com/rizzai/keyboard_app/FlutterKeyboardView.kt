package com.rizzai.keyboard_app

import android.content.Context
import android.util.AttributeSet
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugins.flutterappkeyboardservice.BuildConfig

class FlutterKeyboardView @JvmOverloads constructor(
    context: Context,
    private val flutterEngine: FlutterEngine,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private var methodChannel: MethodChannel? = null

    fun setMethodChannel(channel: MethodChannel) {
        this.methodChannel = channel
        setupMethodCallHandler()
    }

    private fun setupMethodCallHandler() {
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "commitText" -> {
                    // This would need to be implemented to actually insert text
                    result.success(true)
                }
                "deleteBackward" -> {
                    // Handle delete
                    result.success(true)
                }
                "getText" -> {
                    // Get current text from input connection
                    result.success("")
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCheckIsTextEditor(): Boolean = true

    override fun onCreateInputConnection(outAttrs: EditorInfo): android.view.inputmethod.InputConnection? {
        outAttrs.inputType = android.text.InputType.TYPE_CLASS_TEXT
        outAttrs.imeOptions = android.view.inputmethod.EditorInfo.IME_ACTION_DONE or
                android.view.inputmethod.EditorInfo.IME_FLAG_NO_FULLSCREEN
        return null
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        when (keyCode) {
            KeyEvent.KEYCODE_DEL -> {
                methodChannel?.invokeMethod("deleteBackward", null)
                return true
            }
            KeyEvent.KEYCODE_ENTER -> {
                methodChannel?.invokeMethod("commitText", mapOf("text" to "\n"))
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }
}

class RizzKeyboardViewFactory(private val flutterEngine: FlutterEngine) : PlatformViewFactory(null) {
    override fun create(context: Context, id: Int, params: Any?): PlatformView {
        return object : PlatformView {
            override fun getView(): View {
                return FlutterKeyboardView(context, flutterEngine)
            }

            override fun dispose() {}
        }
    }
}