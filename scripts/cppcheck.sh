#!/usr/bin/env bash

# Lints C/C++ code

set -euo pipefail

# Misra C is disabled for now
# --addon=misra

cppcheck --quiet --std=c99 --enable=all --error-exitcode=1 --force \
	 -i port -i thirdparty -i tests .
