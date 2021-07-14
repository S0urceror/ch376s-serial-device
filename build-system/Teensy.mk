########################################################################
# Teensy.mk Makefile
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Adapted from M J Oldfield's Arduino-mk 0.10
# Based on work that is copyright Martin Oldfield, Nicholas Zambetti, 
# David A. Mellis & Hernando Barragan.
#
# Version 0.1  Apr 21 2013 Chris Roehrig <croehrig@house.org>
#		Ported to Teensy
#                      

########################################################################
# Usage:
#
#   Uncomment these lines and set them appropriately according to 
# the Arduino libraries you need:
#
# BOARD_TAG    = teensy3
# ARDUINO_DIR  = /Applications/Arduino.app/Contents/Resources/Java
# ARDUINO_VERSION = 104
# ARDUINO_LIBS = Bounce LiquidCrystal LedControl Encoder
# USER_LIBS = <your own sketchbook libraries>
#
# Or you can set them in a small Makefile and include this file with:
# include Teensy.mk
#
# Use OPTIONS to change the USB mode and language (as well as 
# insert your own defines):
# OPTIONS           = -DLAYOUT_US_ENGLISH -DUSB_SERIAL
# See $(ARDUINO_DIR)/hardware/teensy/build.txt for possible values.
#
# Targets:
#   make             - no upload
#   make clean       - remove all our dependencies
#   make distclean   - remove the build directory
#   make upload      - upload (using Teensy uploader)
#   make reset       - reset the board
#   make raw_upload  - upload without first resetting
#
########################################################################
# for dump target
VARS_ORIG := $(.VARIABLES)

########################################################################
# 
# Default TARGET to cwd (ex Daniele Vergini)
ifndef TARGET
TARGET  = $(notdir $(CURDIR))
endif


########################################################################
# Arduino paths and version

ifndef ARDUINO_VERSION
ARDUINO_VERSION = 104
endif

ifndef ARDUINO_DIR
ARDUINO_DIR=/Applications/Arduino.app/Contents/Resources/Java
endif

# Arduino system libraries
ARDUINO_LIB_PATH  = $(ARDUINO_DIR)/hardware/teensy/avr/libraries

# User libraries
ifndef ARDUINO_SKETCHBOOK
ARDUINO_SKETCHBOOK = $(HOME)/sketchbook
endif
ifndef USER_LIB_PATH
USER_LIB_PATH = $(ARDUINO_SKETCHBOOK)/libraries
endif


########################################################################
# Compiler flags for all builds

ifndef CPPFLAGS
CPPFLAGS          = -g -w -Wall
endif

ifndef OPTIMIZATION
OPTIMIZATION      = -Os
endif
CPPFLAGS         += $(OPTIMIZATION)
LDFLAGS          += $(OPTIMIZATION)

CPPFLAGS         += -DARDUINO=$(ARDUINO_VERSION)
#CPPFLAGS         += -ffunction-sections -fdata-sections

CXXFLAGS         += -fno-exceptions
CXXFLAGS         += -std=gnu++0x -felide-constructors

CFLAGS           += -std=gnu99

ASFLAGS          += -x assembler-with-cpp

LDFLAGS          += -Wl,--gc-sections
#LDFLAGS          += -Wl,--print-gc-sections

ifndef OPTIONS
OPTIONS           = -DLAYOUT_US_ENGLISH -DUSB_SERIAL
endif
CPPFLAGS          += $(OPTIONS)


########################################################################
#  Hardware-dependent config

ifndef BOARD_TAG
BOARD_TAG   = teensy3
endif

########### teensy3
ifeq ($(BOARD_TAG),teensy3)
PRODUCT           = teensy
CPPFLAGS         += -DTEENSY=3
ARCH              = arm-none-eabi
CORE              = teensy3
MCU               = mk20dx128
TOOLS_PATH        = $(ARDUINO_DIR)/hardware/tools
CC_PATH           = $(TOOLS_PATH)/$(ARCH)/bin
CORE_PATH         = $(ARDUINO_DIR)/hardware/$(PRODUCT)/cores/$(CORE)
CPPFLAGS         += -mcpu=cortex-m4 -mthumb -nostdlib
CPPFLAGS         += -D__MK20DX128__
CXXFLAGS         += -fno-rtti
LDFLAGS          += -mcpu=cortex-m4 -mthumb 
# loader script:
LDFLAGS          += -T$(CORE_PATH)/mk20dx128.ld
# these files need to be pulled into every build
BOOT_FILES        = mk20dx128 usb_dev usb_mem
SIZEFLAGS         =
LDLIBS           += -lm
ifndef F_CPU
F_CPU             = 48000000
endif

