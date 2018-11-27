
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega48
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega48
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x02FF
	.EQU __DSTACK_SIZE=0x0080
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _Uc_Buff_count=R4
	.DEF _Uc_Loop_count=R3
	.DEF _Uc_Loop2_count=R6
	.DEF _Uint_Timer_Count=R7
	.DEF _Uint_Timer_Count_msb=R8

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x40003:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _Uc_led_count
	.DW  _0x40003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : 1 Phase fix power supply
;Version : 1.0
;Date    : 11/19/2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega48
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*******************************************************/
;
;#include <mega48.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;#include <scan_led.h>
;#include <ADE7753.h>
;#include <delay.h>
;
;// Declare your global variables here
;
;
;#define TIMER2_OFF  TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2)
;#define TIMER2_ON   TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2)
;
;#define BUZZER  PORTD.5
;#define BUZZER_OFF  BUZZER = 0
;#define BUZZER_ON   BUZZER = 1
;
;#define CURRENT_SET_MIN 7
;#define CURRENT_SET_MAX 20
;
;#define NUM_FILTER  4
;#define NUM_SAMPLE  20
;
;unsigned int    AI10_Voltage_buff[NUM_SAMPLE];
;unsigned int    AI10_Currrent_buff[NUM_SAMPLE];
;unsigned int    AI10_Temp_buff[NUM_SAMPLE];
;unsigned long   Ulong_tmp;
;unsigned char   Uc_Buff_count = 0;
;unsigned char   Uc_Loop_count;
;unsigned char   Uc_Loop2_count;
;unsigned   int  Uint_Timer_Count = 0;
;bit Bit_sample_full = 0;
;bit Bit_warning = 0;
;bit Bit_Zero_flag = 0;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0039 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 003A // Place your code here
; 0000 003B     Bit_Zero_flag = 1;
; 0000 003C }
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0040 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
_0x3F:
; 0000 0041 // Place your code here
; 0000 0042     Bit_Zero_flag = 1;
	SBI  0x1E,2
; 0000 0043 }
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0047 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
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
; 0000 0048     // Reinitialize Timer1 value
; 0000 0049     TCNT1H=0xA000 >> 8;
	LDI  R30,LOW(160)
	RCALL SUBOPT_0x0
; 0000 004A     TCNT1L=0xA000 & 0xff;
; 0000 004B     // Place your code here
; 0000 004C     SCAN_LED();
	RCALL _SCAN_LED
; 0000 004D     if(Uint_Timer_Count < 200)  Uint_Timer_Count++;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R7,R30
	CPC  R8,R31
	BRSH _0x7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
; 0000 004E }
_0x7:
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
; .FEND
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0053 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
; 0000 0054 // Reinitialize Timer2 value
; 0000 0055     TCNT2=0xD0;
	LDI  R30,LOW(208)
	STS  178,R30
; 0000 0056     if(BUZZER == 0)   BUZZER_ON;
	SBIC 0xB,5
	RJMP _0x8
	SBI  0xB,5
; 0000 0057     else    BUZZER_OFF;
	RJMP _0xB
_0x8:
	CBI  0xB,5
; 0000 0058 // Place your code here
; 0000 0059 
; 0000 005A }
_0xB:
	LD   R30,Y+
	RETI
