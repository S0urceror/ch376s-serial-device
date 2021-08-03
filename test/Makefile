OUTPUT_DIR = bin
#sjasmplus
ASM = sjasmplus
ASMFLAGS = --fullpath --raw=$@ --sym=$(basename $@).sym --lst=$(basename $@).lst

all: $(OUTPUT_DIR)/hello.com

$(OUTPUT_DIR)/hello.com: helloworld.asm
	$(ASM) $(ASMFLAGS) $<
	bin2hex.py --offset=0xa000 $@ > $(basename $@).hex

clean:
	-rm $(OUTPUT_DIR)/*.com
