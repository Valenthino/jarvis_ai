"""Small Linux/browser compatibility layer for the Jarvis server.

The upstream server only uses RealtimeSTT's AudioToTextRecorder as a wrapper
around browser-provided PCM. A microphone backend is unnecessary in Coolify;
use faster-whisper directly and keep the original server protocol intact.
"""

from __future__ import annotations

import numpy as np
from faster_whisper import WhisperModel


class AudioToTextRecorder:
    def __init__(self, model: str, device: str = "cpu", compute_type: str = "int8", **_kwargs):
        self.model = WhisperModel(model, device=device, compute_type=compute_type)

    def feed_audio(self, _samples: np.ndarray, original_sample_rate: int = 16000) -> None:
        # Browser audio is passed directly to perform_final_transcription.
        return None

    def perform_final_transcription(self, samples: np.ndarray, _use_vad: bool = True) -> str:
        segments, _info = self.model.transcribe(
            samples,
            language="en",
            beam_size=1,
            vad_filter=False,
        )
        return " ".join(segment.text.strip() for segment in segments).strip()

    def clear_audio_queue(self) -> None:
        return None
