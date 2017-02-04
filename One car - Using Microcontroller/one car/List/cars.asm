
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _s=R4
	.DEF _y=R6
	.DEF _i=R8
	.DEF _j=R10
	.DEF _z=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x96
_0x0:
	.DB  0x47,0x61,0x6D,0x65,0x20,0x4F,0x76,0x65
	.DB  0x72,0x21,0x21,0x21,0x0,0x59,0x6F,0x75
	.DB  0x72,0x20,0x73,0x63,0x6F,0x72,0x65,0x20
	.DB  0x69,0x73,0x20,0x0,0x50,0x72,0x65,0x73
	.DB  0x73,0x20,0x74,0x6F,0x20,0x73,0x74,0x61
	.DB  0x72,0x74,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _speed
	.DW  _0x3*2

	.DW  0x0D
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0xB+13
	.DW  _0x0*2+13

	.DW  0x0F
	.DW  _0x28
	.DW  _0x0*2+28

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 01-11-2015
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;int s,a[16][2],y,i,j,z,counter,score,speed=150;

	.DSEG
;char c[10];
;void main(void);
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0022 {

	.CSEG
_ext_int1_isr:
; 0000 0023 // Place your code here
; 0000 0024 
; 0000 0025 }
	RETI
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0029 {
_ext_int2_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002A // Place your code here
; 0000 002B     s++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 002C   delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x0
; 0000 002D   if(s==2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x4
; 0000 002E     s=0;
	CLR  R4
	CLR  R5
; 0000 002F }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Declare your global variables here
;void init()
; 0000 0033 {
_init:
; 0000 0034     for(i=1;i<16;i++)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
_0x6:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x7
; 0000 0035     for(j=0;j<=1;j++)
	CLR  R10
	CLR  R11
_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRLT _0xA
; 0000 0036         a[i][j]=0;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x9
_0xA:
; 0000 0037 s=y=i=j=z=counter=score=0;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x6
_0x7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _score,R30
	STS  _score+1,R31
	STS  _counter,R30
	STS  _counter+1,R31
	MOVW R12,R30
	MOVW R10,R30
	MOVW R8,R30
	MOVW R6,R30
	MOVW R4,R30
; 0000 0038     speed=150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	STS  _speed,R30
	STS  _speed+1,R31
; 0000 0039 }
	RET
;void player(void)
; 0000 003B {
_player:
; 0000 003C       lcd_gotoxy(0,s);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R4
	CALL _lcd_gotoxy
; 0000 003D       lcd_putchar('X');
	LDI  R30,LOW(88)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 003E       lcd_gotoxy(0,1-s);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	SUB  R30,R4
	SBC  R31,R5
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 003F       lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0040 }
	RET
;void finish()
; 0000 0042 {
_finish:
; 0000 0043     lcd_clear();
	CALL _lcd_clear
; 0000 0044     lcd_puts("Game Over!!!");
	__POINTW1MN _0xB,0
	CALL SUBOPT_0x4
; 0000 0045     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0046     itoa(score,c);
	LDS  R30,_score
	LDS  R31,_score+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	ST   -Y,R31
	ST   -Y,R30
	CALL _itoa
; 0000 0047     lcd_puts("Your score is ");
	__POINTW1MN _0xB,13
	CALL SUBOPT_0x4
; 0000 0048     lcd_puts(c);
	LDI  R30,LOW(_c)
	LDI  R31,HIGH(_c)
	CALL SUBOPT_0x4
; 0000 0049     while(1)
_0xC:
; 0000 004A     {
; 0000 004B         if(PINB.0==1)
	SBIS 0x16,0
	RJMP _0xF
; 0000 004C             {
; 0000 004D                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x0
; 0000 004E                 init();
	RCALL _init
; 0000 004F                 main();
	RCALL _main
; 0000 0050             }
; 0000 0051     }
_0xF:
	RJMP _0xC
; 0000 0052 }

	.DSEG
_0xB:
	.BYTE 0x1C
;// Declare your global variables here
;void obstacle(void)
; 0000 0055 {

	.CSEG
_obstacle:
; 0000 0056    if(a[1][s]==1)
	__POINTW2MN _a,4
	MOVW R30,R4
	CALL SUBOPT_0x5
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x10
; 0000 0057    {
; 0000 0058         finish();
	RCALL _finish
; 0000 0059    }
; 0000 005A    if(a[1][1-s]==2)
_0x10:
	__POINTW2MN _a,4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	SUB  R30,R4
	SBC  R31,R5
	CALL SUBOPT_0x5
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11
; 0000 005B    {
; 0000 005C         finish();
	RCALL _finish
; 0000 005D    }
; 0000 005E    if((a[1][0]==2) || (a[1][1]==2)){
_0x11:
	__GETW1MN _a,4
	SBIW R30,2
	BREQ _0x13
	__GETW1MN _a,6
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12
_0x13:
; 0000 005F     score++;
	LDI  R26,LOW(_score)
	LDI  R27,HIGH(_score)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0060     if(score>1)
	LDS  R26,_score
	LDS  R27,_score+1
	SBIW R26,2
	BRLT _0x15
; 0000 0061           if(score%2==0)
	LDS  R26,_score
	LDS  R27,_score+1
	CALL SUBOPT_0x6
	SBIW R30,0
	BRNE _0x16
; 0000 0062                 speed--;
	LDI  R26,LOW(_speed)
	LDI  R27,HIGH(_speed)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0063    }
_0x16:
_0x15:
; 0000 0064     z++;
_0x12:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0065     z=(z+rand()%2)%2;
	CALL _rand
	MOVW R26,R30
	CALL SUBOPT_0x6
	ADD  R30,R12
	ADC  R31,R13
	MOVW R26,R30
	CALL SUBOPT_0x6
	MOVW R12,R30
; 0000 0066     y=(rand()+z)%4;
	CALL _rand
	ADD  R30,R12
	ADC  R31,R13
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	MOVW R6,R30
; 0000 0067     if(y==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x17
; 0000 0068     {
; 0000 0069         a[15][z]=1;
	CALL SUBOPT_0x7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x8
; 0000 006A         a[15][1-z]=0;
; 0000 006B     }
; 0000 006C     if(y==0)
_0x17:
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x18
; 0000 006D     {
; 0000 006E         a[15][z]=0;
	CALL SUBOPT_0x7
	CALL SUBOPT_0x3
; 0000 006F         a[15][1-z]=1;
	CALL SUBOPT_0x9
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 0070     }
; 0000 0071     if(y==3)
_0x18:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x19
; 0000 0072     {
; 0000 0073         a[15][z]=0;
	CALL SUBOPT_0x7
	CALL SUBOPT_0x3
; 0000 0074         a[15][1-z]=2;
	CALL SUBOPT_0x9
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0075     }
; 0000 0076     if(y==2)
_0x19:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1A
; 0000 0077     {
; 0000 0078         a[15][z]=2;
	CALL SUBOPT_0x7
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x8
; 0000 0079         a[15][1-z]=0;
; 0000 007A     }
; 0000 007B 
; 0000 007C     for(i=1;i<15;i++)
_0x1A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
_0x1C:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x1D
; 0000 007D     {
; 0000 007E          a[i][0]=a[i+1][0];
	CALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xA
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 007F          a[i][1]=a[i+1][1];
	CALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,2
	CALL SUBOPT_0xA
	ADIW R26,2
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0080     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x1C
_0x1D:
; 0000 0081 }
	RET
;void print(void)
; 0000 0083 {
_print:
; 0000 0084     for(i=15;i>=1;i--){
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R8,R30
_0x1F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x20
; 0000 0085         for(j=0;j<2;j++){
	CLR  R10
	CLR  R11
_0x22:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x23
; 0000 0086             lcd_gotoxy(i,j);
	ST   -Y,R8
	ST   -Y,R10
	CALL _lcd_gotoxy
; 0000 0087             if(a[i][j]==1){
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL __GETW1P
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x24
; 0000 0088                 lcd_putchar('0');
	LDI  R30,LOW(48)
	RJMP _0x32
; 0000 0089             }
; 0000 008A             else if(a[i][j]==2)
_0x24:
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL __GETW1P
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26
; 0000 008B                 lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x32
; 0000 008C 
; 0000 008D             else
_0x26:
; 0000 008E                 lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x32:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 008F         }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x22
_0x23:
; 0000 0090     }
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	RJMP _0x1F
_0x20:
; 0000 0091 }
	RET
;
;void main(void)
; 0000 0094 {
_main:
; 0000 0095 // Declare your local variables here
; 0000 0096 
; 0000 0097 // Input/Output Ports initialization
; 0000 0098 // Port A initialization
; 0000 0099 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009B PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 009C DDRA=0x00;
	OUT  0x1A,R30
; 0000 009D 
; 0000 009E // Port B initialization
; 0000 009F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A1 PORTB=0x00;
	OUT  0x18,R30
; 0000 00A2 DDRB=0x00;
	OUT  0x17,R30
; 0000 00A3 
; 0000 00A4 // Port C initialization
; 0000 00A5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A7 PORTC=0x00;
	OUT  0x15,R30
; 0000 00A8 DDRC=0x00;
	OUT  0x14,R30
; 0000 00A9 
; 0000 00AA // Port D initialization
; 0000 00AB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AD PORTD=0x00;
	OUT  0x12,R30
; 0000 00AE DDRD=0x00;
	OUT  0x11,R30
; 0000 00AF 
; 0000 00B0 // Timer/Counter 0 initialization
; 0000 00B1 // Clock source: System Clock
; 0000 00B2 // Clock value: Timer 0 Stopped
; 0000 00B3 // Mode: Normal top=0xFF
; 0000 00B4 // OC0 output: Disconnected
; 0000 00B5 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00B6 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00B7 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00B8 
; 0000 00B9 // Timer/Counter 1 initialization
; 0000 00BA // Clock source: System Clock
; 0000 00BB // Clock value: Timer1 Stopped
; 0000 00BC // Mode: Normal top=0xFFFF
; 0000 00BD // OC1A output: Discon.
; 0000 00BE // OC1B output: Discon.
; 0000 00BF // Noise Canceler: Off
; 0000 00C0 // Input Capture on Falling Edge
; 0000 00C1 // Timer1 Overflow Interrupt: Off
; 0000 00C2 // Input Capture Interrupt: Off
; 0000 00C3 // Compare A Match Interrupt: Off
; 0000 00C4 // Compare B Match Interrupt: Off
; 0000 00C5 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00C6 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00C7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00C8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00C9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00CA ICR1L=0x00;
	OUT  0x26,R30
; 0000 00CB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00CC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00CD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00CE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00CF 
; 0000 00D0 // Timer/Counter 2 initialization
; 0000 00D1 // Clock source: System Clock
; 0000 00D2 // Clock value: Timer2 Stopped
; 0000 00D3 // Mode: Normal top=0xFF
; 0000 00D4 // OC2 output: Disconnected
; 0000 00D5 ASSR=0x00;
	OUT  0x22,R30
; 0000 00D6 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00D7 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00D8 OCR2=0x00;
	OUT  0x23,R30
; 0000 00D9 
; 0000 00DA // External Interrupt(s) initialization
; 0000 00DB // INT0: Off
; 0000 00DC // INT1: On
; 0000 00DD // INT1 Mode: Falling Edge
; 0000 00DE // INT2: On
; 0000 00DF // INT2 Mode: Rising Edge
; 0000 00E0 GICR|=0xA0;
	IN   R30,0x3B
	ORI  R30,LOW(0xA0)
	OUT  0x3B,R30
; 0000 00E1 MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 00E2 MCUCSR=0x40;
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 00E3 GIFR=0xA0;
	LDI  R30,LOW(160)
	OUT  0x3A,R30
; 0000 00E4 
; 0000 00E5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E6 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00E7 
; 0000 00E8 // USART initialization
; 0000 00E9 // USART disabled
; 0000 00EA UCSRB=0x00;
	OUT  0xA,R30
; 0000 00EB 
; 0000 00EC // Analog Comparator initialization
; 0000 00ED // Analog Comparator: Off
; 0000 00EE // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00EF ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F0 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F1 
; 0000 00F2 // ADC initialization
; 0000 00F3 // ADC disabled
; 0000 00F4 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00F5 
; 0000 00F6 // SPI initialization
; 0000 00F7 // SPI disabled
; 0000 00F8 SPCR=0x00;
	OUT  0xD,R30
; 0000 00F9 
; 0000 00FA // TWI initialization
; 0000 00FB // TWI disabled
; 0000 00FC TWCR=0x00;
	OUT  0x36,R30
; 0000 00FD 
; 0000 00FE // Alphanumeric LCD initialization
; 0000 00FF // Connections specified in the
; 0000 0100 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0101 // RS - PORTA Bit 0
; 0000 0102 // RD - PORTA Bit 1
; 0000 0103 // EN - PORTA Bit 2
; 0000 0104 // D4 - PORTA Bit 4
; 0000 0105 // D5 - PORTA Bit 5
; 0000 0106 // D6 - PORTA Bit 6
; 0000 0107 // D7 - PORTA Bit 7
; 0000 0108 // Characters/line: 8
; 0000 0109 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 010A 
; 0000 010B // Global enable interrupts
; 0000 010C #asm("sei")
	sei
; 0000 010D  lcd_puts("Press to start");
	__POINTW1MN _0x28,0
	CALL SUBOPT_0x4
; 0000 010E while (1)
_0x29:
; 0000 010F       {
; 0000 0110       // Place your code here
; 0000 0111             if(PINB.0==1)
	SBIS 0x16,0
	RJMP _0x2C
; 0000 0112     {
; 0000 0113         delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x0
; 0000 0114         while (1)
_0x2D:
; 0000 0115         {
; 0000 0116             counter++;
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 0117             print();
	RCALL _print
; 0000 0118             player();
	RCALL _player
; 0000 0119             if(counter%speed==0)
	LDS  R30,_speed
	LDS  R31,_speed+1
	LDS  R26,_counter
	LDS  R27,_counter+1
	CALL __MODW21
	SBIW R30,0
	BRNE _0x30
; 0000 011A                   {
; 0000 011B                      obstacle();
	RCALL _obstacle
; 0000 011C                      counter=0;
	LDI  R30,LOW(0)
	STS  _counter,R30
	STS  _counter+1,R30
; 0000 011D                   }
; 0000 011E         }
_0x30:
	RJMP _0x2D
; 0000 011F     }
; 0000 0120 }
_0x2C:
	RJMP _0x29
; 0000 0121       }
_0x31:
	RJMP _0x31

	.DSEG
_0x28:
	.BYTE 0xF
;

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG
_rand:
	LDS  R30,__seed_G100
	LDS  R31,__seed_G100+1
	LDS  R22,__seed_G100+2
	LDS  R23,__seed_G100+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G100,R30
	STS  __seed_G100+1,R31
	STS  __seed_G100+2,R22
	STS  __seed_G100+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x1B,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x1B,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x1B,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x1B,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x1B,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x1B,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x1B,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x1B,7
_0x202000B:
	__DELAY_USB 5
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20A0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0xB
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0xB
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20A0001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20A0001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,7
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x0
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_a:
	.BYTE 0x40
_counter:
	.BYTE 0x2
_score:
	.BYTE 0x2
_speed:
	.BYTE 0x2
_c:
	.BYTE 0xA
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	MOVW R30,R8
	LDI  R26,LOW(_a)
	LDI  R27,HIGH(_a)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R10
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	__POINTW2MN _a,60
	MOVW R30,R12
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _a,60
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	SUB  R30,R12
	SBC  R31,R13
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	__POINTW2MN _a,60
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	SUB  R30,R12
	SBC  R31,R13
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOVW R0,R30
	MOVW R26,R8
	CALL __MULW2_4
	__ADDW2MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW2_4:
	LSL  R26
	ROL  R27
	LSL  R26
	ROL  R27
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
