#  Template Makefile
#  Bălan Mihail <mihail.balan@gmail.com>

#file related variables

# set BUILD variable
ifndef BUILD
	ifndef build
		BUILD = debug
	else
		BUILD = $(build)
	endif
endif

# convert to lowercase
BUILD := $(shell echo $(BUILD) | tr '[:upper:]' '[:lower:]')

# set BUILD_PREFIX and throw error if invalid BUILD
ifeq ($(BUILD), debug)
BUILD_PREFIX = debug_
else ifeq ($(BUILD), release)
BUILD_PREFIX = release_
else
$(error error invalid BUILD value '$(BUILD)'. Expected 'debug' or 'release'\
	(case insensitive))
endif

SRC_DIR = src
BUILD_DIR = $(BUILD_PREFIX)build
BIN_DIR = $(BUILD_PREFIX)bin

APP_NAME = dreamflight
APP_SOURCES_NO_DIR = main.cpp

APP_SOURCES = $(addprefix ./$(SRC_DIR)/, $(APP_SOURCES_NO_DIR))
APP_OBJS = $(addprefix ./$(BUILD_DIR)/,  $(APP_SOURCES_NO_DIR:.cpp=.o))
APP_D = $(APP_OBJS:.o=.d)

SOURCES := $(shell find \( -name '*.c' -o -name '*.cpp' \) -printf '%P ')
HEADERS := $(shell find \( -name '*.h' -o -name '*.hpp' \) -printf '%P ')


#compiler related variables

ifeq ($(BUILD), release)
	OPTIMIZATION_FLAGS = -flto -O3
endif

CXX = g++
CXXFLAGS = -std=c++14 $(OPTIMIZATION_FLAGS) -Wall -Wextra -Werror -g
LDFLAGS =

DEBUGGER = cgdb

#bulds, targets & rules

build: ./$(BIN_DIR)/$(APP_NAME)
.PHONY:build

build_metadata: tags cscope.out
.PHONY: build_metadata

run: build
	./$(BIN_DIR)/$(APP_NAME)
.PHONY:run

debug: build
	$(DEBUGGER) ./$(BIN_DIR)/$(APP_NAME)


$(BIN_DIR)/$(APP_NAME): $(APP_OBJS)
	@mkdir -p $(@D)
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

$(APP_OBJS):./$(BUILD_DIR)/%.o:./$(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) -o $@ -c $(CXXFLAGS) $<

#generated makefiles for automatic prerequisites of the included header files
# -M all headers; -MM ignore system
# -MG assume missing header
# -MT change target
$(APP_D):./$(BUILD_DIR)/%.d: ./$(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	@$(CXX) -o $@ -MM -MG -MT $(@:.d=.o) -MT $@ $(CXXFLAGS) $<

#include the makefiles with the automatic prerequisites of the included header
#files
-include $(APP_D)


tags: $(SOURCES) $(HEADERS)
	@mkdir -p $(@D)
	ctags -f $@ -R ./

cscope.out: $(SOURCES) $(HEADERS)
	@mkdir -p $(@D)
	cscope -f$@ -Rb

clean:
	rm -fv ./$(BUILD_DIR)/* ./$(BIN_DIR)/*
.PHONY: clean

clean_all: clean
	rm -fv tags cscope.out
.PHONY: clean_all

