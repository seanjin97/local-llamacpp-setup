#!/bin/sh

# NVIDIA 4070 12GB vRAM, CPU 32GB RAM: ~18 t/s
export LLAMA_CACHE="unsloth/Qwen3.6-35B-A3B-GGUF"
./llama.cpp/llama-server \
    -hf unsloth/Qwen3.6-35B-A3B-GGUF:Q6_K_XL \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.00 \
    --presence-penalty 1.5 \
    --ctx-size 131072
    --chat-template-kwargs '{"preserve_thinking": true}'
    --repeat-penalty 1.00 \
    -n 32768 \
    --no-mmap true \
    --port 8001 \ 
    --reasoning on \ 
    --jinja \ 
    --reasoning-budget 8096 \
    --reasoning-budget-message "Okay, enough thinking no more waiting. Let's just jump to it." \
    --cache-reuse 512 \
    --no-mmproj \
    --fit on
 