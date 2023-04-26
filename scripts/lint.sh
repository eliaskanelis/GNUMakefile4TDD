#!/usr/bin/env bash

# Various lints

set -euo pipefail


# Lind all bash scripts in the directory recursively.
find . -type f -not -path '*/\.git/*'  -exec file {} + | \
          grep "shell script" | \
          cut -d: -f1 | \
          xargs -I{} sh -c 'shellcheck --shell=bash --check-sourced --external-sources "{}"'
