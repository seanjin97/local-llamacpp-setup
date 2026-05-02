#!/bin/sh

# NVIDIA 4070 12GB vRAM, CPU 32GB RAM: ~21 t/s, okay with big context. Maybe less is more

# HuggingFace cache directory for downloaded GGUF weights
export LLAMA_CACHE="unsloth/Qwen3.6-35B-A3B-GGUF"

./llama.cpp/llama-server \
    # ── Model Source ──────────────────────────────────────────────
    -hf unsloth/Qwen3.6-35B-A3B-GGUF:Q6_K_XL \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --presence-penalty=0.0 \
    --min-p 0.00 \
    --ctx-size 131072