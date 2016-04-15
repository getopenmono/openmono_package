FLASH_SIZE=262144
FLASH_ROW_SIZE=256
FLASH_ARRAY_SIZE=65536
EE_ARRAY=64
EE_ROW_SIZE=16
OPTIMIZATION = -O0
CYPRESS_DIR=$(INCLUDE_DIR)
LINKER_SCRIPT=$(INCLUDE_DIR)/cm3gcc.ld

OBJECTS =		$(patsubst %.c,%.o,$(wildcard *.c)) \
				$(patsubst %.cpp,%.o,$(wildcard *.cpp))

TARGET_HEADERS=	$(wildcard ./*.h) \
				$(wildcard ./*.hpp)

CYLIB_INCLUDES= $(INCLUDE_DIR)

MBED_INCLUDES = $(MONO_FRAMEWORK_PATH)/include/mbed \
				$(MONO_FRAMEWORK_PATH)/include/mbed/api \
				$(MONO_FRAMEWORK_PATH)/include/mbed/hal \
				$(MONO_FRAMEWORK_PATH)/include/mbed/target_cypress \
				$(MONO_FRAMEWORK_PATH)/include/mbed/libraries/fs/sd

MONO_INCLUDES = $(MONO_FRAMEWORK_PATH)/include \
				$(MONO_FRAMEWORK_PATH)/include/display \
				$(MONO_FRAMEWORK_PATH)/include/display/ili9225g \
				$(MONO_FRAMEWORK_PATH)/include/display/ui \
				$(MONO_FRAMEWORK_PATH)/include/media \
				$(MONO_FRAMEWORK_PATH)/include/wireless

TARGET_OBJECTS = $(addprefix $(BUILD_DIR)/, $(OBJECTS))

CC=$(ARCH)gcc
CXX=$(ARCH)g++
LD=$(ARCH)gcc
AS=$(ARCH)gcc
AR=$(ARCH)ar
RANLIB=$(ARCH)ranlib
STRIP=$(ARCH)strip
OBJCOPY=$(ARCH)objcopy
OBJDUMP=$(ARCH)objdump
COPY=cp
MKDIR=mkdir
ELFTOOL='C:\Program Files (x86)\Cypress\PSoC Creator\3.1\PSoC Creator\bin\cyelftool.exe'
INCS = -I . $(addprefix -I, $(MBED_INCLUDES) $(MONO_INCLUDES) $(CYLIB_INCLUDES))
CDEFS=
ASDEFS=
AS_FLAGS = -c -g -Wall -mcpu=cortex-m3 -mthumb -mthumb-interwork -march=armv7-m
CC_FLAGS = -c -g -Wall -mcpu=cortex-m3 -mthumb $(OPTIMIZATION) -mthumb-interwork -fno-common -fmessage-length=0 -ffunction-sections -fdata-sections -march=armv7-m
ONLY_C_FLAGS = -std=gnu99 
ONLY_CPP_FLAGS = -std=gnu++98 -fno-rtti -fno-exceptions
LDSCRIPT = -T $(LINKER_SCRIPT)
LD_FLAGS = -g -mcpu=cortex-m3 -mthumb -march=armv7-m -fno-rtti -Wl,--gc-sections -specs=nano.specs 
LD_SYS_LIBS = -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

#"libs/CyCompLib.a"
#   -mfix-cortex-m3-ldrd -u _printf_float -u _scanf_float
COPY_FLAGS = -j .text -j .eh_frame -j .rodata -j .ramvectors -j .noinit -j .data -j .bss -j .stack -j .heap -j .cyloadablemeta

all: $(BUILD_DIR) $(TARGET).elf


$(BUILD_DIR):
	@echo "creating build directory"
	@mkdir -p ./$(BUILD_DIR)

$(BUILD_DIR)/mono_default_main.o: $(MONO_PATH)/mono_default_main.cpp
	@echo "Compiling C++: Default main function"
	@$(MKDIR) -p $(dir $@)
	@$(CXX) $(CC_FLAGS) $(ONLY_CPP_FLAGS) $(CDEFS) $(INCS) -o $@ $<

$(BUILD_DIR)/%.o: %.c $(TARGET_HEADERS)
	@echo "Compiling C: $<"
	@$(MKDIR) -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(ONLY_C_FLAGS) $(CDEFS) $(INCS) -o $@ $<

$(BUILD_DIR)/%.o: %.cpp $(TARGET_HEADERS)
	@echo "Compiling C++: $<"
	@$(MKDIR) -p $(dir $@)
	@$(CXX) $(CC_FLAGS) $(ONLY_CPP_FLAGS) $(CDEFS) $(INCS) -o $@ $<

$(TARGET).elf: $(MONO_FRAMEWORK_PATH)/monoCyLib.a $(MONO_FRAMEWORK_PATH)/CyComponentLibrary.a $(MONO_FRAMEWORK_PATH)/mbedlib.a $(MONO_FRAMEWORK_PATH)/mono_framework.a $(TARGET_OBJECTS) $(BUILD_DIR)/mono_default_main.o
	@echo "Linking $(notdir $@)"
	@$(LD) -Wl,--start-group $(LD_FLAGS) -o $@ $^ -mthumb -march=armv7-m -mfix-cortex-m3-ldrd "-Wl,-Map,mono_project.map" -T $(LINKER_SCRIPT) -g  "-u\ _printf_float" $(LD_SYS_LIBS) -Wl,--gc-sections -Wl,--end-group

$(TARGET).hex: $(TARGET).elf
	$(ELFTOOL) -C $^ --flash_size $(FLASH_SIZE) --flash_row_size $(FLASH_ROW_SIZE)
	$(OBJCOPY) -O ihex $(COPY_FLAGS) $< $@
	$(ELFTOOL) -B $^ --flash_size $(FLASH_SIZE) --flash_array_size $(FLASH_ARRAY_SIZE) --flash_row_size $(FLASH_ROW_SIZE) --ee_array $(EE_ARRAY) --ee_row_size $(EE_ROW_SIZE)

$(TARGET):  $(OBJS)  ${LINKER_SCRIPT}
	@echo "Other link: $(OBJS)"
	@$(LD) $(LDSCRIPT) $(OBJS) -o $@


systemFiles:
	@echo $(SYS_OBJECTS)
	
appFiles:
	@echo $(OBJECTS)

mbedFiles:
	@echo $(MBED_INCLUDES)

monoFiles:
	@echo $(MONO_INCLUDES)

includeFiles: 
	@echo $(INCS)

install: $(TARGET).elf
	@monomake reboot
	@echo "Programming app to device..."
	$(MONOPROG) -p $(TARGET).elf --verbose 1

clean:
	$(RM) $(addprefix $(BUILD_DIR)/, $(notdir $(OBJECTS))) $(addprefix $(BUILD_DIR)/, $(notdir $(SYS_OBJECTS))) $(TARGET).elf $(TARGET).bin

summary: $(TARGET).elf
	$(ELFTOOL) -S $(TARGET).elf
	

## $(LD) -Wl,--start-group $(LD_FLAGS) libs/CyCompLib.a $(LDSCRIPT) -o $@ $^ -Wl,--end-group $(LD_SYS_LIBS)
## $(ELFTOOL) -C $@ --flash_size $(FLASH_SIZE) --flash_row_size $(FLASH_ROW_SIZE)