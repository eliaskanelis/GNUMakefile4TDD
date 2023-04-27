#!/usr/bin/env bash

# Lints C/C++ code

set -euo pipefail

buildDir="obj/cppcheck"

mkdir -p "${buildDir}"

# Check posix
cppcheck --quiet --std=c99 --enable=warning --error-exitcode=1 --force \
	 --cppcheck-build-dir="${buildDir}" \
	 --addon=conf/cppcheck/misra.json \
	 -Iport -Isrc \
	 -i port/stm32f072rb -i port/tm4c123gh6pm \
	 -i thirdparty -i tests .

# Check stm32f072rb
cppcheck --quiet --std=c99 --enable=warning --error-exitcode=1 --force \
	 --cppcheck-build-dir="${buildDir}" \
	 --addon=conf/cppcheck/misra.json \
	 -Iport -Isrc \
	 -i port/posix -i port/stm32f072rb/sys -i port/tm4c123gh6pm \
	 -i thirdparty -i tests .

# Check tm4c123gh6pm
cppcheck --quiet --std=c99 --enable=warning --error-exitcode=1 --force \
	 --cppcheck-build-dir="${buildDir}" \
	 --addon=conf/cppcheck/misra.json \
	 -Iport -Isrc \
	 -i port/posix -i port/stm32f072rb -i port/tm4c123gh6pm/sys \
	 -i thirdparty -i tests .
