#!/bin/sh
set -eu


set_default_env_vars() {
  if [ -z ${LLAMA_HOST+x} ]; then
    export LLAMA_HOST="0.0.0.0"
  fi
  if [ -z ${LLAMA_N_GPU_LAYERS+x} ]; then
    export LLAMA_N_GPU_LAYERS=99
  fi
}

convert_llama_env_vars() {
  LLAMA_ARGS=$(env | grep LLAMA_ | awk '{
    # for each environment variable
    for (n = 1; n <= NF; n++) {
      # replace LLAMA_ prefix with --
      sub("^LLAMA_", "--", $n)
      # find first = and split into argument name and value
      eq = index($n, "=")
      s1 = tolower(substr($n, 1, eq - 1))
      s2 = substr($n, eq + 1)
      # replace _ with - in argument name
      gsub("_", "-", s1)
      # print argument name and value
      print s1 " " s2
    }
  }')
}

# parse_args_download_model "$@"
set_default_env_vars
convert_llama_env_vars

set -x
llama-server  -m /models/granite-7b-lab-Q4_K_M.gguf  $LLAMA_ARGS