########### teensy2++
else ifeq ($(BOARD_TAG),teensypp2)
PRODUCT           = teensy
CPPFLAGS         += -DTEENSY=2 -DTEENSYPP
ARCH              = avr
CORE              = teensy
MCU               = at90usb1286
TOOLS_PATH        = $(ARDUINO_DIR)/hardware/tools
CC_PATH           = $(TOOLS_PATH)/$(ARCH)/bin
CORE_PATH         = $(ARDUINO_DIR)/hardware/$(PRODUCT)/avr/cores/$(CORE)
CPPFLAGS         += -mmcu=$(MCU)
LDFLAGS          += -mmcu=$(MCU)
SIZEFLAGS         = -C --mcu=$(MCU)
LDLIBS           += -lm
ifndef F_CPU
F_CPU             = 8000000
endif

########### teensy2
else ifeq ($(BOARD_TAG),teensy2)
PRODUCT           = teensy
CPPFLAGS         += -DTEENSY=2
ARCH              = avr
CORE              = teensy
MCU               = atmega32u4
TOOLS_PATH        = $(ARDUINO_DIR)/hardware/tools
CC_PATH           = $(TOOLS_PATH)/$(ARCH)/bin
CORE_PATH         = $(ARDUINO_DIR)/hardware/$(PRODUCT)/avr/cores/$(CORE)
CPPFLAGS         += -mmcu=$(MCU)
LDFLAGS          += -mmcu=$(MCU)
SIZEFLAGS         = -C --mcu=$(MCU)
LDLIBS           += -lm
ifndef F_CPU
F_CPU             = 8000000
endif

########### teensy1++
else ifeq ($(BOARD_TAG),teensypp1)
PRODUCT           = teensy
CPPFLAGS         += -DTEENSY=1 -DTEENSYPP
ARCH              = avr
CORE              = teensy
MCU               = at90usb646
TOOLS_PATH        = $(ARDUINO_DIR)/hardware/tools
CC_PATH           = $(TOOLS_PATH)/$(ARCH)/bin
CORE_PATH         = $(ARDUINO_DIR)/hardware/$(PRODUCT)/cores/$(CORE)
CPPFLAGS         += -mmcu=$(MCU)
LDFLAGS          += -mmcu=$(MCU)
SIZEFLAGS         = -C --mcu=$(MCU)
LDLIBS           += -lm
ifndef F_CPU
F_CPU             = 8000000
endif

########### teensy1
else ifeq ($(BOARD_TAG),teensypp1)
PRODUCT           = teensy
CPPFLAGS         += -DTEENSY=1
ARCH              = avr
CORE              = teensy
MCU               = at90usb162
TOOLS_PATH        = $(ARDUINO_DIR)/hardware/tools
CC_PATH           = $(TOOLS_PATH)/$(ARCH)/bin
CORE_PATH         = $(ARDUINO_DIR)/hardware/$(PRODUCT)/cores/$(CORE)
CPPFLAGS         += -mmcu=$(MCU)
LDFLAGS          += -mmcu=$(MCU)
SIZEFLAGS         = -C --mcu=$(MCU)
LDLIBS           += -lm
ifndef F_CPU
F_CPU             = 8000000
endif

endif

# Add hardware defines  
CPPFLAGS          += -DF_CPU=$(F_CPU) -DMCU=$(MCU)


########################################################################
# Miscellanea
#

# Names of executables
CC      = $(CC_PATH)/$(ARCH)-gcc
CXX     = $(CC_PATH)/$(ARCH)-g++
OBJCOPY = $(CC_PATH)/$(ARCH)-objcopy
OBJDUMP = $(CC_PATH)/$(ARCH)-objdump
AR      = $(CC_PATH)/$(ARCH)-ar
SIZE    = $(CC_PATH)/$(ARCH)-size
NM      = $(CC_PATH)/$(ARCH)-nm
REMOVE  = rm -f
RMDIR   = rm -rf
MV      = mv -f
CAT     = cat
ECHO    = echo


# Output build directory
ifndef OBJDIR
OBJDIR  	     = build-$(BOARD_TAG)
endif
CORE_OBJDIR      = $(OBJDIR)/core
LIB_OBJDIR       = $(OBJDIR)/lib
USERLIB_OBJDIR   = $(OBJDIR)/userlib


