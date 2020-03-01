### GNU Makefile project for cross-compile and TDD in C

[![Build Status](https://travis-ci.org/TediCreations/GNUMakefile4TDD.svg?branch=master)](https://travis-ci.org/TediCreations/GNUMakefile4TDD)

*SOS: Someone please help me set Travis CI correctly...*

### Description

> GNU Make makefile for cross-compile and Test driven development in C for
> dual-targeted environments

Uses the **STM32F072RB** micro-controller from ST but it can adapt to any
embedded platform.

### WARNING

I designed a better makefile based build system and in the next weeks/months it will be integrated here.
This means that the current functionality will change after the update happens.

Hint: The main change will be the use of python scripts to abstract tools such as linting, flashing, etc from the main functionality of the build system that is to compile and link.

### Goals

All of these are satisfied but need improvement.

1. Test driven development (cppUtest)
2. Multi-architecture Build (GNU/Linux & micro-controller)
3. Lint (pc-lint)
4. Documentation generation (doxygen)
5. Flash, erase etc. micro-controller
6. Debugging (gdb or other)
7. Auto versioning( git or other )
8. Color output
9. Support C/C++ and assembly.
10. Auto-dependency in build rules.

### Dependencies

Required:

Under GNU/Linux environment( Makefile is not tested on Windows or Mac OS )

1. GNU make
2. gcc
3. g++
4. gdb debugger
5. wine
6. pc-lint.exe (with wine)
7. valgrind
8. sed
9. perl
10. tput
11. git
12. doxygen
13. graphviz
14. cppUtest

```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install make
sudo apt-get install build-essential
sudo apt-get install gdb
#sudo apt-get install wine( build from Github script )
sudo apt-get install valgrind
#sudo apt-get install sed
sudo apt-get install perl
sudo apt-get install libncurses5-dev libncursesw5-dev
sudo apt-get install git
sudo apt-get install doxygen
sudo apt-get install graphviz
#sudo apt-get install cpputest( build from Github )
```

Optional:

1. Segger JLink drivers
2. Saleae logic analyser
3. picocom
4. firefox

```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install picocom
sudo apt-get install firefox
```

### How to use

To see available targets and help information:

```sh
make help
```

Build host, target and tests:

```sh
make all
```

### Maintainer

[Kanelis Ilias](mailto:hkanelhs@yahoo.gr)

### License

[MIT](LICENSE) © Kanelis Ilias
