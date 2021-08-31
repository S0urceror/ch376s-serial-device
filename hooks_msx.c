#include "build-msx/MSX/BIOS/msxbios.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "workarea.h"
#include "hooks_msx.h"
#include "workarea_msx.h"
#include "screen_msx.h"

void hook (HOOK* hook_address, HOOK* copy_of_old, uint16_t* function_address)
{
    HOOK hook;
    uint8_t slot_id;
    // get slot id of this rom
    slot_id = get_slot_id ((uint16_t) &byte_in_rom_space);
    memcpy (copy_of_old,hook_address,sizeof(HOOK));
    hook[0]=0xf7; // RST30h
    hook[1]=slot_id;
    hook[2]=((uint16_t) function_address) & 0xff;
    hook[3]=((uint16_t) function_address) >> 8;
    hook[4]=0xc9; // ret
    // copy over the existing one
    msx_disable_interrupt ();    
    memcpy (hook_address,hook,sizeof(HOOK));
    msx_enable_interrupt ();
}
void unhook (HOOK* hook_address, HOOK* copy_of_old)
{
    msx_disable_interrupt ();    
    memcpy (hook_address,copy_of_old,sizeof(HOOK));
    msx_enable_interrupt ();
}
