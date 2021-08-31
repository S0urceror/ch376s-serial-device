#ifndef __HOST_H_
#define __HOST_H_

#ifdef __cplusplus
extern "C" {
#endif

    void host_reset ();
    void host_writeByte (uint16_t address, uint8_t value);
    uint8_t readData ();
    uint8_t readStatus ();
    void host_load (uint16_t address, char* filename);
    void host_save (uint16_t address, uint16_t size, char* filename);
    void host_delay (int milliseconds);
    uint32_t host_millis_elapsed ();
#ifndef __SDCC
    void writeCommand (uint8_t cmd);
    void writeData (uint8_t data);
    void host_go (uint16_t address);
    uint8_t host_readByte (uint16_t address);
    void host_putchar (uint8_t character);
#else
    void writeCommand (uint8_t data) __z88dk_fastcall __naked;
    void writeData (uint8_t data) __z88dk_fastcall __naked;
    void host_go (uint16_t address) __z88dk_fastcall __naked;
    uint8_t host_readByte (uint16_t address) __z88dk_fastcall __naked;
    void host_putchar (uint8_t character) __z88dk_fastcall __naked;
#endif

#ifdef __cplusplus
}
#endif

#endif // __HOST_H_