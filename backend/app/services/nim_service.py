import os
import httpx
import json
import random
from dotenv import load_dotenv
from ..models.schemas import Tone, Context

load_dotenv()

NIM_ENDPOINT = os.getenv("NIM_ENDPOINT", "http://localhost:8082")

class NIMService:
    
    # Sample responses for when API fails
    SAMPLE_RIZZ = {
        'funny': {
            'dating_app': [
                "Okay I'm officially curious - what kind of trouble are you usually up to on Friday nights? 😏",
                "Not gonna lie, I've been trying to come up with something clever for 20 minutes. Just be impressed, please. 🤡",
                "You seem like someone who makes life interesting. Prove me right? ✨"
            ],
            'crush': [
                "So I was thinking... if I were a potato, I'd definitely be the loaded kind. What about you? 🥔",
                "I've got a joke about you but I'm too lazy to tell it. Let's go on a date instead and I'll have time to think of one 😏",
                "My friend asked why I'm smiling at my phone. I said 'a cute person exists.' That person is you. ☺️"
            ],
            'text': [
                "Update: I've successfully convinced myself you're funny. The evidence is still pending but my optimism is strong. 🤡",
                "Fun fact: I've checked my phone 47 times today. 46 were for you. The other was to see if I had service. 📱💕",
                "I've run out of smart things to say so I'm just gonna say... hi. Hi. 👋😊"
            ],
            'instagram': [
                "Not to be dramatic but your story game is giving me life rn. Who taught you?? ✨🔥",
                "This photo deserves way more likes. I'm personally responsible for half of them already. 💕",
                "You ever just look at someone's post and think 'wow, they really are that great'? Yeah. That's me right now. 🥹"
            ]
        },
        'smooth': {
            'dating_app': [
                "I'm usually not one to say this, but I'd love to hear more about you. What makes you light up?",
                "There's something about your profile that caught my attention. Want to find out what?",
                "I don't usually start conversations, but you seem worth the exception. Let's talk?"
            ],
            'crush': [
                "I've been wanting to talk to you for a while now. No more beating around the bush - want to grab coffee sometime?",
                "Honestly? I've been thinking about you. Want to change that 'thinking' to 'spending time with'?",
                "You make nervous look good. Can I take you out and see if the feeling is mutual? 💫"
            ],
            'text': [
                "Hey, I was thinking about you. How's your day going? Hope it's as great as you are.",
                "Just wanted to say you popped into my mind. Anything exciting happening?",
                "I've been meaning to tell you - I really enjoy our conversations. They're the highlight of my day."
            ],
            'instagram': [
                "That photo is incredible. You have great energy - it's hard to look away.",
                "Your style is on point. Seriously impressed every time I see your posts. 🔥",
                "This is the content I come here for. You're always so genuine and real - love it."
            ]
        },
        'savage': {
            'dating_app': [
                "You seem interesting. Let's see if you can keep up. 😏",
                "Alright, I'll be direct. You're intriguing. What's your angle?",
                "Most people bore me. You haven't yet. That's high praise from me. 🎯"
            ],
            'crush': [
                "Okay I'll be honest - I've been wanting to talk to you for a while. No more games. Want to grab coffee?",
                "I'm not usually this forward but life's too short. You, me, drinks - when are you free? 🥂",
                "Look, I'm into you. A lot. Before this gets too awkward - yes, I said it. Now let's do something about it. 😏"
            ],
            'text': [
                "You've got 3 options: be impressed, be intrigued, or be confused. I'm going for all 3. 🍿",
                "I'm gonna make this simple - I like you. A lot. Any questions? 🤔💕",
                "Normally I'd play it cool but I'm 0 for 12 on 'playing it cool' where you're concerned. So here we are. 🙃"
            ],
            'instagram': [
                "This is the energy I come here for. Real ones know. 🔥",
                "No cap, this was the best thing I'll see today. You're killing it. 💯",
                "The confidence! The vibe! The everything! I'm genuinely impressed. 😍"
            ]
        },
        'cute': {
            'dating_app': [
                "Hi! I think you seem really sweet and I'd love to get to know you better 💕",
                "Your profile made me smile! Want to make an even better connection?",
                "Hey there! You seem really kind. Would you want to chat and see where things go? 🌸"
            ],
            'crush': [
                "Hey! I've been wanting to talk to you, hope I'm not being too forward 😊",
                "This is super nerve-wracking but... I think you're really cool! Want to hang out sometime? 🥺",
                "Okay this took me 47 attempts to send but... hi! I think you're amazing! 💖"
            ],
            'text': [
                "Hiii! Just wanted to say you made my day brighter ☀️",
                "Hey you! Thinking of you right now... in a very cute way 💕",
                "Okay tiny confession: I smiled when I saw your message. Now I'm smiling while typing this. Send help. Or cookies. Cookies work too. 🍪😊"
            ],
            'instagram': [
                "This is the cutest thing I've seen today! You look so happy! 🥺💖",
                "UGHHH YOU'RE SO CUTE!! This made my entire afternoon!! 🥹💕",
                "The cuteness is too real!! I can't handle this!! Someone save me!! 😫💖"
            ]
        },
        'mysterious': {
            'dating_app': [
                "I have a feeling you'd be interesting to talk to... care to find out?",
                "There's something different about you. Can't quite put my finger on it. Let's talk?",
                "I'll be honest - I'm curious about you. That's rare for me. Want to change that curiosity into a conversation?"
            ],
            'crush': [
                "There's something about you I can't quite figure out. I'd love to try.",
                "You intrigue me. Most people are an open book - you're more like a mystery novel. I want to read the whole series. 📖✨",
                "I don't usually do this, but something tells me you're worth breaking my rules for. Prove me right?"
            ],
            'text': [
                "You know what? I've got a secret. Maybe I'll tell you sometime... 🤫",
                "I've been thinking about you. More than usual. That's saying something. 🤔",
                "There's a reason I keep texting you. Maybe one day I'll explain. Or maybe I won't. Stay curious. 💫"
            ],
            'instagram': [
                "Interesting choice... I respect it. 🎭",
                "This has layers. I appreciate that. Very you. 🔮",
                "The mystery continues... I'm here for it. Every single post. ✨"
            ]
        },
        'intellectual': {
            'dating_app': [
                "I'd love to hear your perspective on something. What's something you're passionate about?",
                "Your profile suggests you have depth. I'd love to explore that. What makes you curious?",
                "I'm drawn to substance over style. You seem to have both. Let's talk ideas?"
            ],
            'crush': [
                "I've noticed you're quite thoughtful. I'd love to explore that more with you.",
                "There's an intelligence in how you carry yourself. I'd love to understand it better. Coffee?",
                "Most people talk at me. I'd love to have a real conversation with you. Your thoughts on anything?"
            ],
            'text': [
                "I've been meaning to ask - what's your take on that new documentary everyone's talking about?",
                "Your mind is your most attractive feature. What are you currently deep in thought about? 🧠💫",
                "I've been wanting to have a proper conversation with you. Not small talk - the real stuff. Are you up for it?"
            ],
            'instagram': [
                "This is giving so much depth. Love the substance behind the aesthetic. 🧠",
                "Your posts always make me think. That's rare. Thank you for that. 💡",
                "The way you express yourself is genuinely interesting. You have a unique perspective on things. 👀"
            ]
        }
    }
    
    async def generate_rizz(self, tone: Tone, context: Context, details: str) -> str:
        system_prompt = (
            "You are 'RizzMaster AI,' an expert in modern social dynamics and charisma. "
            "Your goal is to generate a single, potent message that maximizes the chance of a positive response. "
            "\n\nGUIDELINES:\n"
            "- OUTPUT ONLY the message itself. No preamble, no quotes.\n"
            "- AVOID clichés. Do not use 'Hey' or 'Hi' unless strategically necessary.\n"
            "- Tailor language to the context.\n"
            "- Be creative and unique.\n"
            "- TONE DEFINITIONS:\n"
            f"  - Funny: Witty/absurd. Smooth: Confident/effortless. Savage: Playfully arrogant/challenging. "
            f"Cute: Sweet/sincere. Mysterious: Provocative/vague. Intellectual: Observational/deep."
        )
        
        user_prompt = f"Tone: {tone.value}\nContext: {context.value}\nDetails: {details}"
        
        try:
            result = await self._call_nim(system_prompt, user_prompt)
            if not result.startswith("Error"):
                return result
        except:
            pass
        
        # Fallback to sample responses
        tone_key = tone.value if tone.value in self.SAMPLE_RIZZ else 'funny'
        context_key = context.value if context.value in self.SAMPLE_RIZZ.get(tone_key, {}) else 'dating_app'
        
        if tone_key in self.SAMPLE_RIZZ and context_key in self.SAMPLE_RIZZ[tone_key]:
            return random.choice(self.SAMPLE_RIZZ[tone_key][context_key])
        
        return "Hey there! 👋 I've been wanting to talk to you. What have you been up to lately?"

    async def rewrite_message(self, message: str) -> dict:
        system_prompt = (
            "You are a Social Strategist AI. Rewrite the user's draft into three distinct variations. "
            "\n\nVARIATIONS:\n"
            "1. Safe: Low risk, polite, socially acceptable, keeps things light.\n"
            "2. Bold: High confidence, assertive, a bit flirty, shows intent.\n"
            "3. Playful: Teasing, witty, fun, keeps things entertaining.\n"
            "\nCONSTRAINTS:\n"
            "- Maintain original intent but improve clarity and impact.\n"
            "- Return strictly in JSON format.\n"
            "- Schema: {\"safe\": \"...\", \"bold\": \"...\", \"playful\": \"...\"}"
        )
        
        user_prompt = f"Message to rewrite: {message}"
        
        try:
            response_text = await self._call_nim(system_prompt, user_prompt)
            if not response_text.startswith("Error"):
                try:
                    start = response_text.find('{')
                    end = response_text.rfind('}') + 1
                    if start != -1 and end != 0:
                        return json.loads(response_text[start:end])
                except:
                    pass
        except:
            pass
        
        # Fallback responses
        return {
            "safe": f"I really enjoyed our conversation and would love to continue getting to know you better.",
            "bold": f"Look, I'm not gonna beat around the bush - I think you're incredible. Let's make this happen. 😏",
            "playful": f"Okay you win - I can't stop thinking about our conversations. Guilty as charged! 😅"
        }

    async def analyze_chat(self, chat: str) -> dict:
        system_prompt = (
            "You are a Conversation Analyst AI. Analyze the provided chat conversation "
            "and provide insights about the other person's interest level and emotional tone. "
            "\n\nANALYSIS REQUIRED:\n"
            "1. Emotional tone (excited, interested, bored, distant, neutral)\n"
            "2. Interest level (0.0 to 1.0 - where 1.0 is highly interested)\n"
            "3. Red flags or mistakes in the user's messages\n"
            "4. Suggested next reply\n\n"
            "CONSTRAINTS:\n"
            "- Return strictly in JSON format\n"
            "- Be honest but constructive\n"
            "- Focus on helping the user improve\n"
            "- Make the suggested reply natural and engaging"
        )
        
        user_prompt = f"Chat to analyze:\n{chat}\n\nProvide analysis in JSON format with keys: vibe, interest_level (float), red_flags (array), suggestion"
        
        try:
            response_text = await self._call_nim(system_prompt, user_prompt)
            if not response_text.startswith("Error"):
                try:
                    start = response_text.find('{')
                    end = response_text.rfind('}') + 1
                    if start != -1 and end != 0:
                        result = json.loads(response_text[start:end])
                        # Validate result has required fields
                        if 'vibe' in result and 'interest_level' in result:
                            return result
                except:
                    pass
        except:
            pass
        
        # Smart fallback based on chat content
        chat_lower = chat.lower()
        lines = chat.split('\n')
        
        # Simple interest analysis
        interest_indicators = ['haha', 'lol', '😂', '❤️', '😊', '😄', '!', '?', 'yeah', 'yes', 'sure']
        disinterest_indicators = ['k', 'ok', 'whatever', 'idk', 'maybe', 'sure i guess']
        
        interest_count = sum(1 for indicator in interest_indicators if indicator in chat_lower)
        disinterest_count = sum(1 for indicator in disinterest_indicators if indicator in chat_lower)
        
        base_interest = 0.5
        if interest_count > disinterest_count:
            base_interest = 0.7
        elif disinterest_count > interest_count:
            base_interest = 0.35
        
        # Count messages
        other_msgs = sum(1 for l in lines if l.strip() and not l.strip().startswith('You:'))
        your_msgs = sum(1 for l in lines if l.strip().startswith('You:'))
        
        if your_msgs > other_msgs * 2:
            base_interest -= 0.15
        
        red_flags = []
        if your_msgs > other_msgs * 3:
            red_flags.append("You're over-texting - try waiting for them to respond")
        if any(x in chat_lower for x in ['???', '....', 'really?']):
            red_flags.append("Avoid being pushy or appearing desperate")
        
        return {
            "vibe": "💬 They seem interested!" if base_interest > 0.5 else "💭 Their interest level seems moderate",
            "interest_level": max(0.3, min(0.9, base_interest)),
            "red_flags": red_flags if red_flags else ["Keep your messages shorter and more engaging"],
            "suggestion": "Hey! So I was thinking - there's this new place that opened up. You seem like someone who'd appreciate good food. Worth checking out sometime? ☕"
        }

    async def _call_nim(self, system_prompt: str, user_prompt: str) -> str:
        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(
                    f"{NIM_ENDPOINT}/v1/messages",
                    headers={
                        "Content-Type": "application/json",
                        "x-api-key": "test",
                        "anthropic-version": "2023-06-01"
                    },
                    json={
                        "model": "claude-3-5-sonnet-20241022",
                        "max_tokens": 300,
                        "messages": [
                            {"role": "user", "content": f"{system_prompt}\n\n{user_prompt}"}
                        ]
                    },
                    timeout=20.0
                )
                
                if response.status_code != 200:
                    return f"Error: {response.status_code}"
                
                data = response.json()
                if 'content' in data and len(data['content']) > 0:
                    return data['content'][0].get('text', '')
                return str(data)
            except httpx.TimeoutException:
                return "Error: Request timed out"
            except Exception as e:
                return f"Error calling NIM: {str(e)}"

nim_service = NIMService()