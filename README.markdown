C++ Makefile

## Install

### Using submodules

```Shell
git submodule add git@github.com:bolov/cpp-Makefile.git Makefile.d
cp Makefile.d/TemplateMakefile Makefile
```

### Using wget

```Shell
mkdir Makefile.d && cd Makefile.d
https://raw.githubusercontent.com/bolov/cpp-Makefile/master/TemplateMakefile
https://raw.githubusercontent.com/bolov/cpp-Makefile/master/MakefileFooter
https://raw.githubusercontent.com/bolov/cpp-Makefile/master/BatchMakefile
mv TemplateMakefile ../Makefile
```

## Usage

```Shell
make [rule] [build={debug|relase}]
```

default rule: `build` <br>
default build: `debug`

e.g.


```Shell
make
make build
make run

make build build=debug
make run build=debug

make build build=relase
make run build=relase

make debug
```
