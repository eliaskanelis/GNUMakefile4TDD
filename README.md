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

- [x] Test driven development (cppUtest)
- [x] Multi-architecture Build (GNU/Linux & micro-controller)
- [x] Multiple targets
- [ ] Lint (pc-lint, cppcheck etc)
- [ ] Documentation generation (doxygen)
- [x] Flash, erase etc. micro-controller
- [x] Debugging (gdb or other)
- [x] Auto versioning( git or other )
- [x] Color output
- [x] Support C/C++ and assembly.
- [ ] Support Rust. Experimental feature.
- [x] Auto-dependency in build rules.
- [ ] Automatic dev tool setup (Conan)

## Filesystem

The filesystem of the project is opinionated and these are the main

- **apps**: Source files that are part of a target. Each subdirectory a seperate target.
- **bin**: Output binaries, libraries, map file not kept under version control.
- **components** (optional): Components that use the same opinionated filesystem. Usually git submodules.
- **conf** (optional): Stored configurations for tools.
- **inc**: Header files part of the output library.
- **port** (optional): One sub-directory per port.
- **scripts**: Scripts used by the CI/CD system or the build system.
- **src**: Source files part of the output library.
- **tests** (optional): Test cases for the code written. (cpputest)
- **thirdparty** (optional): Thirdparty code
- **tmp**: Generated files not kept under version control.

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

## Known bugs

After v0.5 (Multi-target update): Intermediate files are automatically removed.

## License

See `LICENSE` for more information.


## Contact

Kanelis Elias - [email me](mailto:e.kanelis@voidbuffer.com)
