#!/bin/sh
# This is not working
export LLAMA_CACHE="unsloth/Qwen3.6-35B-A3B-GGUF"

./llama.cpp/llama-server --models-preset models.ini