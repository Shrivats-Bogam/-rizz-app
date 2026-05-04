import pytest
from unittest.mock import MagicMock
import sys

# We need to mock dependencies that are missing in the environment
# to allow pytest to at least collect/run these if needed,
# although in a real CI they would be installed.
if "httpx" not in sys.modules:
    sys.modules["httpx"] = MagicMock()
if "dotenv" not in sys.modules:
    sys.modules["dotenv"] = MagicMock()
if "pydantic" not in sys.modules:
    sys.modules["pydantic"] = MagicMock()

from app.services.nim_service import NIMService

@pytest.mark.asyncio
async def test_analyze_chat_counting():
    service = NIMService()

    # Case 1: Equal messages
    chat = "You: Hello\nThem: Hi\nYou: How are you?\nThem: Good"
    result = await service.analyze_chat(chat)
    # 2 You: msgs, 2 other msgs. 2 <= 2*2 is true, so no penalty.
    # interest indicators: None in this simple case.
    # base_interest starts at 0.5.
    assert result['interest_level'] >= 0.5

    # Case 2: Over-texting (your_msgs > other_msgs * 2)
    # 3 You vs 1 Them
    chat = "You: Hi\nYou: You there?\nYou: Hello?\nThem: yeah"
    result = await service.analyze_chat(chat)
    # your_msgs = 3, other_msgs = 1. 3 > 1*2 is true.
    # interest indicators: 'yeah' is in interest_indicators.
    # interest_count = 1, disinterest_count = 0.
    # base_interest = 0.7.
    # Penalty: 0.7 - 0.15 = 0.55.
    # Fixed float comparison bug
    assert abs(result['interest_level'] - 0.55) < 1e-9

    # Case 3: Serious Over-texting (your_msgs > other_msgs * 3)
    # 4 You vs 1 Them
    chat = "You: Hi\nYou: You there?\nYou: Hello?\nYou: Hey??\nThem: yeah"
    result = await service.analyze_chat(chat)
    assert "You're over-texting - try waiting for them to respond" in result['red_flags']

@pytest.mark.asyncio
async def test_analyze_chat_empty_lines():
    service = NIMService()
    chat = "You: Hi\n\n   \nThem: Hello"
    result = await service.analyze_chat(chat)
    # your_msgs = 1, other_msgs = 1.
    assert result['interest_level'] >= 0.5
