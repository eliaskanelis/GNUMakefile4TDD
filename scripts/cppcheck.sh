#!/usr/bin/env bash

# Lints C/C++ code

set -euo pipefail

buildDir="gen/cppcheck"

mkdir -p "${buildDir}"

# Get the include paths of all components
component_include_flags=()

if [ -d "components" ]; then
    while IFS= read -r component; do
        echo "Component: $component"
        component_include_flags+=("-Icomponents/$component/inc")
    done < <(find components -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
fi

# For debug
# echo "Include flags:" "${component_include_flags[@]}"

# Run cppcheck
cppcheck --quiet --std=c99 --language=c --error-exitcode=1 --inline-suppr --force \
    --checkers-report="${buildDir}/checkers-report" \
    --cppcheck-build-dir="${buildDir}" \
    --enable=all --inconclusive \
    --check-level=exhaustive \
    --addon=conf/cppcheck/misra.json \
    --addon=threadsafety \
    --suppress=unmatchedSuppression \
    --suppress=missingIncludeSystem \
    --suppress=checkersReport \
    --suppress=misra-c2012-8.7 \
    -Isrc -Iinc \
    -i thirdparty -i tests -i apps -i components -i .venv \
    "${component_include_flags[@]}" \
    .
