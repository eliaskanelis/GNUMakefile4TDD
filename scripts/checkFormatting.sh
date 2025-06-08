find inc apps src tests -regex '.*/.*\.\(c\|cpp\|h\|hpp\)$' | xargs -I {} clang-format -i -verbose --Werror --dry-run {}
