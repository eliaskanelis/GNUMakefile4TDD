#!/usr/bin/env bash

# Lints C/C++ code

set -euo pipefail

# Misra C is disabled for now
# --addon=misra

cppcheck --quiet --std=c99 --enable=warning --error-exitcode=1 --force \
	 --addon=conf/cppcheck/misra.json \
	 -i port -i thirdparty -i tests .
