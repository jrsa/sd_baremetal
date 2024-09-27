#include <stdio.h>
#include "xparameters.h"
#include "platform.h"
#include "xil_io.h" 
#include "xil_printf.h"

#include "xgpio.h"
#include "xuartps.h"

#define GPIO_EXAMPLE_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID
#define GPIO 0x01
#define GPIO_DELAY     100000
#define GPIO_CHANNEL 1

XGpio Gpio;

int main()
{
	int Status;
	volatile int Delay;

    init_platform();

    // what tf is `print`
    //print("Hello World!\n\r");

    // your mom is a pie smasher
    //print("JC1.5 on the piSmasher should have a square wave on it.\r\n");

    /* Initialize the GPIO driver */
	Status = XGpio_Initialize(&Gpio, GPIO_EXAMPLE_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}

	/* Set the direction for all signals as inputs except the LED output */
	XGpio_SetDataDirection(&Gpio, GPIO_CHANNEL, 0);

	/* Loop forever blinking the LED */

	while (1) {

		/* Set the LED to High */
		XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, 1);

		/* Wait a small amount of time so the LED is visible */
		for (Delay = 0; Delay < GPIO_DELAY; Delay++);

		/* Clear the LED bit */
		XGpio_DiscreteClear(&Gpio, GPIO_CHANNEL, 1);

		/* Wait a small amount of time so the LED is visible */
		for (Delay = 0; Delay < GPIO_DELAY; Delay++);

		//print(".");
	}

    cleanup_platform();
    return 0;
}

