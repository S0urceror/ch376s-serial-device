#ifndef USB_DEVICE
    #define USB_DEVICE

//; / * The following status code 0XH is used for USB device mode * /
//; / * Only need to process in the built-in firmware mode: USB_INT_EP1_OUT, USB_INT_EP1_IN, USB_INT_EP2_OUT, USB_INT_EP2_IN * /
//; / * Bit 7-Bit 4 is 0000 * /
//; / * Bit 3-bit 2 indicates the current transaction, 00 = OUT, 10 = IN, 11 = SETUP * /
//; / * Bit 1 to Bit 0 indicate the current endpoint, 00 = Endpoint 0, 01 = Endpoint 1, 10 = Endpoint 2, 11 = USB Bus Reset * /
#define USB_INT_EP0_SETUP 		0x00C			 //; / * SETUP of USB endpoint 0 * /
#define USB_INT_EP0_OUT 		0x000			 //; / * OUT of USB endpoint 0 * /
#define USB_INT_EP0_IN 			0x008			 //; / * IN of USB endpoint 0 * /
#define USB_INT_EP1_OUT 		0x001			 //; / * OUT of USB endpoint 1 * /
#define USB_INT_EP1_IN 			0x009			 //; / * IN of USB endpoint 1 * /
#define USB_INT_EP2_OUT 		0x002			 //; / * OUT of USB endpoint 2 * /
#define USB_INT_EP2_IN 			0x00A			 //; / * IN of USB endpoint 2 * /
//; / * USB_INT_BUS_RESET EQU 00000XX11B * /; / * USB bus reset * /
#define USB_BUS_RESET_MASK      0b00000011
#define USB_INT_BUS_RESET 		0x003
#define USB_INT_BUS_RESET1 		0x003			 //; / * USB bus reset * /
#define USB_INT_BUS_RESET2 		0x007			 //; / * USB bus reset * /
#define USB_INT_BUS_RESET3 		0x00B			 //; / * USB bus reset * /
#define USB_INT_BUS_RESET4 		0x00F			 //; / * USB bus reset * /
#define USB_INT_USB_SUSPEND     0x05
#define USB_INT_WAKE_UP         0x06

// USB requests
////////////////////////////////////////////
// IN
#define USB_REQ_GET_STATUS              0x00
#define USB_REQ_GET_DESCRIPTOR          0x06
#define USB_REQ_GET_CONFIGURATION       0x08
#define USB_REQ_GET_INTERFACE           0x0a
#define USB_REQ_SYNC_FRAME              0x0c

//OUT
#define USB_REQ_CLEAR_FEATURE           0x01
#define USB_REQ_SET_FEATURE             0x03
#define USB_REQ_SET_ADDRESS             0x05
#define USB_REQ_SET_DESCR               0x07
#define USB_REQ_SET_CONFIGURATION       0x09
#define USB_REQ_SET_INTERFACE           0x0b

#define EP0_PIPE_SIZE               8
#define BULK_OUT_ENDP_MAX_SIZE      0x40

// USB descriptor codes
#define USB_DESC_DEVICE             1
#define USB_DESC_CONFIGURATION      2
#define USB_DESC_STRING             3
#define USB_DESC_INTERFACE          4
#define USB_DESC_ENDPOINT           5

// USB string descriptor ids
#define STRING_DESC_MANUFACTURER    1
#define STRING_DESC_PRODUCT         2
#define STRING_DESC_SERIAL          3

//0000-ready ACK, 1110-busy NAK, 1111-error STALL
#define SET_ENDP_ACK        0b0000
#define SET_ENDP_NAK        0b1110
#define SET_ENDP_STALL      0b1111

#define SET_ENDP_RX         0b0000
#define SET_ENDP_TX         0b0001

#define SET_ENDP2__RX_EP0   0x18
#define SET_ENDP3__TX_EP0   0x19
#define SET_ENDP4__RX_EP1   0x1A
#define SET_ENDP5__TX_EP1   0x1B
#define SET_ENDP6__RX_EP2   0x1C
#define SET_ENDP7__TX_EP2   0x1D

#define SET_LINE_CODING         0x20    //Configures baud rate, stop-bits, parity, and number- of-character bits.
#define GET_LINE_CODING         0x21    //Requests current DTE rate, stop-bits, parity, and number-of-character bits.
#define SET_CONTROL_LINE_STATE  0x22    //RS232 signal used to tell the DCE device the DTE device is now present.
#define SEND_BREAK              0x23    // Sends special carrier modulation used to specify RS-232 style break

#define USB_CONFIGURATION_ID    1

#define USB_DIR_MASK    0x80
#define USB_DIR_IN      0x80
#define USB_DIR_OUT     0x00
#define USB_TYPE_MASK			(0x03 << 5)
#define USB_TYPE_STANDARD		(0x00 << 5)
#define USB_TYPE_CLASS			(0x01 << 5)
#define USB_TYPE_VENDOR			(0x02 << 5)
#define USB_TYPE_RESERVED		(0x03 << 5)

#ifdef __cplusplus
extern "C" {
#endif

typedef enum __DEVICE_MODE
{
    MONITOR_MODE,
    TERMINAL_MODE
} DEVICE_MODE;
typedef enum __INTERRUPT_RESULT
{
    DEVICE_INTERRUPT_OKAY,
    DEVICE_INTERRUPT_ERROR,
    DEVICE_ADDRESS_SET,
    DEVICE_CONFIGURATION_SET,
    DEVICE_SERIAL_CONNECTED,
    DEVICE_SERIAL_DISCONNECTED,
    MONITOR_EXIT_BASIC
} INTERRUPT_RESULT;
bool device_init ();
INTERRUPT_RESULT device_interrupt (WORKAREA* wrk, DEVICE_MODE mode);
void device_reset (WORKAREA* wrk);
void device_monitor_reset ();
void device_send (WORKAREA* wrk,char* buffer,uint16_t length);
void device_send_welcome (WORKAREA* wrk);

#ifdef __cplusplus
}
#endif

#endif // USB_DEVICE 