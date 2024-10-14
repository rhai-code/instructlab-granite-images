#!/bin/sh
set -eu

server_mode=false

usage() {
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h, --help      Display this help message"
 echo " -s, --serve     Enable server mode"
}

set_default_env_vars() {

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

handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
      echo 'hi help'
        usage
        exit 0
        ;;
      -s | --serve)
        set -x
        server_mode=true
        ;;
      *)
        echo "Invalid option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift
  done
}

handle_options "$@"

if [ "$server_mode" = true ]; then
llama-server -m $MODEL_PATH  $LLAMA_ARGS --host 0.0.0.0
else
  llama-cli -m $MODEL_PATH -p "You are a helpful assistant" -cnv $LLAMA_ARGS
fi


