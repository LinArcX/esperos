#include "types.hpp"

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void callConstructors()
{
  for(constructor* i = &start_ctors; i != &end_ctors; i++)
    (*i)();
}

void printf(const char* str)
{
  uint16_t* VideoMemory = (uint16_t*)0xb8000;
  for(int32_t i = 0; str[i]!='\0'; i++)
    VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
}

extern "C" void kernelMain(void* multiboot_structor, uint32_t magic_number)
{
  printf("Hello, this is esperos :)");
  while(1);
}
