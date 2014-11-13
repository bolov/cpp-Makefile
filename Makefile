#  Template Makefile
#  Bălan Mihail <mihail.balan@gmail.com>

#file related variables

SRC_DIR = src
BUILD_DIR = build
BIN_DIR = bin

APP_NAME = dreamflight
APP_SOURCES_NO_DIR = main.cpp

APP_SOURCES = $(addprefix $(SRC_DIR)/, $(APP_SOURCES_NO_DIR))
APP_OBJS = $(addprefix $(BUILD_DIR)/,  $(APP_SOURCES_NO_DIR:.cpp=.o))
APP_D = $(APP_OBJS:.o=.d)

SOURCES := $(shell find \( -name '*.c' -o -name '*.cpp' \) -printf '%P ')
HEADERS := $(shell find \( -name '*.h' -o -name '*.hpp' \) -printf '%P ')


#compiler related variables

CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -Werror -g
LDFLAGS =

#bulds, targets & rules

build: $(BIN_DIR)/$(APP_NAME)
.PHONY:build

build_metadata: tags cscope.out
.PHONY: build_metadata

$(BIN_DIR)/$(APP_NAME): $(APP_OBJS)
	@mkdir -p $(@D)
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS)

$(APP_OBJS):$(BUILD_DIR)/%.o:$(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) -o $@ -c $(CXXFLAGS) $<

#generated makefiles for automatic prerequisites of the included header files
# -M all headers; -MM ignore system
# -MG assume missing header
# -MT change target
$(APP_D):$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp
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
	rm -fv $(BUILD_DIR)/* $(BIN_DIR)/*
.PHONY: clean

clean_all: clean
	rm -fv tags cscope.out
.PHONY: clean_all