; .FEND
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0060 {
_read_adc:
; .FSTART _read_adc
; 0000 0061 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	STS  124,R30
; 0000 0062 // Delay needed for the stabilization of the ADC input voltage
; 0000 0063 delay_us(10);
	__DELAY_USB 27
; 0000 0064 // Start the AD conversion
; 0000 0065 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0066 // Wait for the AD conversion to complete
; 0000 0067 while ((ADCSRA & (1<<ADIF))==0);
_0xE:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0xE
; 0000 0068 ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 0069 return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 006A }
; .FEND
;
;void main(void)
; 0000 006D {
_main:
; .FSTART _main
; 0000 006E     // Declare your local variables here
; 0000 006F 
; 0000 0070     // Crystal Oscillator division factor: 1
; 0000 0071     #pragma optsize-
; 0000 0072     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0073     CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0074     #ifdef _OPTIMIZE_SIZE_
; 0000 0075     #pragma optsize+
; 0000 0076     #endif
; 0000 0077 
; 0000 0078     // Input/Output Ports initialization
; 0000 0079     // Port B initialization
; 0000 007A     // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 007B     DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(42)
	OUT  0x4,R30
; 0000 007C     // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 007D     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 007E 
; 0000 007F     // Port C initialization
; 0000 0080     // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 0081     DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(52)
	OUT  0x7,R30
; 0000 0082     // State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 0083     PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0084 
; 0000 0085     // Port D initialization
; 0000 0086     // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0087     DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(32)
	OUT  0xA,R30
; 0000 0088     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0089     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 008A 
; 0000 008B     // Timer/Counter 0 initialization
; 0000 008C     // Clock source: System Clock
; 0000 008D     // Clock value: Timer 0 Stopped
; 0000 008E     // Mode: Normal top=0xFF
; 0000 008F     // OC0A output: Disconnected
; 0000 0090     // OC0B output: Disconnected
; 0000 0091     TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0092     TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 0093     TCNT0=0x00;
	OUT  0x26,R30
; 0000 0094     OCR0A=0x00;
	OUT  0x27,R30
; 0000 0095     OCR0B=0x00;
	OUT  0x28,R30
; 0000 0096 
; 0000 0097     // Timer/Counter 1 initialization
; 0000 0098     // Clock source: System Clock
; 0000 0099     // Clock value: 8000,000 kHz
; 0000 009A     // Mode: Normal top=0xFFFF
; 0000 009B     // OC1A output: Disconnected
; 0000 009C     // OC1B output: Disconnected
; 0000 009D     // Noise Canceler: Off
; 0000 009E     // Input Capture on Falling Edge
; 0000 009F     // Timer Period: 4 ms
; 0000 00A0     // Timer1 Overflow Interrupt: On
; 0000 00A1     // Input Capture Interrupt: Off
; 0000 00A2     // Compare A Match Interrupt: Off
; 0000 00A3     // Compare B Match Interrupt: Off
; 0000 00A4     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00A5     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 00A6     TCNT1H=0x83;
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x0
; 0000 00A7     TCNT1L=0x00;
; 0000 00A8     ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 00A9     ICR1L=0x00;
	STS  134,R30
; 0000 00AA     OCR1AH=0x00;
	STS  137,R30
; 0000 00AB     OCR1AL=0x00;
	STS  136,R30
; 0000 00AC     OCR1BH=0x00;
	STS  139,R30
; 0000 00AD     OCR1BL=0x00;
	STS  138,R30
; 0000 00AE 
; 0000 00AF     // Timer/Counter 2 initialization
; 0000 00B0     // Clock source: System Clock
; 0000 00B1     // Clock value: Timer2 Stopped
; 0000 00B2     // Mode: Normal top=0xFF
; 0000 00B3     // OC2A output: Disconnected
; 0000 00B4     // OC2B output: Disconnected
; 0000 00B5     // ASSR=(0<<EXCLK) | (0<<AS2);
; 0000 00B6     // TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
; 0000 00B7     // TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
; 0000 00B8     // TCNT2=0x00;
; 0000 00B9     // OCR2A=0x00;
; 0000 00BA     // OCR2B=0x00;
; 0000 00BB 
; 0000 00BC     // Timer/Counter 2 initialization
; 0000 00BD     // Clock source: System Clock
; 0000 00BE     // Clock value: 250,000 kHz
; 0000 00BF     // Mode: Normal top=0xFF
; 0000 00C0     // OC2A output: Disconnected
; 0000 00C1     // OC2B output: Disconnected
; 0000 00C2     // Timer Period: 0,5 ms
; 0000 00C3     ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00C4     TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00C5     TCCR2B=(0<<WGM22) | (0<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(3)
	STS  177,R30
; 0000 00C6     TCNT2=0x83;
	LDI  R30,LOW(131)
	STS  178,R30
; 0000 00C7     OCR2A=0x00;
	LDI  R30,LOW(0)
	STS  179,R30
; 0000 00C8     OCR2B=0x00;
	STS  180,R30
; 0000 00C9 
; 0000 00CA     // Timer/Counter 0 Interrupt(s) initialization
; 0000 00CB     TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 00CC 
; 0000 00CD     // Timer/Counter 1 Interrupt(s) initialization
; 0000 00CE     TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 00CF 
; 0000 00D0 
; 0000 00D1     // Timer/Counter 2 Interrupt(s) initialization
; 0000 00D2     // TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
; 0000 00D3     TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);
	RCALL SUBOPT_0x1
; 0000 00D4 
; 0000 00D5     // External Interrupt(s) initialization
; 0000 00D6     // INT0: On
; 0000 00D7     // INT0 Mode: Falling Edge
; 0000 00D8     // INT1: On
; 0000 00D9     // INT1 Mode: Falling Edge
; 0000 00DA     // Interrupt on any change on pins PCINT0-7: Off
; 0000 00DB     // Interrupt on any change on pins PCINT8-14: Off
; 0000 00DC     // Interrupt on any change on pins PCINT16-23: Off
; 0000 00DD     EICRA=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	STS  105,R30
; 0000 00DE     EIMSK=(1<<INT1) | (1<<INT0);
	LDI  R30,LOW(3)
	OUT  0x1D,R30
; 0000 00DF     EIFR=(1<<INTF1) | (1<<INTF0);
	OUT  0x1C,R30
; 0000 00E0     PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 00E1 
; 0000 00E2     // USART initialization
; 0000 00E3     // USART disabled
; 0000 00E4     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00E5 
; 0000 00E6     // Analog Comparator initialization
; 0000 00E7     // Analog Comparator: Off
; 0000 00E8     // The Analog Comparator's positive input is
; 0000 00E9     // connected to the AIN0 pin
; 0000 00EA     // The Analog Comparator's negative input is
; 0000 00EB     // connected to the AIN1 pin
; 0000 00EC     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00ED     // Digital input buffer on AIN0: On
; 0000 00EE     // Digital input buffer on AIN1: On
; 0000 00EF     DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 00F0 
; 0000 00F1     // ADC initialization
; 0000 00F2     // ADC Clock frequency: 1000,000 kHz
; 0000 00F3     // ADC Voltage Reference: AREF pin
; 0000 00F4     // ADC Auto Trigger Source: ADC Stopped
; 0000 00F5     // Digital input buffers on ADC0: Off, ADC1: On, ADC2: Off, ADC3: Off
; 0000 00F6     // ADC4: Off, ADC5: Off
; 0000 00F7     // DIDR0=(1<<ADC5D) | (1<<ADC4D) | (1<<ADC3D) | (1<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
; 0000 00F8     // ADMUX=ADC_VREF_TYPE;
; 0000 00F9     // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0000 00FA     // ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
; 0000 00FB 
; 0000 00FC     // ADC initialization
; 0000 00FD     // ADC Clock frequency: 1000,000 kHz
; 0000 00FE     // ADC Voltage Reference: AREF pin
; 0000 00FF     // ADC Auto Trigger Source: ADC Stopped
; 0000 0100     // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0101     // ADC4: On, ADC5: On
; 0000 0102     DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0103     ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 0104     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 0105     ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0106 
; 0000 0107     // SPI initialization
; 0000 0108     // SPI disabled
; 0000 0109     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 010A 
; 0000 010B     // TWI initialization
; 0000 010C     // TWI disabled
; 0000 010D     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 010E 
; 0000 010F     // Global enable interrupts
; 0000 0110     #asm("sei")
	sei
; 0000 0111     Uint_data_led1 = 0;
	LDI  R30,LOW(0)
	STS  _Uint_data_led1,R30
	STS  _Uint_data_led1+1,R30
; 0000 0112     Uint_data_led2 = 0;
	STS  _Uint_data_led2,R30
	STS  _Uint_data_led2+1,R30
; 0000 0113     TIMER2_OFF;
	RCALL SUBOPT_0x2
; 0000 0114     ADE7753_INIT();
	RCALL _ADE7753_INIT
; 0000 0115     TIMER2_ON;
	RCALL SUBOPT_0x1
; 0000 0116     delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 0117     TIMER2_OFF;
	RCALL SUBOPT_0x2
; 0000 0118     delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 0119     TIMER2_ON;
	RCALL SUBOPT_0x1
; 0000 011A     delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 011B     TIMER2_OFF;
	RCALL SUBOPT_0x2
; 0000 011C     for(Uc_Loop_count = 0; Uc_Loop_count<10;Uc_Loop_count++)
	CLR  R3
_0x12:
	LDI  R30,LOW(10)
	CP   R3,R30
	BRSH _0x13
; 0000 011D     {
; 0000 011E         AI10_Voltage_buff[Uc_Loop_count] = 0;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 011F         AI10_Currrent_buff[Uc_Loop_count] = 0;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x5
; 0000 0120     }
	INC  R3
	RJMP _0x12
_0x13:
; 0000 0121     Uc_Buff_count = 0;
	CLR  R4
; 0000 0122     while (1)
_0x14:
; 0000 0123     {
; 0000 0124       // Place your code here
; 0000 0125         if(Bit_Zero_flag)
	SBIS 0x1E,2
	RJMP _0x17
; 0000 0126         {
; 0000 0127             /* Ghi nhan gia tri dong dien va dien ap vao buffer */
; 0000 0128             AI10_Voltage_buff[Uc_Buff_count] = (unsigned int)(ADE7753_READ(1,VRMS)/1034);
	MOV  R30,R4
	LDI  R26,LOW(_AI10_Voltage_buff)
	LDI  R27,HIGH(_AI10_Voltage_buff)
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x8
	LDI  R30,LOW(23)
	RCALL SUBOPT_0x9
	__GETD1N 0x40A
	RCALL __DIVD21U
	POP  R26
	POP  R27
	RCALL SUBOPT_0xA
; 0000 0129             AI10_Currrent_buff[Uc_Buff_count] = (unsigned int)(ADE7753_READ(1,IRMS)/228);
	MOV  R30,R4
	LDI  R26,LOW(_AI10_Currrent_buff)
	LDI  R27,HIGH(_AI10_Currrent_buff)
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x8
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x9
	__GETD1N 0xE4
	RCALL __DIVD21U
	POP  R26
	POP  R27
	RCALL SUBOPT_0xA
; 0000 012A 
; 0000 012B 
; 0000 012C             ADE7753_WRITE(1,RSTSTATUS,0x00,0x00,0x00);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xB
; 0000 012D             /* Tinh ddien ap */
; 0000 012E             for(Uc_Loop_count = 0; Uc_Loop_count<NUM_SAMPLE;Uc_Loop_count++)
	CLR  R3
_0x19:
	RCALL SUBOPT_0xC
	BRSH _0x1A
; 0000 012F             {
; 0000 0130                 AI10_Temp_buff[Uc_Loop_count] = AI10_Voltage_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x7
	MOVW R0,R30
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xE
; 0000 0131             }
	INC  R3
	RJMP _0x19
_0x1A:
; 0000 0132             for(Uc_Loop_count = 0; Uc_Loop_count<NUM_SAMPLE;Uc_Loop_count++)
	CLR  R3
_0x1C:
	RCALL SUBOPT_0xC
	BRSH _0x1D
; 0000 0133             {
; 0000 0134                 for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count<NUM_SAMPLE;Uc_Loop2_count++)
	MOV  R6,R3
_0x1F:
	LDI  R30,LOW(20)
	CP   R6,R30
	BRSH _0x20
; 0000 0135                 {
; 0000 0136                     if(AI10_Temp_buff[Uc_Loop_count] > AI10_Temp_buff[Uc_Loop2_count] )
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x21
; 0000 0137                     {
; 0000 0138                         Ulong_tmp = AI10_Temp_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
; 0000 0139                         AI10_Temp_buff[Uc_Loop_count] = AI10_Temp_buff[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
; 0000 013A                         AI10_Temp_buff[Uc_Loop2_count] = Ulong_tmp;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 013B                     }
; 0000 013C                 }
_0x21:
	INC  R6
	RJMP _0x1F
_0x20:
; 0000 013D             }
	INC  R3
	RJMP _0x1C
_0x1D:
; 0000 013E 
; 0000 013F             Ulong_tmp = 0;
	RCALL SUBOPT_0x15
; 0000 0140             for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count<NUM_SAMPLE-NUM_FILTER;Uc_Loop_count++)
_0x23:
	LDI  R30,LOW(16)
	CP   R3,R30
	BRSH _0x24
; 0000 0141             {
; 0000 0142                 Ulong_tmp += AI10_Temp_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x16
; 0000 0143             }
	INC  R3
	RJMP _0x23
_0x24:
; 0000 0144             Ulong_tmp /= (NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x17
; 0000 0145             if(Uint_Timer_Count == 200) Uint_data_led1 = (unsigned int) Ulong_tmp;
	BRNE _0x25
	RCALL SUBOPT_0x18
	STS  _Uint_data_led1,R30
	STS  _Uint_data_led1+1,R31
; 0000 0146 
; 0000 0147 
; 0000 0148             /* Tinh dong dien */
; 0000 0149             for(Uc_Loop_count = 0; Uc_Loop_count<NUM_SAMPLE;Uc_Loop_count++)
_0x25:
	CLR  R3
_0x27:
	RCALL SUBOPT_0xC
	BRSH _0x28
; 0000 014A             {
; 0000 014B                 AI10_Temp_buff[Uc_Loop_count] = AI10_Currrent_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x7
	MOVW R0,R30
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xE
; 0000 014C             }
	INC  R3
	RJMP _0x27
_0x28:
; 0000 014D             for(Uc_Loop_count = 0; Uc_Loop_count<NUM_SAMPLE;Uc_Loop_count++)
	CLR  R3
_0x2A:
	RCALL SUBOPT_0xC
	BRSH _0x2B
; 0000 014E             {
; 0000 014F                 for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count<NUM_SAMPLE;Uc_Loop2_count++)
	MOV  R6,R3
_0x2D:
	LDI  R30,LOW(20)
	CP   R6,R30
	BRSH _0x2E
; 0000 0150                 {
; 0000 0151                     if(AI10_Temp_buff[Uc_Loop_count] > AI10_Temp_buff[Uc_Loop2_count] )
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x2F
; 0000 0152                     {
; 0000 0153                         Ulong_tmp = AI10_Temp_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
; 0000 0154                         AI10_Temp_buff[Uc_Loop_count] = AI10_Temp_buff[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
; 0000 0155                         AI10_Temp_buff[Uc_Loop2_count] = Ulong_tmp;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 0156                     }
; 0000 0157                 }
_0x2F:
	INC  R6
	RJMP _0x2D
_0x2E:
; 0000 0158             }
	INC  R3
	RJMP _0x2A
_0x2B:
; 0000 0159 
; 0000 015A             Ulong_tmp = 0;
	RCALL SUBOPT_0x15
; 0000 015B             for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count<NUM_SAMPLE-NUM_FILTER;Uc_Loop_count++)
_0x31:
	LDI  R30,LOW(16)
	CP   R3,R30
	BRSH _0x32
; 0000 015C             {
; 0000 015D                 Ulong_tmp += AI10_Temp_buff[Uc_Loop_count];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x16
; 0000 015E             }
	INC  R3
	RJMP _0x31
_0x32:
; 0000 015F             Ulong_tmp /= (NUM_SAMPLE-2*NUM_FILTER);
	RCALL SUBOPT_0x17
; 0000 0160 
; 0000 0161             if(Uint_Timer_Count == 200)
	BRNE _0x33
; 0000 0162             {
; 0000 0163                  Uint_data_led2 = (unsigned int) Ulong_tmp;
	RCALL SUBOPT_0x18
	STS  _Uint_data_led2,R30
	STS  _Uint_data_led2+1,R31
; 0000 0164                  Uint_Timer_Count = 0;
	CLR  R7
	CLR  R8
; 0000 0165             }
; 0000 0166 
; 0000 0167 
; 0000 0168             Uc_Buff_count++;
_0x33:
	INC  R4
; 0000 0169             if(Uc_Buff_count >= NUM_SAMPLE)
	LDI  R30,LOW(20)
	CP   R4,R30
	BRLO _0x34
; 0000 016A             {
; 0000 016B                 Uc_Buff_count = 0;
	CLR  R4
; 0000 016C             }
; 0000 016D             /*
; 0000 016E             *   Doc Current_Set
; 0000 016F             *   So sanh va dua ra canh bao
; 0000 0170             */
; 0000 0171             Ulong_tmp = read_adc(1);
_0x34:
	LDI  R26,LOW(1)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x19
; 0000 0172             Ulong_tmp = Ulong_tmp*(CURRENT_SET_MAX-CURRENT_SET_MIN)*100/1023 + CURRENT_SET_MIN*100;
	LDS  R30,_Ulong_tmp
	LDS  R31,_Ulong_tmp+1
	LDS  R22,_Ulong_tmp+2
	LDS  R23,_Ulong_tmp+3
	__GETD2N 0xD
	RCALL __MULD12U
	__GETD2N 0x64
	RCALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	RCALL __DIVD21U
	__ADDD1N 700
	RCALL SUBOPT_0x19
; 0000 0173             //Uint_data_led1 = Ulong_tmp;
; 0000 0174             if(Ulong_tmp < Uint_data_led2)
	LDS  R30,_Uint_data_led2
	LDS  R31,_Uint_data_led2+1
	LDS  R26,_Ulong_tmp
	LDS  R27,_Ulong_tmp+1
	LDS  R24,_Ulong_tmp+2
	LDS  R25,_Ulong_tmp+3
	CLR  R22
	CLR  R23
	RCALL __CPD21
	BRSH _0x35
; 0000 0175             {
; 0000 0176                 Bit_warning = 1;
	SBI  0x1E,1
; 0000 0177             }
; 0000 0178             else    Bit_warning = 0;
	RJMP _0x38
_0x35:
	CBI  0x1E,1
; 0000 0179             Bit_Zero_flag = 0;
_0x38:
	CBI  0x1E,2
; 0000 017A         }
; 0000 017B 
; 0000 017C         if(Bit_warning)
_0x17:
	SBIS 0x1E,1
	RJMP _0x3D
; 0000 017D         {
; 0000 017E             TIMER2_ON;
	RCALL SUBOPT_0x1
; 0000 017F             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0180             TIMER2_OFF;
	RCALL SUBOPT_0x2
; 0000 0181             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0182         }
; 0000 0183 
; 0000 0184     }
_0x3D:
	RJMP _0x14
