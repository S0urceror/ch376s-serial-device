;-------------------------------------------------
; applicationsettings.s created automatically
; by make.sh
; on Wed 28 Jul 2021 16:52:44 CEST
;
; DO NOT BOTHER EDITING THIS.
; ALL CHANGES WILL BE LOST.
;-------------------------------------------------

GLOBALS_INITIALIZER = 1
RETURN_TO_BASIC = 1
STACK_HIMEM = 0
SET_PAGE_2 = 0
fileStart .equ 0x4000
CALL_EXPANSION = 1
DEVICE_EXPANSION = 1
BASIC_PROGRAM = 0

.macro MCR_CALLEXPANSIONINDEX
callStatementIndex::
.dw callStatement_MONITOR
.dw       #0
.globl _onCallMONITOR
callStatement_MONITOR::
.ascii    'MONITOR\0'
.dw _onCallMONITOR
.endm

.macro MCR_DEVICEEXPANSIONINDEX
deviceIndex::
.dw device_MON
.dw       #0
.globl _onDeviceMON_IO
.globl _onDeviceMON_getId
device_MON::
.ascii     'MON\0'
.dw _onDeviceMON_IO
.dw _onDeviceMON_getId
.endm
