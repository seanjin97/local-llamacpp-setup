#!/bin/sh

# NVIDIA 4070 12GB vRAM, CPU 32GB RAM: ~22 t/s. 
# Slightly slower, and lower quality result (based on my eyeballs) compared to additional tuning @test.sh. But, less might be more in this case.

# HuggingFace cache directory for downloaded GGUF weights
export LLAMA_CACHE="unsloth/Qwen3.6-35B-A3B-GGUF"

./llama.cpp/llama-server \
    -hf unsloth/Qwen3.6-35B-A3B-GGUF:Q6_K_XL \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --presence-penalty 0.0 \
    --min-p 0.00 \
    -c 32000 # context size