########################################################################
#  Source files
# 

####  Core files
ifeq ($(strip $(NO_CORE)),)
ifdef CORE_PATH
CORE_C_SRCS       = $(wildcard $(CORE_PATH)/*.c)
CORE_CPP_SRCS     = $(wildcard $(CORE_PATH)/*.cpp)

ifneq ($(strip $(NO_CORE_MAIN_CPP)),)
CORE_CPP_SRCS := $(filter-out %main.cpp, $(CORE_CPP_SRCS))
endif

CORE_OBJFILES     = $(CORE_C_SRCS:.c=.o) $(CORE_CPP_SRCS:.cpp=.o)
CORE_OBJS         = $(patsubst $(CORE_PATH)/%,$(CORE_OBJDIR)/%,$(CORE_OBJFILES))
CORE_DEPS         = $(CORE_OBJS:.o=.d)
endif
endif

####  User Libraries
USERLIBS          = $(patsubst %,$(USER_LIB_PATH)/%,$(USER_LIBS))
USERLIB_C_SRCS    = $(wildcard $(patsubst %,%/*.c,$(USERLIBS)))
USERLIB_CPP_SRCS  = $(wildcard $(patsubst %,%/*.cpp,$(USERLIBS)))
USERLIB_OBJFILES  = $(USERLIB_C_SRCS:.c=.o) $(USERLIB_CPP_SRCS:.cpp=.o)
USERLIB_OBJS      = $(patsubst $(USER_LIB_PATH)/%,$(USERLIB_OBJDIR)/%,$(USERLIB_OBJFILES))
USERLIB_DEPS      = $(USERLIB_OBJS:.o=.d)
USERLIB_INCLUDES  = $(patsubst %,-I%,$(USERLIBS))

####  Arduino Libraries
LIBS              = $(patsubst %,$(ARDUINO_LIB_PATH)/%,$(ARDUINO_LIBS))
LIB_C_SRCS        = $(wildcard $(patsubst %,%/*.c,$(LIBS)))
LIB_CPP_SRCS      = $(wildcard $(patsubst %,%/*.cpp,$(LIBS)))
LIB_OBJFILES      = $(LIB_C_SRCS:.c=.o) $(LIB_CPP_SRCS:.cpp=.o)
LIB_OBJS          = $(patsubst $(ARDUINO_LIB_PATH)/%,$(LIB_OBJDIR)/%,$(LIB_OBJFILES))
LIB_DEPS          = $(LIB_OBJS:.o=.d)
LIB_INCLUDES      = $(patsubst %,-I%,$(LIBS))

####  Local sources
LOCAL_C_SRCS      = $(wildcard *.c)
LOCAL_CPP_SRCS    = $(wildcard *.cpp)
LOCAL_CC_SRCS     = $(wildcard *.cc)
LOCAL_PDE_SRCS    = $(wildcard *.pde)
LOCAL_INO_SRCS    = $(wildcard *.ino)
LOCAL_AS_SRCS     = $(wildcard *.S)
LOCAL_OBJFILES    = $(LOCAL_C_SRCS:.c=.o) \
                    $(LOCAL_CPP_SRCS:.cpp=.o) \
                    $(LOCAL_CC_SRCS:.cc=.o) \
                    $(LOCAL_PDE_SRCS:.pde=.o) \
                    $(LOCAL_INO_SRCS:.ino=.o)
                    $(LOCAL_AS_SRCS:.S=.o)
LOCAL_OBJS        = $(patsubst %,$(OBJDIR)/%,$(LOCAL_OBJFILES))
LOCAL_DEPS        = $(LOCAL_OBJS:.o=.d)



########################################################################
#  Final target definitions

TARGET_HEX = $(OBJDIR)/$(TARGET).hex
TARGET_ELF = $(OBJDIR)/$(TARGET).elf

TARGETS = $(TARGET_ELF) $(TARGET_HEX) \
		  $(OBJDIR)/$(TARGET).sym 

BOOT_OBJS  = $(patsubst %,$(CORE_OBJDIR)/%.o,$(BOOT_FILES))

CORE_LIB   = $(OBJDIR)/libcore.a
CORE_LIB_OBJS = $(USERLIB_OBJS) $(LIB_OBJS) $(CORE_OBJS)
CORE_LIB_OBJS := $(filter-out $(BOOT_OBJS), $(CORE_LIB_OBJS) )

OBJS          = $(LOCAL_OBJS) $(USERLIB_OBJS) $(LIB_OBJS) $(CORE_OBJS)

# Include file paths
CPPFLAGS      += -I$(CORE_PATH)
CPPFLAGS      += $(USERLIB_INCLUDES)
CPPFLAGS      += $(LIB_INCLUDES)

# Dependency generation
DEPS           = $(LOCAL_DEPS) $(USERLIB_DEPS) $(LIB_DEPS) $(CORE_DEPS)
DEPFLAGS       = -MMD -MP

########################################################################
########################################################################
#  Targets and build rules
#

all:    $(OBJDIR) $(TARGETS) size upload

$(TARGET_ELF): 	$(BOOT_OBJS) $(LOCAL_OBJS) $(CORE_LIB)
	$(CC) $(LDFLAGS) $+ $(OTHER_OBJS) $(LDLIBS) -o $@

$(CORE_LIB):	$(CORE_LIB_OBJS)
	$(AR) rcs $@ $(CORE_LIB_OBJS)


####  Core files
$(CORE_OBJDIR)/%.o:      $(CORE_PATH)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) -o $@ -c $<

$(CORE_OBJDIR)/%.o:      $(CORE_PATH)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -o $@ -c $<


####  User Libraries
$(USERLIB_OBJDIR)/%.o:    $(USER_LIB_PATH)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) -o $@ -c $<

$(USERLIB_OBJDIR)/%.o:    $(USER_LIB_PATH)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -o $@ -c $<


####  Arduino Libraries
$(LIB_OBJDIR)/%.o:    $(ARDUINO_LIB_PATH)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) -o $@ -c $<

$(LIB_OBJDIR)/%.o:    $(ARDUINO_LIB_PATH)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -o $@ -c $<


####  Local sources
$(OBJDIR)/%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) -o $@ -c $<
$(OBJDIR)/%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -o $@ -c $<
$(OBJDIR)/%.o: %.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -o $@ -c $<
$(OBJDIR)/%.o: %.S
	$(CC) $(CPPFLAGS) $(ASFLAGS) $(DEPFLAGS) -o $@ -c $<
$(OBJDIR)/%.o: %.s
	$(CC) $(CPPFLAGS) $(ASFLAGS) $(DEPFLAGS) -o $@ -c $<




########################################################################
# Special rules
#

# Intermediate source files should be generated into OBJDIR...
$(OBJDIR)/%.cpp: %.pde
	$(ECHO) '#include "WProgram.h"' > $@
	$(CAT)  $< >> $@

$(OBJDIR)%.cpp: %.ino
	$(ECHO) '#include <Arduino.h>' > $@
	$(CAT)  $< >> $@

# various object conversions
%.hex: %.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

%.eep: %.elf
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
		--change-section-lma .eeprom=0 -O ihex $< $@

%.lss: %.elf
	$(OBJDUMP) -h -S $< > $@

%.sym: %.elf
	$(OBJDUMP) -ft $< > $@
#	$(NM) -n $< > $@


size:		$(OBJDIR) $(TARGET_ELF)
		$(SIZE) $(SIZEFLAGS) $(TARGET_ELF)


$(OBJDIR):
		mkdir $(OBJDIR)

clean:
		$(REMOVE) $(OBJS) $(CORE_LIB) $(DEPS) \
		$(OBJDIR)/$(TARGET).lss $(OBJDIR)/$(TARGET).sym \
		$(TARGET_ELF) $(TARGET_HEX)

distclean:
		$(RMDIR) $(OBJDIR)


# for debugging...
dump:
		$(foreach v, \
			$(filter-out $(VARS_ORIG) VARS_ORIG,$(.VARIABLES)), \
			$(info $(v) = $($(v))) \
			$(info ======================================= ) \
		)


.PHONY:	all clean distclean size dump

########################################################################
# Uploading 
#
upload:		reset raw_upload

reset:		
		$(TOOLS_PATH)/teensy_reboot -s

raw_upload:	$(TARGET_HEX)
#		$(TOOLS_PATH)/teensy_post_compile \
			-file=$(basename $(notdir $<)) \
			-path=$(abspath $(dir $<)) \
			-tools=$(TOOLS_PATH)
		$(CURDIR)/build-system/teensy_loader_cli \
			-v -w --mcu=atmega32u4 \
			$<


.PHONY:	upload reset raw_upload 

########################################################################
# Include dependencies
-include $(DEPS)
