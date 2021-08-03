# tools
CPP = sdcc
ASM = sdasz80
HEXBIN = hex2bin

# compiler flags
VERBOSE = --verbose
PLATFORM = -mz80
CRT0 = crt0_msxdos_advanced.rel
ADDR_CODE = 0x401c
ADDR_DATA = 0xc000
CPP_FLAGS = $(VERBOSE) $(PLATFORM) -c 
CPP_OUTPUT_DIR = ./build-msx/objs
CRT0_SRC_DIR = ./build-msx/MSX/ROM

LNK = sdcc
LNK_OUTPUT_DIR = ./build-msx/bin
LNK_FLAGS = -mz80 --code-loc $(ADDR_CODE) --data-loc $(ADDR_DATA) --no-std-crt0
LIBS_DIR = ./build-msx/libs

OBJS := $(CPP_OUTPUT_DIR)/msxromcrt0.rel $(CPP_OUTPUT_DIR)/main-msx.rel $(CPP_OUTPUT_DIR)/device.rel  
BIN := $(LNK_OUTPUT_DIR)/usbdev.rom
IHX := $(LNK_OUTPUT_DIR)/usbdev.ihx
HEX2BIN := hex2bin

all: $(BIN)

$(CPP_OUTPUT_DIR)/main-msx.rel: main-msx.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/device.rel: device.c
	$(CPP) $(CPP_FLAGS) -o $@ $< 
$(CPP_OUTPUT_DIR)/msxromcrt0.rel: $(CRT0_SRC_DIR)/msxromcrt0.s
	$(ASM) -o $@ $< 

$(IHX): $(OBJS)
	$(LNK) $(LNK_FLAGS) -o $@ $^ 

$(BIN): $(IHX)
	$(HEX2BIN) -e rom $^

clean:
	-rm $(OUTPUT_DIR)/*.*