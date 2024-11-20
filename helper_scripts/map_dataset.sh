#!/bin/bash

declare -A DATASET_IDS_MAP

input=$(echo "$1" | tr '=' ' ')

elements=($input)

for ((i=0; i<${#elements[@]}; i+=2)); do
  key="${elements[$i]}"
  value="${elements[$i+1]}"
  DATASET_IDS_MAP["$key"]="$value"
done