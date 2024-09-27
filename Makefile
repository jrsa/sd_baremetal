
XIL_INC = -I embeddedsw/lib/bsp/standalone/src/common/ \
      -I embeddedsw/lib/bsp/standalone/src/arm/cortexa9/ \
	  -I embeddedsw/lib/bsp/standalone/src/common/ \
	  -I embeddedsw/lib/bsp/standalone/src/arm/common/gcc/ \
	  -I embeddedsw/XilinxProcessorIPLib/drivers/gpio/src/ \
	  -I embeddedsw/XilinxProcessorIPLib/drivers/uartps/src/ 
	

TARGET = main.elf
SOURCES = main.c \
	embeddedsw/lib/bsp/standalone/src/common/xil_printf.c \
	embeddedsw/XilinxProcessorIPLib/drivers/uartps/src/xuartps_hw.c \
	embeddedsw/XilinxProcessorIPLib/drivers/gpio/src/xgpio.c \
	embeddedsw/XilinxProcessorIPLib/drivers/gpio/src/xgpio_sinit.c \
	embeddedsw/XilinxProcessorIPLib/drivers/gpio/src/xgpio_extra.c \
	embeddedsw/XilinxProcessorIPLib/drivers/gpio/src/xgpio_g.c \
	embeddedsw/lib/bsp/standalone/src/common/xil_assert.c \
	platform.c
	

CROSS_COMPILE ?= arm-none-eabi-

AS      = $(CROSS_COMPILE)as
CC      = $(CROSS_COMPILE)gcc
LD      = $(CROSS_COMPILE)ld
SZ      = $(CROSS_COMPILE)size
GDB     = $(CROSS_COMPILE)gdb
OOCD    = openocd

CFLAGS  = $(XIL_INC) -I. -mcpu=cortex-a9 -O0 -g3 #-Wall -Werror -Wpedantic
LDFLAGS = -TZynq.ld -lc -lnosys -lg -lm
ASFLAGS = -g -mcpu=cortex-a9

BSP     = boot.S \
          ps7_init.c

OBJECTS = $(patsubst %.S,%.o,$(patsubst %.c,%.o,$(SOURCES) $(BSP)))

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)
	@$(SZ) $(TARGET)

%.o: %.S
	$(AS) $(ASFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# LARGE CAVEAT: this does not clean any of the xilinx stuff i think
clean:
	rm -f $(TARGET) $(OBJECTS)

openocd:
	$(OOCD) -f openocd.cfg -f target/zynq_7000.cfg

debug: $(TARGET)
	$(GDB)  -iex "target remote localhost:3333" \
	        -iex "monitor halt" \
		-ex "load" \
		"$(TARGET)"

run: $(TARGET)
	$(GDB)  -iex "target remote localhost:3333" \
	        -iex "monitor halt" \
		-ex "load" \
		-ex "continue" \
		-ex "set confirm no" \
		-ex "quit" "$(TARGET)"

.PHONY: clean debug openocd