; 0000 0185 }
_0x3E:
	RJMP _0x3E
; .FEND
;#include "ADE7753.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;#include "delay.h"
;#include "scan_led.h"
;
;
;void    SPI_7753_SEND(unsigned char data)
; 0001 0007 {

	.CSEG
_SPI_7753_SEND:
; .FSTART _SPI_7753_SEND
; 0001 0008     unsigned char   cnt;
; 0001 0009     unsigned char   tmp = data;
; 0001 000A 
; 0001 000B     for(cnt = 0;cnt < 8; cnt++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	cnt -> R17
;	tmp -> R16
	LDD  R16,Y+2
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 000C     {
; 0001 000D         if((tmp & 0x80) == 0x80)   SPI_MOSI_HIGHT;
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x20006
	SBI  0x8,2
; 0001 000E         else SPI_MOSI_LOW;
	RJMP _0x20009
_0x20006:
	CBI  0x8,2
; 0001 000F 
; 0001 0010         SPI_SCK_HIGHT;
_0x20009:
	RCALL SUBOPT_0x1A
; 0001 0011         delay_us(50);
; 0001 0012         SPI_SCK_LOW;
	RCALL SUBOPT_0x1B
; 0001 0013         delay_us(50);
; 0001 0014         tmp <<= 1;
	LSL  R16
; 0001 0015     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0016 }
	RCALL __LOADLOCR2
	RJMP _0x2000001
; .FEND
;
;unsigned char    SPI_7753_RECEIVE(void)
; 0001 0019 {
_SPI_7753_RECEIVE:
; .FSTART _SPI_7753_RECEIVE
; 0001 001A     unsigned char cnt;
; 0001 001B     unsigned char data;
; 0001 001C     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0001 001D     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x20011:
	CPI  R17,8
	BRSH _0x20012
; 0001 001E     {
; 0001 001F         data <<= 1;
	LSL  R16
; 0001 0020         SPI_SCK_HIGHT;
	RCALL SUBOPT_0x1A
; 0001 0021         delay_us(50);
; 0001 0022         if(SPI_MISO_HIGHT)
	SBIC 0x6,3
; 0001 0023         {
; 0001 0024             data += 1;
	SUBI R16,-LOW(1)
; 0001 0025         }
; 0001 0026         SPI_SCK_LOW;
	RCALL SUBOPT_0x1B
; 0001 0027         delay_us(50);
; 0001 0028     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0029     return data;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 002A }
; .FEND
;
;void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0001 002D {
_ADE7753_WRITE:
; .FSTART _ADE7753_WRITE
; 0001 002E     unsigned char data[4];
; 0001 002F     unsigned char   i;
; 0001 0030     data[0] = data_1;
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
	RCALL SUBOPT_0x1C
; 0001 0031     data[1] = data_2;
; 0001 0032     data[2] = data_3;
; 0001 0033 
; 0001 0034     switch (IC_CS)
	LDD  R30,Y+10
	RCALL SUBOPT_0x1D
; 0001 0035     {
; 0001 0036         case 1:
	BRNE _0x2001B
; 0001 0037         {
; 0001 0038             PHASE_1_ON;
	CBI  0x8,5
; 0001 0039             PHASE_2_OFF;
	RCALL SUBOPT_0x1E
; 0001 003A             PHASE_3_OFF;
; 0001 003B             break;
	RJMP _0x2001A
; 0001 003C         }
; 0001 003D         case 2:
_0x2001B:
	RCALL SUBOPT_0x1F
	BRNE _0x20022
; 0001 003E         {
; 0001 003F             PHASE_1_OFF;
	SBI  0x8,5
; 0001 0040             PHASE_2_ON;
	CBI  0x5,0
; 0001 0041             PHASE_3_OFF;
	SBI  0x5,0
; 0001 0042             break;
	RJMP _0x2001A
; 0001 0043         }
; 0001 0044         case 3:
_0x20022:
	RCALL SUBOPT_0x20
	BRNE _0x2001A
; 0001 0045         {
; 0001 0046             PHASE_1_OFF;
	SBI  0x8,5
; 0001 0047             PHASE_2_OFF;
	SBI  0x5,0
; 0001 0048             PHASE_3_ON;
	CBI  0x5,0
; 0001 0049             break;
; 0001 004A         }
; 0001 004B     }
_0x2001A:
; 0001 004C     addr &= 0x3F;
	LDD  R30,Y+9
	ANDI R30,LOW(0x3F)
	STD  Y+9,R30
; 0001 004D     addr |= 0x80;
	ORI  R30,0x80
	STD  Y+9,R30
; 0001 004E     delay_us(100);
	RCALL SUBOPT_0x21
; 0001 004F     SPI_7753_SEND(addr);
	LDD  R26,Y+9
	RCALL _SPI_7753_SEND
; 0001 0050     delay_us(100);
	RCALL SUBOPT_0x21
; 0001 0051     for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
	LDI  R17,LOW(0)
_0x20031:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0x20032
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LD   R26,X
	RCALL _SPI_7753_SEND
	SUBI R17,-1
	RJMP _0x20031
_0x20032:
; 0001 0052 delay_us(100);
	RCALL SUBOPT_0x21
; 0001 0053     PHASE_1_OFF;
	SBI  0x8,5
; 0001 0054     PHASE_2_OFF;
	RCALL SUBOPT_0x1E
; 0001 0055     PHASE_3_OFF;
; 0001 0056 }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND
;unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0001 0058 {
_ADE7753_READ:
; .FSTART _ADE7753_READ
; 0001 0059     unsigned char   i;
; 0001 005A     unsigned char   data[4];
; 0001 005B     unsigned long int res;
; 0001 005C     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,8
	ST   -Y,R17
;	IC_CS -> Y+11
;	addr -> Y+10
;	num_data -> Y+9
;	i -> R17
;	data -> Y+5
;	res -> Y+1
	LDI  R17,LOW(0)
_0x2003A:
	CPI  R17,4
	BRSH _0x2003B
	RCALL SUBOPT_0x22
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2003A
_0x2003B:
; 0001 005D switch (IC_CS)
	LDD  R30,Y+11
	RCALL SUBOPT_0x1D
; 0001 005E     {
; 0001 005F         case 1:
	BRNE _0x2003F
; 0001 0060         {
; 0001 0061             PHASE_1_ON;
	CBI  0x8,5
; 0001 0062             PHASE_2_OFF;
	RCALL SUBOPT_0x1E
; 0001 0063             PHASE_3_OFF;
; 0001 0064             break;
	RJMP _0x2003E
; 0001 0065         }
; 0001 0066         case 2:
_0x2003F:
	RCALL SUBOPT_0x1F
	BRNE _0x20046
; 0001 0067         {
; 0001 0068             PHASE_1_OFF;
	SBI  0x8,5
; 0001 0069             PHASE_2_ON;
	CBI  0x5,0
; 0001 006A             PHASE_3_OFF;
	SBI  0x5,0
; 0001 006B             break;
	RJMP _0x2003E
; 0001 006C         }
; 0001 006D         case 3:
_0x20046:
	RCALL SUBOPT_0x20
	BRNE _0x2003E
; 0001 006E         {
; 0001 006F             PHASE_1_OFF;
	SBI  0x8,5
; 0001 0070             PHASE_2_OFF;
	SBI  0x5,0
; 0001 0071             PHASE_3_ON;
	CBI  0x5,0
; 0001 0072             break;
; 0001 0073         }
; 0001 0074     }
_0x2003E:
; 0001 0075     delay_us(100);
	RCALL SUBOPT_0x21
; 0001 0076     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0001 0077     SPI_7753_SEND(addr);
	LDD  R26,Y+10
	RCALL _SPI_7753_SEND
; 0001 0078     delay_us(100);
	RCALL SUBOPT_0x21
; 0001 0079     for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
	LDI  R17,LOW(0)
_0x20055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20056
	RCALL SUBOPT_0x22
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _SPI_7753_RECEIVE
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20055
_0x20056:
; 0001 007A delay_us(100);
	RCALL SUBOPT_0x21
; 0001 007B     PHASE_1_OFF;
	SBI  0x8,5
; 0001 007C     PHASE_2_OFF;
	RCALL SUBOPT_0x1E
; 0001 007D     PHASE_3_OFF;
; 0001 007E     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0001 007F     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x2005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x2005F
; 0001 0080     {
; 0001 0081         res <<= 8;
	RCALL SUBOPT_0x24
	LDI  R30,LOW(8)
	RCALL __LSLD12
	RCALL SUBOPT_0x25
; 0001 0082         res += data[i];
	RCALL SUBOPT_0x22
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	RCALL SUBOPT_0x24
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0x25
; 0001 0083     }
	SUBI R17,-1
	RJMP _0x2005E
_0x2005F:
; 0001 0084     return res;
	__GETD1S 1
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0001 0085 }
; .FEND
;
;void    ADE7753_INIT(void)
; 0001 0088 {
_ADE7753_INIT:
; .FSTART _ADE7753_INIT
; 0001 0089     ADE7753_WRITE(1,MODE,0x00,0x00,0x00);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
; 0001 008A     delay_ms(200);
; 0001 008B     ADE7753_WRITE(1,IRQEN,0x00,0x10,0x00);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x26
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
; 0001 008C     delay_ms(200);
	RCALL SUBOPT_0x3
; 0001 008D     ADE7753_WRITE(1,RSTSTATUS,0x00,0x00,0x00);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xB
; 0001 008E     delay_ms(200);
	RCALL SUBOPT_0x3
; 0001 008F     ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(31)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL SUBOPT_0x27
; 0001 0090     delay_ms(200);
; 0001 0091     ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL SUBOPT_0x27
; 0001 0092     delay_ms(200);
; 0001 0093 }
	RET
; .FEND
;#include "scan_led.h"
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;
;unsigned char   Uc_led_count = 1;

	.DSEG
;unsigned char   Uc_led_data = 0;
;unsigned int    Uint_data_led1 = 0;
;unsigned int    Uint_data_led2 = 0;
;unsigned int    Uint_data_led3 = 0;
;
;/* Day du lieu quet led qua duong spi_software
;Co thẻ day tu 1 den 3 byte du lieu.
;Du lieu sau khi day ra day du moi tien hanh xuat du lieu
;num_bytes : so byte duoc day ra
;data_first : du lieu dau tien
;data_second: du lieu thu 2
;data_third ; du lieu thu 3
;*/
;void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_first,unsigned char  byte_second,unsigned char  byte_t ...
; 0002 0013 {

	.CSEG
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0002 0014     unsigned char   i;
; 0002 0015     unsigned char   data[4];
; 0002 0016     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	num_bytes -> Y+8
;	byte_first -> Y+7
;	byte_second -> Y+6
;	byte_third -> Y+5
;	i -> R17
;	data -> Y+1
	LDI  R17,LOW(0)
_0x40005:
	CPI  R17,4
	BRSH _0x40006
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x40005
_0x40006:
; 0002 0017 data[0] = byte_first;
	RCALL SUBOPT_0x1C
; 0002 0018     data[1] = byte_second;
; 0002 0019     data[2] = byte_third;
; 0002 001A 
; 0002 001B     for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
	LDI  R17,LOW(0)
_0x40008:
	LDD  R30,Y+8
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x40009
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
	SUBI R17,-1
	RJMP _0x40008
_0x40009:
; 0002 001C SPI_SENDBYTE(data[i],1);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0002 001D }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
;
;void    SELECT_LED(unsigned char num_led,unsigned char    data)
; 0002 0020 {
_SELECT_LED:
; .FSTART _SELECT_LED
; 0002 0021     unsigned char   byte1,byte2,byte3;
; 0002 0022     byte1 = 0;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	num_led -> Y+5
;	data -> Y+4
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
	LDI  R17,LOW(0)
; 0002 0023     byte2 = 0;
	LDI  R16,LOW(0)
; 0002 0024     byte3 = 0;
	LDI  R19,LOW(0)
; 0002 0025     switch(num_led)
	LDD  R30,Y+5
	RCALL SUBOPT_0x1D
; 0002 0026     {
; 0002 0027         case    1:
	BRNE _0x4000D
; 0002 0028         {
; 0002 0029             byte3 = 0x01;
	LDI  R19,LOW(1)
; 0002 002A             byte2 = 0x01;
	LDI  R16,LOW(1)
; 0002 002B             break;
	RJMP _0x4000C
; 0002 002C         }
; 0002 002D         case    2:
_0x4000D:
	RCALL SUBOPT_0x1F
	BRNE _0x4000E
; 0002 002E         {
; 0002 002F             byte3 = 0x02;
	LDI  R19,LOW(2)
; 0002 0030             byte2 = 0x02;
	LDI  R16,LOW(2)
; 0002 0031             //byte1 = 0x04;
; 0002 0032             break;
	RJMP _0x4000C
; 0002 0033         }
; 0002 0034         case    3:
_0x4000E:
	RCALL SUBOPT_0x20
	BRNE _0x4000F
; 0002 0035         {
; 0002 0036             byte3 = 0x04;
	LDI  R19,LOW(4)
; 0002 0037             byte2 = 0x04;
	LDI  R16,LOW(4)
; 0002 0038             byte1 = 0x40;
	LDI  R17,LOW(64)
; 0002 0039             break;
	RJMP _0x4000C
; 0002 003A         }
; 0002 003B         case    4:
_0x4000F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x40010
; 0002 003C         {
; 0002 003D             byte3 = 0x08;
	LDI  R19,LOW(8)
; 0002 003E             byte2 = 0x08;
	LDI  R16,LOW(8)
; 0002 003F             break;
	RJMP _0x4000C
; 0002 0040         }
; 0002 0041         case    5:
_0x40010:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40011
; 0002 0042         {
; 0002 0043             byte3 = 0x40;
	LDI  R19,LOW(64)
; 0002 0044             byte2 = 0x80;
	RJMP _0x4003E
; 0002 0045             break;
; 0002 0046         }
; 0002 0047         case    6:
_0x40011:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x40012
; 0002 0048         {
; 0002 0049             byte3 = 0x20;
	LDI  R19,LOW(32)
; 0002 004A             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0002 004B             byte1 = 0x40;
	LDI  R17,LOW(64)
; 0002 004C             break;
	RJMP _0x4000C
; 0002 004D         }
; 0002 004E         case    7:
_0x40012:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40013
; 0002 004F         {
; 0002 0050             byte3 = 0x10;
	LDI  R19,LOW(16)
; 0002 0051             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0002 0052             break;
	RJMP _0x4000C
; 0002 0053         }
; 0002 0054         case    8:
_0x40013:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40014
; 0002 0055         {
; 0002 0056             byte3 = 0x80;
	LDI  R19,LOW(128)
; 0002 0057             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0002 0058             break;
	RJMP _0x4000C
; 0002 0059         }
; 0002 005A         case    9:
_0x40014:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x40015
; 0002 005B         {
; 0002 005C             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0002 005D             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0002 005E             break;
	RJMP _0x4000C
; 0002 005F         }
; 0002 0060         case    10:
_0x40015:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x40016
; 0002 0061         {
; 0002 0062             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0002 0063             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0002 0064             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0002 0065             break;
	RJMP _0x4000C
; 0002 0066         }
; 0002 0067         case    11:
_0x40016:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x40017
; 0002 0068         {
; 0002 0069             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0002 006A             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0002 006B             break;
	RJMP _0x4000C
; 0002 006C         }
; 0002 006D         case    12:
_0x40017:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4000C
; 0002 006E         {
; 0002 006F             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0002 0070             byte2 = 0x80;
_0x4003E:
	LDI  R16,LOW(128)
; 0002 0071             break;
; 0002 0072         }
; 0002 0073     }
_0x4000C:
; 0002 0074     switch(data)
	LDD  R30,Y+4
	LDI  R31,0
; 0002 0075     {
; 0002 0076         case    0:
	SBIW R30,0
	BRNE _0x4001C
; 0002 0077         {
; 0002 0078             byte1 |= 0xB7;
	ORI  R17,LOW(183)
; 0002 0079             break;
	RJMP _0x4001B
; 0002 007A         }
; 0002 007B         case    1:
_0x4001C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4001D
; 0002 007C         {
; 0002 007D             byte1 |= 0x81;
	ORI  R17,LOW(129)
; 0002 007E             break;
	RJMP _0x4001B
; 0002 007F         }
; 0002 0080         case    2:
_0x4001D:
	RCALL SUBOPT_0x1F
	BRNE _0x4001E
; 0002 0081         {
; 0002 0082             byte1 |= 0x3D;
	ORI  R17,LOW(61)
; 0002 0083             break;
	RJMP _0x4001B
; 0002 0084         }
; 0002 0085         case    3:
_0x4001E:
	RCALL SUBOPT_0x20
	BRNE _0x4001F
; 0002 0086         {
; 0002 0087             byte1 |= 0xAD;
	ORI  R17,LOW(173)
; 0002 0088             break;
	RJMP _0x4001B
; 0002 0089         }
; 0002 008A         case    4:
_0x4001F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x40020
; 0002 008B         {
; 0002 008C             byte1 |= 0x8B;
	ORI  R17,LOW(139)
; 0002 008D             break;
	RJMP _0x4001B
; 0002 008E         }
; 0002 008F         case    5:
_0x40020:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40021
; 0002 0090         {
; 0002 0091             byte1 |= 0xAE;
	ORI  R17,LOW(174)
; 0002 0092             break;
	RJMP _0x4001B
; 0002 0093         }
; 0002 0094         case    6:
_0x40021:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x40022
; 0002 0095         {
; 0002 0096             byte1 |= 0xBE;
	ORI  R17,LOW(190)
; 0002 0097             break;
	RJMP _0x4001B
; 0002 0098         }
; 0002 0099         case    7:
_0x40022:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40023
; 0002 009A         {
; 0002 009B             byte1 |= 0x85;
	ORI  R17,LOW(133)
; 0002 009C             break;
	RJMP _0x4001B
; 0002 009D         }
; 0002 009E         case    8:
_0x40023:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40024
; 0002 009F         {
; 0002 00A0             byte1 |= 0xBF;
	ORI  R17,LOW(191)
; 0002 00A1             break;
	RJMP _0x4001B
; 0002 00A2         }
; 0002 00A3         case    9:
_0x40024:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x4001B
; 0002 00A4         {
; 0002 00A5             byte1 |= 0xAF;
	ORI  R17,LOW(175)
; 0002 00A6             break;
; 0002 00A7         }
; 0002 00A8     }
_0x4001B:
; 0002 00A9     SEND_DATA_LED(2,byte1,byte2,byte3);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _SEND_DATA_LED
; 0002 00AA }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void SCAN_LED(void)
; 0002 00AD {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0002 00AE     if(Uc_led_count == 1)   Uc_led_data = Uint_data_led1/1000;
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x1)
	BRNE _0x40026
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RJMP _0x4003F
; 0002 00AF     else if(Uc_led_count == 2)   Uc_led_data = (Uint_data_led1/100)%10;
_0x40026:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x2)
	BRNE _0x40028
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2B
	RJMP _0x40040
; 0002 00B0     else if(Uc_led_count == 3)   Uc_led_data = (Uint_data_led1/10)%10;
_0x40028:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x3)
	BRNE _0x4002A
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
	RJMP _0x40040
; 0002 00B1     else if(Uc_led_count == 4)   Uc_led_data = (Uint_data_led1%10);
_0x4002A:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x4)
	BRNE _0x4002C
	RCALL SUBOPT_0x29
	RJMP _0x40040
