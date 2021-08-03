MAKE := make

.PHONY: Teensy
Teensy:
	$(MAKE) -f ./build-system/Teensy.mk all

.PHONY: MacOS
MacOS: 
	$(MAKE) -f ./build-system/MacOS.mk all
	
.PHONY: MSX
MSX: 
	$(MAKE) -f ./build-system/MSX.mk all
	