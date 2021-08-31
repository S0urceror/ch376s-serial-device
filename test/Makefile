OUTPUT_DIR = bin
#sjasmplus
ASM = sjasmplus
ASMFLAGS = --fullpath --raw=$@ --sym=$(basename $@).sym --lst=$(basename $@).lst

all: $(OUTPUT_DIR)/hello.raw $(OUTPUT_DIR)/loadfile.raw $(OUTPUT_DIR)/showslots.raw

$(OUTPUT_DIR)/hello.raw: helloworld.asm
	$(ASM) $(ASMFLAGS) $<
	bin2hex.py --offset=0xd000 $@ > $(basename $@).hex

$(OUTPUT_DIR)/loadfile.raw: loadfile.asm
	$(ASM) $(ASMFLAGS) $<
	bin2hex.py --offset=0xd000 $@ > $(basename $@).hex

$(OUTPUT_DIR)/showslots.raw: showslots.asm
	$(ASM) $(ASMFLAGS) $<
	bin2hex.py --offset=0xd000 $@ > $(basename $@).hex


clean:
	-rm $(OUTPUT_DIR)/*.com
