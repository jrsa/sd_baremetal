#include "xil_printf.h"

#include "xgpio.h"
int main(int argc, char ** argv)
{
  while (1)
    asm("wfe"); // wait for event
    ;
  return 0;
}