; 0002 00B2     else if(Uc_led_count == 5)   Uc_led_data = Uint_data_led2/1000;
_0x4002C:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x5)
	BRNE _0x4002E
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2A
	RJMP _0x4003F
; 0002 00B3     else if(Uc_led_count == 6)   Uc_led_data = (Uint_data_led2/100)%10;
_0x4002E:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x6)
	BRNE _0x40030
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2B
	RJMP _0x40040
; 0002 00B4     else if(Uc_led_count == 7)   Uc_led_data = (Uint_data_led2/10)%10;
_0x40030:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x7)
	BRNE _0x40032
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2C
	RJMP _0x40040
; 0002 00B5     else if(Uc_led_count == 8)   Uc_led_data = (Uint_data_led2%10);
_0x40032:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x8)
	BRNE _0x40034
	RCALL SUBOPT_0x2D
	RJMP _0x40040
; 0002 00B6     else if(Uc_led_count == 9)   Uc_led_data = Uint_data_led3/1000;
_0x40034:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x9)
	BRNE _0x40036
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2A
	RJMP _0x4003F
; 0002 00B7     else if(Uc_led_count == 10)   Uc_led_data = (Uint_data_led3/100)%10;
_0x40036:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0xA)
	BRNE _0x40038
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2B
	RJMP _0x40040
