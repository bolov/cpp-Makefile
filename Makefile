#  Template Makefile
#  Bălan Mihail <mihail.balan@gmail.com>

# WARNING
# Does not work with filenames containing whitespaces

# Usage:
# make [rule] [build={debug/relase}]


PROJ_DIR := .

APP_NAME := dreamflight
APP_SOURCES := main.cpp required.cpp

optimization_flags.debug   :=
optimization_flags.release := -flto -O3

warning_flags.all := -Wall -Wextra -Werror
warning_flags.debug := -Wno-error=unused-variable \
                       -Wno-error=unused-function \
                       -Wno-error=unused-value \
                       -Wno-error=unused-parameter \
                       -Wno-error=unused-local-typedefs
warning_flags.release :=

CXX := g++
CXXFLAGS := -std=c++14 -g
LDFLAGS :=

DEBUGGER := cgdb

include MakefileFooter

include BatchMakefile
