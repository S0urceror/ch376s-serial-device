# tools
CPP = sdcc
ASM = sdasz80
HEXBIN = hex2bin

# compiler flags
VERBOSE = --verbose
DEFINES = #-DDEBUG
PLATFORM = -mz80
ADDR_CODE = 0x801c
ADDR_DATA = 0xc800
CPP_FLAGS = $(VERBOSE) $(PLATFORM) -c $(DEFINES)
CPP_OUTPUT_DIR = ./build-msx/objs
CRT0_SRC_DIR = ./build-msx/MSX/ROM

LNK = sdcc
LNK_OUTPUT_DIR = ./build-msx/bin
LNK_FLAGS = -mz80 --code-loc $(ADDR_CODE) --data-loc $(ADDR_DATA) --no-std-crt0
LIBS_DIR = ./build-msx/libs

OBJS := $(CPP_OUTPUT_DIR)/msxromcrt0.rel $(CPP_OUTPUT_DIR)/main-msx.rel $(CPP_OUTPUT_DIR)/device.rel $(CPP_OUTPUT_DIR)/hooks_msx.rel $(CPP_OUTPUT_DIR)/workarea_msx.rel $(CPP_OUTPUT_DIR)/keyboard_msx.rel $(CPP_OUTPUT_DIR)/filesystem_msx.rel  $(CPP_OUTPUT_DIR)/screen_msx.rel
BIN := $(LNK_OUTPUT_DIR)/usbdev.rom
IHX := $(LNK_OUTPUT_DIR)/usbdev.ihx
HEX2BIN := hex2bin

all: $(BIN)

$(CPP_OUTPUT_DIR)/main-msx.rel: main-msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/device.rel: device.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/hooks_msx.rel: hooks_msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/workarea_msx.rel: workarea_msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/keyboard_msx.rel: keyboard_msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/filesystem_msx.rel: filesystem_msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/screen_msx.rel: screen_msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/msxromcrt0.rel: $(CRT0_SRC_DIR)/msxromcrt0.s
	$(ASM) -o $@ $< 

$(IHX): $(OBJS)
	$(LNK) $(LNK_FLAGS) -o $@ $^ 

$(BIN): $(IHX)
	$(HEX2BIN) -e rom $^

clean:
	-rm $(CPP_OUTPUT_DIR)/*.*
	-rm $(LNK_OUTPUT_DIR)/*.*