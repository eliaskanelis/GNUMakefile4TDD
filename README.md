## GNU Makefile project for cross-compile and TDD in C

## Description

> Opinionated GNU Make based build system for cross-compile and Test driven development in C for
> dual-targeted environments

Uses **stm32f072rb** and **tm4c123gh6pm** micro-controllers but it can adapt to any
embedded platform.

It can be used for embedded development of for any non-embedded application.

## WARNING

I designed a better makefile based build system and in the next weeks/months it will be integrated here.
This means that the current functionality will change after the update happens.

Hint: The main change will be the use of python scripts to abstract tools such as linting, flashing, etc from the main functionality of the build system that is to compile and link.

## Goals

1. Test driven development (cppUtest)
2. Multi-architecture Build (GNU/Linux & micro-controller)
3. Test driven development (cppUtest)
4. Lint (pc-lint, cppcheck etc)
5. Documentation generation (doxygen)
6. Flash, erase etc. micro-controller
7. Debugging (gdb or other)
8. Auto versioning( git or other )
9. Color output
10. Support C/C++ and assembly. (Rust?)
11. Auto-dependency in build rules.
12. Automatic dev tool setup (Conan)

## Filesystem

The filesystem of the project is opinionated and these are the main

- bin

	Output binaries, libraries, map file not kept under version control.

- conf (optional)

	Stored configurations for tools.

- inc

	Header files part of the output library.

- port (optional)

	One sub-directory per port.

- scripts

	Scripts used by the CI/CD system or the build system.

- src

	Source files part of the output library.

- tests (optional)

	Test cases for the code written. (cpputest)

- thirdparty (optional)

	Thirdparty code

- tmp

	Generated files not kept under version control.

## Dependencies

The makefile can run with [devtools](https://hub.docker.com/r/tedicreations/devtools) docker image.

```sh
docker pull tedicreations/devtools
```

## Usage

### Building

The makefile supports building the same hardware independent code with different ports.
First identify the [available ports](port) (if any):

If there are no ports start building like this:

```sh
make
```

If there are ports then run it like this:

```sh
make PORT_NAME=<port name>
```

### Test driver development

A ccputest based test will run at the end of every succesfull build.

## License

See `LICENSE` for more information.


## Contact

Kanelis Ilias - [email me](mailto:hkanelhs@yahoo.gr)