; 0002 00B8     else if(Uc_led_count == 11)   Uc_led_data = (Uint_data_led3/10)%10;
_0x40038:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0xB)
	BRNE _0x4003A
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2C
	RJMP _0x40040
; 0002 00B9     else if(Uc_led_count == 12)   Uc_led_data = (Uint_data_led3%10);
_0x4003A:
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0xC)
	BRNE _0x4003C
	RCALL SUBOPT_0x2E
_0x40040:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0x4003F:
	STS  _Uc_led_data,R30
; 0002 00BA     SELECT_LED(Uc_led_count,Uc_led_data);
_0x4003C:
	LDS  R30,_Uc_led_count
	ST   -Y,R30
	LDS  R26,_Uc_led_data
	RCALL _SELECT_LED
; 0002 00BB     Uc_led_count++;
	LDS  R30,_Uc_led_count
	SUBI R30,-LOW(1)
	STS  _Uc_led_count,R30
; 0002 00BC     if(Uc_led_count > NUM_LED_SCAN*4)    Uc_led_count = 1;
	RCALL SUBOPT_0x28
	CPI  R26,LOW(0x9)
	BRLO _0x4003D
	LDI  R30,LOW(1)
	STS  _Uc_led_count,R30
; 0002 00BD }
_0x4003D:
	RET
