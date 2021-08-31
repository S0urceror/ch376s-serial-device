#ifndef __DESCRIPTORS_H__
    #define __DESCRIPTORS_H__


/*******************
 * Descriptor data *
 *******************/
/* Various descriptors of the device */
/* Include device descriptors, configuration descriptors, interface descriptors, endpoint descriptors, string descriptors, and CDC type function descriptors */



/* Device descriptor */
const uint8_t DevDes[] = {
    0X12, // bLength 1 the number of bytes of the device descriptor
    0X01, // bDecriptorType. 1 for the device type description 0x01

    0X10, // bcdUSB 2 This device is compatible with the description table of the USB device description version number BCD code, currently 1.1
    0X01,

    0X02, // bDeviceClass 1 device class code CDC Class
    0X00, // bDeviceSubClass 1 subclass code
    0X00, // bDevicePortocol 1 protocol code

    EP0_PIPE_SIZE, // bMaxPacketSize0 1 The maximum packet size of endpoint 0, only 8, 16, 32, 64 are legal values; the current maximum is 8
    // idVendor 2 manufacturer logo (valued by USB standard)
    //0xC0, // VendorID-L
    //0x16, // VendorId-H
    0x09,// VendorID-L
    0x12,// VendorId-H
    // idProduct 2 product logo (paid by the manufacturer)
    0x34,// ProductId-L
    0x34,// ProductId-H
    //0x83, // ProductId-L
    //0x04, // ProductId-H

    0X00, // bcdDevice 2 device release number BCD code
    0X01,

    0X01, // iManufacturer 1 Index: Index description string of vendor information
    0X02, // iProduct 1 Index: The index of the string describing the product information
    0X03, // iSerialNumber 1 Index: the index of the string describing the device serial number information

    0X01 // bNumConfigurations 1 the number of possible settings
};

