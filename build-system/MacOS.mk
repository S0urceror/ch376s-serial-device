COMPILER = clang
COMPILER_FLAGS = -g -c -DDEBUG
COMPILER_OUTPUT_DIR = 
LNK = clang
LNK_OUTPUT_DIR = ./build-macos
LNK_FLAGS = -g
OBJS := $(LNK_OUTPUT_DIR)/main-macos.o $(LNK_OUTPUT_DIR)/device.o
BIN := $(LNK_OUTPUT_DIR)/main-macos

all: $(LNK_OUTPUT_DIR)/main-macos

$(LNK_OUTPUT_DIR)/main-macos.o: main-macos.c
	$(COMPILER) $(COMPILER_FLAGS) -o $@ $< 
$(LNK_OUTPUT_DIR)/device.o: device.c
	$(COMPILER) $(COMPILER_FLAGS) -o $@ $< 

$(BIN): $(OBJS)
	$(LNK) $(LNK_FLAGS) -o $@ $^ 

clean:
	-rm $(OUTPUT_DIR)/*.*