; .FEND
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;
;
;void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
; 0003 0005 {

	.CSEG
_SPI_SENDBYTE:
; .FSTART _SPI_SENDBYTE
; 0003 0006     unsigned char   i;
; 0003 0007     for(i=0;i<8;i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+2
;	action -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x60004:
	CPI  R17,8
	BRSH _0x60005
; 0003 0008     {
; 0003 0009         if((data & 0x80) == 0x80)    DO_SPI_MOSI = 1;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x60006
	SBI  0x5,3
; 0003 000A         else    DO_SPI_MOSI = 0;
	RJMP _0x60009
_0x60006:
	CBI  0x5,3
; 0003 000B         data <<= 1;
_0x60009:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0003 000C         DO_SPI_SCK = 1;
	SBI  0x5,5
; 0003 000D         DO_SPI_SCK = 0;
	CBI  0x5,5
; 0003 000E     }
	SUBI R17,-1
	RJMP _0x60004
_0x60005:
; 0003 000F     if(action)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x60010
; 0003 0010     {
; 0003 0011         DO_SPI_LATCH = 1;
	SBI  0x5,1
; 0003 0012         DO_SPI_LATCH = 0;
	CBI  0x5,1
; 0003 0013     }
; 0003 0014 }
_0x60010:
	LDD  R17,Y+0
_0x2000001:
	ADIW R28,3
	RET
; .FEND

	.DSEG
_Uc_led_count:
	.BYTE 0x1
_Uc_led_data:
	.BYTE 0x1
_Uint_data_led1:
	.BYTE 0x2
_Uint_data_led2:
	.BYTE 0x2
_Uint_data_led3:
	.BYTE 0x2
_AI10_Voltage_buff:
	.BYTE 0x28
_AI10_Currrent_buff:
	.BYTE 0x28
_AI10_Temp_buff:
	.BYTE 0x28
_Ulong_tmp:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	STS  133,R30
	LDI  R30,LOW(0)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	STS  112,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  112,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(200)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	MOV  R30,R3
	LDI  R26,LOW(_AI10_Voltage_buff)
	LDI  R27,HIGH(_AI10_Voltage_buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	MOV  R30,R3
	LDI  R26,LOW(_AI10_Currrent_buff)
	LDI  R27,HIGH(_AI10_Currrent_buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x7:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _ADE7753_WRITE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(20)
	CP   R3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xD:
	MOV  R30,R3
	LDI  R26,LOW(_AI10_Temp_buff)
	LDI  R27,HIGH(_AI10_Temp_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	RCALL __GETW1P
	MOVW R26,R0
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0xF:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LD   R0,X+
	LD   R1,X
	MOV  R30,R6
	LDI  R26,LOW(_AI10_Temp_buff)
	LDI  R27,HIGH(_AI10_Temp_buff)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	RCALL __GETW1P
	CLR  R22
	CLR  R23
	STS  _Ulong_tmp,R30
	STS  _Ulong_tmp+1,R31
	STS  _Ulong_tmp+2,R22
	STS  _Ulong_tmp+3,R23
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOVW R0,R30
	MOV  R30,R6
	LDI  R26,LOW(_AI10_Temp_buff)
	LDI  R27,HIGH(_AI10_Temp_buff)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	MOV  R30,R6
	LDI  R26,LOW(_AI10_Temp_buff)
	LDI  R27,HIGH(_AI10_Temp_buff)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R26,_Ulong_tmp
	LDS  R27,_Ulong_tmp+1
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _Ulong_tmp,R30
	STS  _Ulong_tmp+1,R30
	STS  _Ulong_tmp+2,R30
	STS  _Ulong_tmp+3,R30
	LDI  R30,LOW(4)
	MOV  R3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16:
	RCALL __GETW1P
	LDS  R26,_Ulong_tmp
	LDS  R27,_Ulong_tmp+1
	LDS  R24,_Ulong_tmp+2
	LDS  R25,_Ulong_tmp+3
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	STS  _Ulong_tmp,R30
	STS  _Ulong_tmp+1,R31
	STS  _Ulong_tmp+2,R22
	STS  _Ulong_tmp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x17:
	LDS  R26,_Ulong_tmp
	LDS  R27,_Ulong_tmp+1
	LDS  R24,_Ulong_tmp+2
	LDS  R25,_Ulong_tmp+3
	__GETD1N 0xC
	RCALL __DIVD21U
	STS  _Ulong_tmp,R30
	STS  _Ulong_tmp+1,R31
	STS  _Ulong_tmp+2,R22
	STS  _Ulong_tmp+3,R23
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R7
	CPC  R31,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDS  R30,_Ulong_tmp
	LDS  R31,_Ulong_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	STS  _Ulong_tmp,R30
	STS  _Ulong_tmp+1,R31
	STS  _Ulong_tmp+2,R22
	STS  _Ulong_tmp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	SBI  0x8,4
	__DELAY_USB 133
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CBI  0x8,4
	__DELAY_USB 133
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+7
	STD  Y+1,R30
	LDD  R30,Y+6
	STD  Y+2,R30
	LDD  R30,Y+5
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	SBI  0x5,0
	SBI  0x5,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ADE7753_WRITE
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x28:
	LDS  R26,_Uc_led_count
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2E:
	LDS  R26,_Uint_data_led3
	LDS  R27,_Uint_data_led3+1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
