#  Template Makefile
#  Bălan Mihail <mihail.balan@gmail.com>

# WARNING
# Does not work with filenames containing whitespaces

# Usage:
# ==============================================================================
# make [rule] [build={debug/relase}]


# Makefile related variables
# ==============================================================================

# set BUILD variable
build ?= debug
BUILD := $(build)

# throw error if invalid BUILD
VALID_BUILDS := debug release
ifeq (,$(findstring $(BUILD), $(VALID_BUILDS)))
  $(error error invalid build '$(BUILD)'. Expected one of '$(VALID_BUILDS)')
endif

# File/Folder related variables
# ==============================================================================

PROJ_DIR  := .

SRC_DIR   := $(PROJ_DIR)/src
BUILD_DIR := $(PROJ_DIR)/build/$(BUILD)
BIN_DIR   := $(PROJ_DIR)/bin/$(BUILD)

APP_NAME := dreamflight
APP_SOURCES_NO_DIR := main.cpp required.cpp

APP_OBJS := $(addprefix $(BUILD_DIR)/,  $(APP_SOURCES_NO_DIR:.cpp=.o))
APP_D := $(APP_OBJS:.o=.d)

#used for ctags and cscope
SOURCES := $(shell find $(SRC_DIR) \( -name '*.c' -o -name '*.cpp' \) )
HEADERS := $(shell find $(SRC_DIR) \( -name '*.h' -o -name '*.hpp' \) )

# Compiler related variables
# ==============================================================================

optimization_flags.debug   :=
optimization_flags.release := -flto -O3
OPTIMIZATION_FLAGS := $(optimization_flags.$(BUILD))

CXX := g++
CXXFLAGS := -std=c++14 $(OPTIMIZATION_FLAGS) -Wall -Wextra -Werror -g
LDFLAGS :=

DEBUGGER := cgdb

# Builds, targets & rules
# ==============================================================================

build: $(BIN_DIR)/$(APP_NAME)
.PHONY:build

build_metadata: tags cscope.out
.PHONY: build_metadata

run: build
	$(BIN_DIR)/$(APP_NAME)
.PHONY:run

debug: build
	$(DEBUGGER) $(BIN_DIR)/$(APP_NAME)

# build executable
$(BIN_DIR)/$(APP_NAME): $(APP_OBJS)
	@mkdir -p $(@D)
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

# build objects (compilation units)
$(APP_OBJS):$(BUILD_DIR)/%.o:$(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) -o $@ -c $(CXXFLAGS) $<

#generated makefiles for automatic prerequisites of the included header files
# -M all headers; -MM ignore system
# -MG assume missing header
# -MT change target
$(APP_D):$(BUILD_DIR)/%.d:$(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	@$(CXX) -o $@ -MM -MG -MT $(@:.d=.o) -MT $@ $(CXXFLAGS) $<

#include the makefiles with the automatic prerequisites of the included header
#files
-include $(APP_D)


tags: $(SOURCES) $(HEADERS)
	ctags -f $@ -R $(SRC_DIR)

cscope.out: $(SOURCES) $(HEADERS)
	cscope -f$@ -Rb

clean:
	rm -fv $(BUILD_DIR)/* $(BIN_DIR)/*
.PHONY: clean

clean_all: clean
	rm -fv tags cscope.out
.PHONY: clean_all

