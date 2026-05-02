#!/bin/sh

# NVIDIA 4070 12GB vRAM, CPU 32GB RAM: ~22 t/s, but struggles with big context

# HuggingFace cache directory for downloaded GGUF weights
export LLAMA_CACHE="unsloth/Qwen3.6-35B-A3B-GGUF"

./llama.cpp/llama-server \
    # ── Model Source ──────────────────────────────────────────────
    -hf unsloth/Qwen3.6-35B-A3B-GGUF:Q6_K_XL \

    # ── Hardware / Performance ────────────────────────────────────
    # Threads for generation (8 is a good balance on most CPUs)
    --threads 8 \
    # Threads for batch/prompt processing (16 = 2x, helps prefill throughput)
    --threads-batch 16 \
    # Logical batch size during generation — larger = better throughput but more VRAM
    --batch-size 4096 \
    # Physical micro-batch size — controls how many tokens processed per forward pass
    --ubatch-size 4096 \
    # Offload all layers to GPU (MoE model: experts are split, this pushes weights)
    --gpu-layers 999 \
    # Keep MoE expert weights on CPU for Qwen3.6-A3B — critical for VRAM management
    --cpu-moe \
    # Enable Flash Attention on RTX 4070 (Ada architecture supports it natively)
    --flash-attn on \
    # Force model to fit in device memory with the given constraints
    # --fit on \

    # ── Context / KV Cache ────────────────────────────────────────
    # Context window: 131K tokens (full model capability)
    --ctx-size 131072 \
    # Quantize K cache to Q8_0 — saves ~50% VRAM vs F16 with negligible quality loss
    --cache-type-k q8_0 \
    # Quantize V cache to Q8_0 — same benefit as above
    --cache-type-v q8_0 \
    # Max CPU RAM for KV cache offloading (MiB) — 8GB is plenty on a 32GB system
    --cache-ram 8192 \
    # Use unified KV buffer shared across all sequences (better for single-slot server)
    --kv-unified \
    # Enable context shift: circular buffer when context exceeds ctx-size
    --context-shift \
    # Sliding Window Attention for long contexts — reduces O(n²) scaling
    --swa-full \
    # Min chunk size for KV cache reuse via shifting (512 tokens = good granularity)
    --cache-reuse 512 \
    # Disable mmap — faster on some systems, uses more RAM
    --no-mmap true \

    # ── Sampling Parameters ───────────────────────────────────────
    # Temperature: balanced creativity (0.6 is a sweet spot for Qwen)
    --temp 0.6 \
    # Top-p nucleus sampling: consider tokens with cumulative prob >= 95%
    --top-p 0.95 \
    # Top-k: restrict to top 20 most probable tokens
    --top-k 20 \
    # Min-p: minimum relative probability (0.0 = disabled)
    --min-p 0.00 \
    # Locally typical sampling: p=0.5 encourages naturally diverse output
    --typical-p 0.5 \
    # DRY (Don't Repeat Yourself) repetition penalty — strong for code/technical text
    --dry-multiplier 1.5 \
    --dry-base 1.75 \
    --dry-allowed-length 2 \
    --dry-penalty-last-n -1 \
    # Presence penalty: >0 encourages topic variety, discourages repetition
    --presence-penalty 0 \
    # Repeat penalty for token sequences (1.0 = no penalty)
    --repeat-penalty 1.00 \
    # Consider last N tokens for repeat penalty (-1 = full context)
    --repeat-last-n -1 \

    # ── Generation Limits ─────────────────────────────────────────
    # Max tokens to generate per response (32K)
    -n 32768 \
    # Fixed seed for reproducibility (set to -1 for random)
    --seed -1 \

    # ── Reasoning / Chat Template ─────────────────────────────────
    # Enable chain-of-thought reasoning mode
    --reasoning on \
    # Use Jinja templating (more flexible than default parser)
    --jinja \
    # Preserve <thinking> blocks in the output
    --chat-template-kwargs '{"preserve_thinking": true}' \
    # Max tokens for the thinking block before forcing answer
    --reasoning-budget 8096 \
    # Message injected when reasoning budget is exhausted
    --reasoning-budget-message "Okay, enough thinking no more waiting. Let's just jump to it." \

    # ── Server Settings ───────────────────────────────────────────
    # HTTP API server port
    --port 8001 \
    # Single slot (no parallel request handling — simplest, most stable)
    --parallel 1 \
    # Enable Prometheus metrics endpoint at /metrics
    --metrics \
    # Disable web UI (we're using API only)
    --no-webui \
    # Don't load multimodal projector (text-only model)
    --no-mmproj
