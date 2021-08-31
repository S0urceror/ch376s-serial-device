#ifndef __HOOKS_MSX_H
#define __HOOKS_MSX_H

__at BIOS_H_CHPH HOOK HCHPU;
__at BIOS_H_CHGE HOOK HCHGE;
__at BIOS_H_TIMI HOOK HTIMI;
__at BIOS_H_CLEAR HOOK HCLEA;
__at BIOS_H_STKE HOOK HSTKE;
__at BIOS_H_LOPD HOOK HLOPD;

void hook (HOOK* hook_address, HOOK* copy_of_old, uint16_t* function_address);
void unhook (HOOK* hook_address, HOOK* copy_of_old);

#endif // __HOOKS_MSX_H
