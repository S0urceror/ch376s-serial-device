#ifndef __WORKAREA_H_
#define __WORKAREA_H_

typedef uint8_t HOOK[5];

typedef enum state_transaction 
{
    SETUP,
    DATA,
    STATUS
} TRANSACTION_STATE;

typedef enum __PROCESSING_COMMAND
{
    CMD_NULL = 0,
    CMD_GO  = 1,
    CMD_RESET = 2,
    CMD_BASIC = 3,
    CMD_IHX = 4,
    CMD_HELP = 5,
    CMD_MEMORY = 6,
    CMD_SAVE = 7,
    CMD_LOAD = 8
} PROCESSING_COMMAND;

typedef struct __WORKAREA
{
    char char_buffer[40];
    char* pos_in_char_buffer;
    HOOK HCHPU_original;
    HOOK HCHGE_original;
    HOOK HTIMI_original;
    HOOK HCLEA_original;
    HOOK HLOPD_original;
    uint8_t *dataToTransferEP0,*dataToTransferEP2;
    uint16_t dataTransferLengthEP0,dataTransferLengthEP2;
    uint8_t usb_device_address;
    uint8_t usb_configuration_id;
    uint16_t memory_address;    
    TRANSACTION_STATE transaction_state;
    PROCESSING_COMMAND processing_command;
} WORKAREA;

#endif // __WORKAREA_H_