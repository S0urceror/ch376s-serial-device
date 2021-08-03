#ifndef CH376S_H__
    #define CH376S_H__

#define CH376_CMD_GET_IC_VER      0x01
#define CH_CMD_ENTER_SLEEP        0x03
#define CH375_CMD_RESET_ALL       0x05
#define CH375_CMD_CHECK_EXIST     0x06
#define CH375_CMD_SET_USB_ADDR    0x13
#define CH375_CMD_SET_USB_MODE    0x15
#define CH_CMD_SET_EP0_RX         0x18
#define CH_CMD_SET_EP0_TX         0x19
#define CH_CMD_SET_EP1_RX         0x1a
#define CH_CMD_SET_EP1_TX         0x1b
#define CH_CMD_SET_EP2_RX         0x1c
#define CH_CMD_SET_EP2_TX         0x1d
#define CH375_CMD_GET_STATUS      0x22
#define CH375_CMD_UNLOCK_USB      0x23
#define CH375_CMD_RD_USB_DATA     0x27
#define CH375_CMD_RD_USB_DATA_UNLOCK     0x28
#define CH_CMD_WR_EP0             0x29 // DATA3
#define CH_CMD_WR_EP1             0x2A // DATA5
#define CH_CMD_WR_EP2             0x2B // DATA7
#define CH375_CMD_WR_HOST_DATA    0x2C
#define CH376_CMD_CLR_STALL       0x41
#define CH375_CMD_ISSUE_TKN_X     0x4E
#define CH_CMD_SET_REGISTER       0x0b
#define CH_CMD_GET_REGISTER       0x0a
#define CH_CMD_DELAY_100US        0x0f
#define CH375_CMD_GET_DESCR       0x46
#define CH_CMD_TEST_CONNECT       0x16
#define CH_CMD_SET_FILE_NAME      0x2f
#define CH_CMD_DISK_CONNECT       0x30
#define CH_CMD_DISK_MOUNT         0x31
#define CH_CMD_FILE_OPEN          0x32
#define CH_CMD_FILE_CLOSE         0x36
#define CH_CMD_FILE_ENUM_GO       0x33
#define CH_CMD_BYTE_READ          0x3a
#define CH_CMD_BYTE_RD_GO         0x3b
#define CH_CMD_BYTE_WRITE         0x3c
#define CH_CMD_BYTE_WR_GO         0x3d
#define CH_CMD_DIR_CREATE         0x40
#define CH_CMD_FILE_CREATE        0x34
#define CH_CMD_WR_REQ_DATA        0x2d
#define CH_CMD_DIR_INFO_READ      0x37
#define CH_CMD_BYTE_LOCATE        0x39
#define CH_CMD_FILE_ERASE         0x35

// return codes
#define CH_ST_RET_SUCCESS         0x51
#define CH_ST_RET_ABORT           0x5F

// device modes
#define CH375_USB_MODE_DEVICE_INVALID 0x00
#define CH375_USB_MODE_DEVICE_OUTER_FW 0x01
#define CH375_USB_MODE_DEVICE_INNER_FW 0x02
#define CH375_USB_MODE_HOST 0x06
#define CH375_USB_MODE_HOST_RESET 0x07

#ifdef __cplusplus
extern "C" {
#endif

    void host_reset ();
    void host_basic_interpreter ();
    void host_writeByte (uint16_t address, uint8_t value);
    uint8_t readData ();
    uint8_t readStatus ();
#ifndef __SDCC
    void writeCommand (uint8_t cmd);
    void writeData (uint8_t data);
    void host_go (uint16_t address);
    uint8_t host_readByte (uint16_t address);
#else
    void writeCommand (uint8_t data) __z88dk_fastcall;
    void writeData (uint8_t data) __z88dk_fastcall;
    void host_go (uint16_t address) __z88dk_fastcall;
    uint8_t host_readByte (uint16_t address) __z88dk_fastcall;
#endif

#ifdef __cplusplus
}
#endif

#endif // CH376S_H__