/* Configuration descriptor */
const uint8_t ConDes[9 + 9 + 5 + 4 + 5 + 5 + 7 + 9 + 7 + 7] = {
    /* Configuration descriptor */
    0X09,                  // bLength 1 The number of bytes in the configuration descriptor
    0X02,                  // bDescriptorType 1 configuration description table type 0X02
    sizeof(ConDes) & 0xFF, // wTotalLength 2 The total length of this configuration information, including the configuration interface endpoint and device class and the description table defined by the manufacturer
    (sizeof(ConDes) >> 8) & 0xFF,
    // 0x43,
    // 0x00,

    0X02, // bNumInterfaces 1 The number of interfaces supported by this configuration
    USB_CONFIGURATION_ID, // bCongfigurationValue SetConfiguration. 1 as a parameter in () request to the selected configuration
    0X00, // iConfiguration 1 Index: the index of the string description table describing this configuration
    0Xc0, // bmAttributes 1 configuration characteristics
    0X19, // MaxPower 1 Bus power consumption in this configuration takes 2mA as a unit, 50mA

    /* Control interface descriptor */
    0X09, // bLength 1 The number of bytes of interface 0 descriptor
    0X04, // bDescriptorType 1 interface description table class 0x04
    0X00, // bInterfaceNumber 1 The index of the interface array supported by the current configuration of the interface number (starting from zero)
    0X00, // bAlternateSetting 1 optional setting index value
    0X01, // number of endpoints bNumEndpoints 1 using this interface, if it indicates that the interface is zero only default control pipe
    0X02, // bInterfaceClass 1 class value, CDC class
    0X02, // bInterfaceSubClass 1
    0X01, // bInterfaceProtocol 1 protocol code, which means CDC type
    0X00, // iInterface 1 The index value of the string description table describing this interface

    /* Class-Specific Functional Descriptors */
    0X05, // bFunctionLength
    0X24, // bDescriptorType CS_INTERFACE
    0X00, // bDescriptorSubtype Header
    0X10, // bcdCDC
    0X01,

    0X04, // bFunctionLength
    0X24, // bDescriptorType CS_INTERFACE
    0X02, // bDescriptorSubtype Abstract Control Management
    0X02, // bmCapabilities
    // D7..D4: RESERVED (Reset to zero)
    // D3: 1-Device supports the notification Network_Connection.
    // D2: 1-Device supports the request Send_Break
    // D1: 1-Device supports the request combination of
    // Set_Line_Coding,Set_Control_Line_State,Get_Line_Coding, and the notification Serial_State.
    // D0: 1-Device supports the request combination of
    // Set_Comm_Feature,
    // Clear_Comm_Feature, and
    // Get_Comm_Feature.

    0X05, // bFunctionLength
    0x24, // bDescriptorType CS_INTERFACE
    0X06, // bDescriptorSubtype of Union Functional descriptor
    0X00, // bMasterInterface
    0X01, // bSlaveInterface0

    0X05, // bFunctionLength
    0X24, // bDescriptorType CS_INTERFACE
    0X01, // bDescriptorSubtype Call Management Functional Descriptor
    0X03, // bmCapabilities
    // D7..D2: RESERVED (Reset to zero)
    // D1: 0-Device sends/receives call management information only over the Communication Class interface.
    // 1-Device can send/receive call management information over a Data Class interface.
    // D0: 0-Device does not handle call management itself.
    // 1-Device handles call management itself.
    0X01, // bDataInterface Interface Number The interface of the Data Class OPTIONALLY Used for Call Management.

    /* The endpoint descriptor corresponding to the control interface */
    0X07, // bLength 1 The number of bytes in the endpoint description table
    0X05, // bDescriptorType 1 endpoint description table class 0x05
    0X81, // bEndpointAddress 1 The address of the endpoint described in this description table
    0X03, // bmAttributes 1 This endpoint is interrupt transmission
    0X08, // wMaxPacketSize 2 The size of the largest data packet that this endpoint can receive or send under the current configuration
    0X00,
    0X14, // bInterval 1 The time interval for polling data transmission endpoints is 20ms

    /* Data interface descriptor */
    0X09, // bLength 1 The number of bytes of interface 0 descriptor
    0X04, // bDescriptorType 1 interface description table class 0x04
    0X01, // bInterfaceNumber 1 The index of the interface array supported by the current configuration of the interface number (starting from zero)
    0X00, // bAlternateSetting 1 optional setting index value
    0X02, // bNumEndpoints 1 The number of endpoints used by this interface, if it is zero, it means that this interface only uses the default control pipe
    0X0A, // bInterfaceClass 1 class value, CDC class
    0X00, // bInterfaceSubClass 1 subclass code
    0X00, // bInterfaceProtocol 1 protocol code, which means CDC type
    0X00,

    /* The endpoint descriptor corresponding to the data interface-batch input endpoint 2 descriptor */
    0X07,                   // bLength 1 The number of bytes in the endpoint description table
    0X05,                   // bDescriptorType 1 endpoint description table class 0x05
    0X02,                   // bEndpointAddress 1 The address of the endpoint described in this description table
    0X02,                   // bmAttributes 1 This endpoint is interrupt transmission
    BULK_OUT_ENDP_MAX_SIZE, // wMaxPacketSize 2 The size of the largest data packet that this endpoint can receive or send under the current configuration
    0X00,
    0X00, // bInterval 1 The time interval of round-robin data transmission endpoint, invalid for bulk endpoint
    /* The endpoint descriptor corresponding to the data interface-batch input endpoint 2 descriptor */
    0X07,                   // bLength 1 The number of bytes in the endpoint description table
    0X05,                   // bDescriptorType 1 endpoint description table class 0x05
    0X82,                   // bEndpointAddress 1 The address of the endpoint described in this description table
    0X02,                   // bmAttributes 1 This endpoint is interrupt transmission
    BULK_OUT_ENDP_MAX_SIZE, // wMaxPacketSize 2 The size of the largest data packet that this endpoint can receive or send under the current configuration
    0X00,
    0X00, // bInterval 1 The time interval of round-robin data transmission endpoint, invalid for bulk endpoint
};

/* Language descriptor */
const uint8_t LangDes[] = {
    0X04, // bLength
    0X03, // bDescriptorType
    0X09,
    0X04};

/* Vendor string descriptor */
const uint8_t MANUFACTURER_Des[] = {
    0X14,  // bLength
    0X03,  // bDescriptorType
    'S', // "S0urceror"
    0X00,
    '0',
    0X00,
    'u',
    0X00,
    'r',
    0X00,
    'c',
    0X00,
    'e',
    0X00,
    'r',
    0X00,
    'o',
    0X00,
    'r',
    0X00,
};

/* Product string descriptor */
const uint8_t PRODUCER_Des[] = {
    0X1c,  // bLength
    0X03,  // bDescriptorType
    'M', // "Network Controller"
    0X00,
    'S',
    0X00,
    'X',
    0X00,
    'U',
    0X00,
    'S',
    0X00,
    'B',
    0X00,
    '-',
    0X00,
    'S',
    0X00,
    'e',
    0X00,
    'r',
    0X00,
    'i',
    0X00,
    'a',
    0X00,
    'l',
    0X00,
};

/* Product serial number string descriptor */
const uint8_t PRODUCER_SN_Des[] = {
    0X12,        // bLength
    0X03,        // bDescriptorType
    '2', 0x00, // "20210701"
    '0', 0x00,
    '2', 0x00,
    '1', 0x00,
    '0', 0x00,
    '7', 0x00,
    '0', 0x00,
    '1', 0x00
};


#endif // __DESCRIPTORS_H__