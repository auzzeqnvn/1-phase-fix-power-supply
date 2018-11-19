
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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

_0x60003:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _Uc_led_count
	.DW  _0x60003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

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
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
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
;#include "ADE7753.h"
;#include "scan_led.h"
;#include <delay.h>
;
;#define BUZZER  PORTD.5
;#define BUZZER_ON   BUZZER = 1
;#define BUZZER_OFF  BUZZER = 0
;
;// Declare your global variables here
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0026 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 0027 // Place your code here
; 0000 0028 
; 0000 0029 }
	RETI
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 002D {
_ext_int1_isr:
; .FSTART _ext_int1_isr
; 0000 002E // Place your code here
; 0000 002F 
; 0000 0030 }
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0034 {
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
; 0000 0035     // Reinitialize Timer1 value
; 0000 0036     TCNT1H=0x8300 >> 8;
	RCALL SUBOPT_0x0
; 0000 0037     TCNT1L=0x8300 & 0xff;
; 0000 0038     // Place your code here
; 0000 0039     SCAN_LED();
	RCALL _SCAN_LED
; 0000 003A }
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
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0043 {
; 0000 0044     ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0045     // Delay needed for the stabilization of the ADC input voltage
; 0000 0046     delay_us(10);
; 0000 0047     // Start the AD conversion
; 0000 0048     ADCSRA|=(1<<ADSC);
; 0000 0049     // Wait for the AD conversion to complete
; 0000 004A     while ((ADCSRA & (1<<ADIF))==0);
; 0000 004B     ADCSRA|=(1<<ADIF);
; 0000 004C     return ADCW;
; 0000 004D }
;
;void main(void)
; 0000 0050 {
_main:
; .FSTART _main
; 0000 0051 // Declare your local variables here
; 0000 0052 
; 0000 0053 // Input/Output Ports initialization
; 0000 0054 // Port B initialization
; 0000 0055 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=Out Bit0=In
; 0000 0056 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(42)
	OUT  0x17,R30
; 0000 0057 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=0 Bit0=T
; 0000 0058 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0059 
; 0000 005A // Port C initialization
; 0000 005B // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 005C DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(52)
	OUT  0x14,R30
; 0000 005D // State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 005E PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 005F 
; 0000 0060 // Port D initialization
; 0000 0061 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0062 DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 0063 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0064 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0065 
; 0000 0066 // Timer/Counter 0 initialization
; 0000 0067 // Clock source: System Clock
; 0000 0068 // Clock value: Timer 0 Stopped
; 0000 0069 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 006A TCNT0=0x00;
	OUT  0x32,R30
; 0000 006B 
; 0000 006C // Timer/Counter 1 initialization
; 0000 006D // Clock source: System Clock
; 0000 006E // Clock value: 8000.000 kHz
; 0000 006F // Mode: Normal top=0xFFFF
; 0000 0070 // OC1A output: Disconnected
; 0000 0071 // OC1B output: Disconnected
; 0000 0072 // Noise Canceler: Off
; 0000 0073 // Input Capture on Falling Edge
; 0000 0074 // Timer Period: 4 ms
; 0000 0075 // Timer1 Overflow Interrupt: On
; 0000 0076 // Input Capture Interrupt: Off
; 0000 0077 // Compare A Match Interrupt: Off
; 0000 0078 // Compare B Match Interrupt: Off
; 0000 0079 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 007A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 007B TCNT1H=0x83;
	RCALL SUBOPT_0x0
; 0000 007C TCNT1L=0x00;
; 0000 007D ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 007E ICR1L=0x00;
	OUT  0x26,R30
; 0000 007F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0080 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0081 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0082 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0083 
; 0000 0084 // Timer/Counter 2 initialization
; 0000 0085 // Clock source: System Clock
; 0000 0086 // Clock value: Timer2 Stopped
; 0000 0087 // Mode: Normal top=0xFF
; 0000 0088 // OC2 output: Disconnected
; 0000 0089 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 008A TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 008B TCNT2=0x00;
	OUT  0x24,R30
; 0000 008C OCR2=0x00;
	OUT  0x23,R30
; 0000 008D 
; 0000 008E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 008F TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0090 
; 0000 0091 // External Interrupt(s) initialization
; 0000 0092 // INT0: On
; 0000 0093 // INT0 Mode: Falling Edge
; 0000 0094 // INT1: On
; 0000 0095 // INT1 Mode: Falling Edge
; 0000 0096 GICR|=(1<<INT1) | (1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0097 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0098 GIFR=(1<<INTF1) | (1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0099 
; 0000 009A // USART initialization
; 0000 009B // USART disabled
; 0000 009C UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 009D 
; 0000 009E // Analog Comparator initialization
; 0000 009F // Analog Comparator: Off
; 0000 00A0 // The Analog Comparator's positive input is
; 0000 00A1 // connected to the AIN0 pin
; 0000 00A2 // The Analog Comparator's negative input is
; 0000 00A3 // connected to the AIN1 pin
; 0000 00A4 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A5 
; 0000 00A6 // ADC initialization
; 0000 00A7 // ADC Clock frequency: 1000.000 kHz
; 0000 00A8 // ADC Voltage Reference: AREF pin
; 0000 00A9 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00AA ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00AB SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AC 
; 0000 00AD // SPI initialization
; 0000 00AE // SPI disabled
; 0000 00AF SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B0 
; 0000 00B1 // TWI initialization
; 0000 00B2 // TWI disabled
; 0000 00B3 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00B4 
; 0000 00B5 // Global enable interrupts
; 0000 00B6 #asm("sei")
	sei
; 0000 00B7 BUZZER_ON;
	SBI  0x12,5
; 0000 00B8 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00B9 BUZZER_OFF;
	CBI  0x12,5
; 0000 00BA     while (1)
_0xA:
; 0000 00BB     {
; 0000 00BC     // Place your code here
; 0000 00BD         Uint_data_led1 = ADE7753_READ(1,VRMS);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	STS  _Uint_data_led1,R30
	STS  _Uint_data_led1+1,R31
; 0000 00BE         Uint_data_led2 = ADE7753_READ(1,IRMS);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	STS  _Uint_data_led2,R30
	STS  _Uint_data_led2+1,R31
; 0000 00BF     }
	RJMP _0xA
; 0000 00C0 }
_0xD:
	RJMP _0xD
; .FEND
;#include "ADE7753.h"
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
;#include "delay.h"
;
;
;void    SPI_7753_SEND(unsigned char data)
; 0001 0006 {

	.CSEG
_SPI_7753_SEND:
; .FSTART _SPI_7753_SEND
; 0001 0007     unsigned char   cnt;
; 0001 0008     unsigned char   tmp = data;
; 0001 0009 
; 0001 000A     for(cnt = 0;cnt < 8; cnt++)
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
; 0001 000B     {
; 0001 000C         if((tmp & 0x80) == 0x80)   SPI_MOSI_HIGHT;
	MOV  R30,R16
	ANDI R30,LOW(0x80)
; 0001 000D         else SPI_MOSI_LOW;
_0x20062:
	SBI  0x15,2
; 0001 000E 
; 0001 000F         SPI_SCK_HIGHT;
	RCALL SUBOPT_0x1
; 0001 0010         delay_us(50);
; 0001 0011         SPI_SCK_LOW;
; 0001 0012         delay_us(50);
	RCALL SUBOPT_0x2
; 0001 0013         tmp <<= 1;
; 0001 0014     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0015 }
	RCALL __LOADLOCR2
	RJMP _0x2000001
; .FEND
;
;unsigned char    SPI_7753_RECEIVE(void)
; 0001 0018 {
_SPI_7753_RECEIVE:
; .FSTART _SPI_7753_RECEIVE
; 0001 0019     unsigned char cnt;
; 0001 001A     unsigned char data;
; 0001 001B     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0001 001C     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x20011:
	CPI  R17,8
	BRSH _0x20012
; 0001 001D     {
; 0001 001E         SPI_SCK_HIGHT;
	RCALL SUBOPT_0x1
; 0001 001F         delay_us(50);
; 0001 0020         SPI_SCK_LOW;
; 0001 0021         if(SPI_MISO_HIGHT)   data += 1;
	SBIC 0x13,3
	SUBI R16,-LOW(1)
; 0001 0022         delay_us(50);
	RCALL SUBOPT_0x2
; 0001 0023         data <<= 1;
; 0001 0024 
; 0001 0025     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0026     return data;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 0027 }
; .FEND
;
;void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0001 002A {
; 0001 002B     unsigned char data[4];
; 0001 002C     unsigned char   i;
; 0001 002D     data[0] = data_1;
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
; 0001 002E     data[1] = data_2;
; 0001 002F     data[2] = data_3;
; 0001 0030 
; 0001 0031     switch (IC_CS)
; 0001 0032     {
; 0001 0033         case 1:
; 0001 0034         {
; 0001 0035             PHASE_1_ON;
; 0001 0036             PHASE_2_OFF;
; 0001 0037             PHASE_3_OFF;
; 0001 0038             break;
; 0001 0039         }
; 0001 003A         case 2:
; 0001 003B         {
; 0001 003C             PHASE_1_OFF;
; 0001 003D             PHASE_2_ON;
; 0001 003E             PHASE_3_OFF;
; 0001 003F             break;
; 0001 0040         }
; 0001 0041         case 3:
; 0001 0042         {
; 0001 0043             PHASE_1_OFF;
; 0001 0044             PHASE_2_OFF;
; 0001 0045             PHASE_3_ON;
; 0001 0046             break;
; 0001 0047         }
; 0001 0048     }
; 0001 0049     addr &= 0x3F;
; 0001 004A     addr |= 0x80;
; 0001 004B     delay_us(100);
; 0001 004C     SPI_7753_SEND(addr);
; 0001 004D     delay_us(100);
; 0001 004E     for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
; 0001 004F delay_us(100);
; 0001 0050     PHASE_1_OFF;
; 0001 0051     PHASE_2_OFF;
; 0001 0052     PHASE_3_OFF;
; 0001 0053 }
;unsigned int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0001 0055 {
_ADE7753_READ:
; .FSTART _ADE7753_READ
; 0001 0056     unsigned char   i;
; 0001 0057     unsigned char   data[4];
; 0001 0058     unsigned long int res;
; 0001 0059     for(i=0;i<4;i++)    data[i] = 0;
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
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2003A
_0x2003B:
; 0001 005A switch (IC_CS)
	LDD  R30,Y+11
	RCALL SUBOPT_0x5
; 0001 005B     {
; 0001 005C         case 1:
	BRNE _0x2003F
; 0001 005D         {
; 0001 005E             PHASE_1_ON;
	CBI  0x15,5
; 0001 005F             PHASE_2_OFF;
	SBI  0x18,0
; 0001 0060             PHASE_3_OFF;
	SBI  0x18,0
; 0001 0061             break;
	RJMP _0x2003E
; 0001 0062         }
; 0001 0063         case 2:
_0x2003F:
	RCALL SUBOPT_0x6
	BRNE _0x20046
; 0001 0064         {
; 0001 0065             PHASE_1_OFF;
	SBI  0x15,5
; 0001 0066             PHASE_2_ON;
	CBI  0x18,0
; 0001 0067             PHASE_3_OFF;
	SBI  0x18,0
; 0001 0068             break;
	RJMP _0x2003E
; 0001 0069         }
; 0001 006A         case 3:
_0x20046:
	RCALL SUBOPT_0x7
	BRNE _0x2003E
; 0001 006B         {
; 0001 006C             PHASE_1_OFF;
	SBI  0x15,5
; 0001 006D             PHASE_2_OFF;
	SBI  0x18,0
; 0001 006E             PHASE_3_ON;
	CBI  0x18,0
; 0001 006F             break;
; 0001 0070         }
; 0001 0071     }
_0x2003E:
; 0001 0072     delay_us(100);
	RCALL SUBOPT_0x8
; 0001 0073     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0001 0074     SPI_7753_SEND(addr);
	LDD  R26,Y+10
	RCALL _SPI_7753_SEND
; 0001 0075     delay_us(100);
	RCALL SUBOPT_0x8
; 0001 0076     for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
	LDI  R17,LOW(0)
_0x20055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20056
	RCALL SUBOPT_0x3
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
; 0001 0077 delay_us(100);
	RCALL SUBOPT_0x8
; 0001 0078     PHASE_1_OFF;
	SBI  0x15,5
; 0001 0079     PHASE_2_OFF;
	SBI  0x18,0
; 0001 007A     PHASE_3_OFF;
	SBI  0x18,0
; 0001 007B     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0001 007C     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x2005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x2005F
; 0001 007D     {
; 0001 007E         res <<= 8;
	RCALL SUBOPT_0x9
	LDI  R30,LOW(8)
	RCALL __LSLD12
	RCALL SUBOPT_0xA
; 0001 007F         res += data[i];
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	LD   R30,X
	LDI  R31,0
	RCALL SUBOPT_0x9
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0xA
; 0001 0080     }
	SUBI R17,-1
	RJMP _0x2005E
_0x2005F:
; 0001 0081     if(addr == 0x16)    return (res/3600);
	LDD  R26,Y+10
	CPI  R26,LOW(0x16)
	BRNE _0x20060
	RCALL SUBOPT_0x9
	__GETD1N 0xE10
	RCALL __DIVD21U
	RJMP _0x2000002
; 0001 0082     if(addr == 0x17)    return  (res/500);
_0x20060:
	LDD  R26,Y+10
	CPI  R26,LOW(0x17)
	BRNE _0x20061
	RCALL SUBOPT_0x9
	__GETD1N 0x1F4
	RCALL __DIVD21U
	RJMP _0x2000002
; 0001 0083     return data[0]+data[1] + data[2];
_0x20061:
	LDD  R26,Y+5
	CLR  R27
	LDD  R30,Y+6
	LDI  R31,0
	RCALL SUBOPT_0x4
	LDD  R30,Y+7
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
_0x2000002:
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0001 0084 }
; .FEND
;
;void    ADE7753_INIT(void)
; 0001 0087 {
; 0001 0088     ADE7753_WRITE(1,MODE,0x00,0x00,0x00);
; 0001 0089     //ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
; 0001 008A     //ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
; 0001 008B }
;#include "SPI_SOFTWARE.h"
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
;
;
;void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
; 0002 0005 {

	.CSEG
_SPI_SENDBYTE:
; .FSTART _SPI_SENDBYTE
; 0002 0006     unsigned char   i;
; 0002 0007     for(i=0;i<8;i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+2
;	action -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x40004:
	CPI  R17,8
	BRSH _0x40005
; 0002 0008     {
; 0002 0009         if((data & 0x80) == 0x80)    DO_SPI_MOSI = 1;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x40006
	SBI  0x18,3
; 0002 000A         else    DO_SPI_MOSI = 0;
	RJMP _0x40009
_0x40006:
	CBI  0x18,3
; 0002 000B         data <<= 1;
_0x40009:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0002 000C         DO_SPI_SCK = 1;
	SBI  0x18,5
; 0002 000D         DO_SPI_SCK = 0;
	CBI  0x18,5
; 0002 000E     }
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 000F     if(action)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x40010
; 0002 0010     {
; 0002 0011         DO_SPI_LATCH = 1;
	SBI  0x18,1
; 0002 0012         DO_SPI_LATCH = 0;
	CBI  0x18,1
; 0002 0013     }
; 0002 0014 }
_0x40010:
	LDD  R17,Y+0
_0x2000001:
	ADIW R28,3
	RET
; .FEND
;#include "scan_led.h"
;#include "SPI_SOFTWARE.h"
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
;
;unsigned char Uc_led_count = 1;

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
; 0003 0013 {

	.CSEG
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0003 0014     unsigned char   i;
; 0003 0015     unsigned char   data[4];
; 0003 0016     for(i=0;i<4;i++)    data[i] = 0;
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
_0x60005:
	CPI  R17,4
	BRSH _0x60006
	RCALL SUBOPT_0xB
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x60005
_0x60006:
; 0003 0017 data[0] = byte_first;
	LDD  R30,Y+7
	STD  Y+1,R30
; 0003 0018     data[1] = byte_second;
	LDD  R30,Y+6
	STD  Y+2,R30
; 0003 0019     data[2] = byte_third;
	LDD  R30,Y+5
	STD  Y+3,R30
; 0003 001A 
; 0003 001B     for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
	LDI  R17,LOW(0)
_0x60008:
	LDD  R30,Y+8
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x60009
	RCALL SUBOPT_0xB
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
	SUBI R17,-1
	RJMP _0x60008
_0x60009:
; 0003 001C SPI_SENDBYTE(data[i],1);
	RCALL SUBOPT_0xB
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0003 001D }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
;
;void    SELECT_LED(unsigned char num_led,unsigned char    data)
; 0003 0020 {
_SELECT_LED:
; .FSTART _SELECT_LED
; 0003 0021     unsigned char   byte1,byte2,byte3;
; 0003 0022     byte1 = 0;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	num_led -> Y+5
;	data -> Y+4
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
	LDI  R17,LOW(0)
; 0003 0023     byte2 = 0;
	LDI  R16,LOW(0)
; 0003 0024     byte3 = 0;
	LDI  R19,LOW(0)
; 0003 0025     switch(num_led)
	LDD  R30,Y+5
	RCALL SUBOPT_0x5
; 0003 0026     {
; 0003 0027         case    1:
	BRNE _0x6000D
; 0003 0028         {
; 0003 0029             byte3 = 0x01;
	LDI  R19,LOW(1)
; 0003 002A             byte2 = 0x01;
	LDI  R16,LOW(1)
; 0003 002B             break;
	RJMP _0x6000C
; 0003 002C         }
; 0003 002D         case    2:
_0x6000D:
	RCALL SUBOPT_0x6
	BRNE _0x6000E
; 0003 002E         {
; 0003 002F             byte3 = 0x02;
	LDI  R19,LOW(2)
; 0003 0030             byte2 = 0x02;
	LDI  R16,LOW(2)
; 0003 0031             //byte1 = 0x04;
; 0003 0032             break;
	RJMP _0x6000C
; 0003 0033         }
; 0003 0034         case    3:
_0x6000E:
	RCALL SUBOPT_0x7
	BRNE _0x6000F
; 0003 0035         {
; 0003 0036             byte3 = 0x04;
	LDI  R19,LOW(4)
; 0003 0037             byte2 = 0x04;
	LDI  R16,LOW(4)
; 0003 0038             byte1 = 0x40;
	LDI  R17,LOW(64)
; 0003 0039             break;
	RJMP _0x6000C
; 0003 003A         }
; 0003 003B         case    4:
_0x6000F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60010
; 0003 003C         {
; 0003 003D             byte3 = 0x08;
	LDI  R19,LOW(8)
; 0003 003E             byte2 = 0x08;
	LDI  R16,LOW(8)
; 0003 003F             break;
	RJMP _0x6000C
; 0003 0040         }
; 0003 0041         case    5:
_0x60010:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60011
; 0003 0042         {
; 0003 0043             byte3 = 0x40;
	LDI  R19,LOW(64)
; 0003 0044             byte2 = 0x80;
	RJMP _0x6003E
; 0003 0045             break;
; 0003 0046         }
; 0003 0047         case    6:
_0x60011:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60012
; 0003 0048         {
; 0003 0049             byte3 = 0x20;
	LDI  R19,LOW(32)
; 0003 004A             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0003 004B             byte1 = 0x40;
	LDI  R17,LOW(64)
; 0003 004C             break;
	RJMP _0x6000C
; 0003 004D         }
; 0003 004E         case    7:
_0x60012:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60013
; 0003 004F         {
; 0003 0050             byte3 = 0x10;
	LDI  R19,LOW(16)
; 0003 0051             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0003 0052             break;
	RJMP _0x6000C
; 0003 0053         }
; 0003 0054         case    8:
_0x60013:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60014
; 0003 0055         {
; 0003 0056             byte3 = 0x80;
	LDI  R19,LOW(128)
; 0003 0057             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0003 0058             break;
	RJMP _0x6000C
; 0003 0059         }
; 0003 005A         case    9:
_0x60014:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x60015
; 0003 005B         {
; 0003 005C             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0003 005D             byte2 = 0x40;
	LDI  R16,LOW(64)
; 0003 005E             break;
	RJMP _0x6000C
; 0003 005F         }
; 0003 0060         case    10:
_0x60015:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x60016
; 0003 0061         {
; 0003 0062             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0003 0063             byte2 = 0x20;
	LDI  R16,LOW(32)
; 0003 0064             byte1 = 0x04;
	LDI  R17,LOW(4)
; 0003 0065             break;
	RJMP _0x6000C
; 0003 0066         }
; 0003 0067         case    11:
_0x60016:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x60017
; 0003 0068         {
; 0003 0069             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0003 006A             byte2 = 0x10;
	LDI  R16,LOW(16)
; 0003 006B             break;
	RJMP _0x6000C
; 0003 006C         }
; 0003 006D         case    12:
_0x60017:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x6000C
; 0003 006E         {
; 0003 006F             byte3 = 0x00;
	LDI  R19,LOW(0)
; 0003 0070             byte2 = 0x80;
_0x6003E:
	LDI  R16,LOW(128)
; 0003 0071             break;
; 0003 0072         }
; 0003 0073     }
_0x6000C:
; 0003 0074     switch(data)
	LDD  R30,Y+4
	LDI  R31,0
; 0003 0075     {
; 0003 0076         case    0:
	SBIW R30,0
	BRNE _0x6001C
; 0003 0077         {
; 0003 0078             byte1 |= 0xB7;
	ORI  R17,LOW(183)
; 0003 0079             break;
	RJMP _0x6001B
; 0003 007A         }
; 0003 007B         case    1:
_0x6001C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6001D
; 0003 007C         {
; 0003 007D             byte1 |= 0x81;
	ORI  R17,LOW(129)
; 0003 007E             break;
	RJMP _0x6001B
; 0003 007F         }
; 0003 0080         case    2:
_0x6001D:
	RCALL SUBOPT_0x6
	BRNE _0x6001E
; 0003 0081         {
; 0003 0082             byte1 |= 0x3D;
	ORI  R17,LOW(61)
; 0003 0083             break;
	RJMP _0x6001B
; 0003 0084         }
; 0003 0085         case    3:
_0x6001E:
	RCALL SUBOPT_0x7
	BRNE _0x6001F
; 0003 0086         {
; 0003 0087             byte1 |= 0xAD;
	ORI  R17,LOW(173)
; 0003 0088             break;
	RJMP _0x6001B
; 0003 0089         }
; 0003 008A         case    4:
_0x6001F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60020
; 0003 008B         {
; 0003 008C             byte1 |= 0x8B;
	ORI  R17,LOW(139)
; 0003 008D             break;
	RJMP _0x6001B
; 0003 008E         }
; 0003 008F         case    5:
_0x60020:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60021
; 0003 0090         {
; 0003 0091             byte1 |= 0xAE;
	ORI  R17,LOW(174)
; 0003 0092             break;
	RJMP _0x6001B
; 0003 0093         }
; 0003 0094         case    6:
_0x60021:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60022
; 0003 0095         {
; 0003 0096             byte1 |= 0xBE;
	ORI  R17,LOW(190)
; 0003 0097             break;
	RJMP _0x6001B
; 0003 0098         }
; 0003 0099         case    7:
_0x60022:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60023
; 0003 009A         {
; 0003 009B             byte1 = 0x85;
	LDI  R17,LOW(133)
; 0003 009C             break;
	RJMP _0x6001B
; 0003 009D         }
; 0003 009E         case    8:
_0x60023:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60024
; 0003 009F         {
; 0003 00A0             byte1 |= 0xBF;
	ORI  R17,LOW(191)
; 0003 00A1             break;
	RJMP _0x6001B
; 0003 00A2         }
; 0003 00A3         case    9:
_0x60024:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x6001B
; 0003 00A4         {
; 0003 00A5             byte1 |= 0xAF;
	ORI  R17,LOW(175)
; 0003 00A6             break;
; 0003 00A7         }
; 0003 00A8     }
_0x6001B:
; 0003 00A9     SEND_DATA_LED(2,byte1,byte2,byte3);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _SEND_DATA_LED
; 0003 00AA }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void SCAN_LED(void)
; 0003 00AD {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0003 00AE     if(Uc_led_count == 1)   Uc_led_data = Uint_data_led1/1000;
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1)
	BRNE _0x60026
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	RJMP _0x6003F
; 0003 00AF     else if(Uc_led_count == 2)   Uc_led_data = (Uint_data_led1/100)%10;
_0x60026:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2)
	BRNE _0x60028
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RJMP _0x60040
; 0003 00B0     else if(Uc_led_count == 3)   Uc_led_data = (Uint_data_led1/10)%10;
_0x60028:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x3)
	BRNE _0x6002A
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x10
	RJMP _0x60040
; 0003 00B1     else if(Uc_led_count == 4)   Uc_led_data = (Uint_data_led1%10);
_0x6002A:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x4)
	BRNE _0x6002C
	RCALL SUBOPT_0xD
	RJMP _0x60040
; 0003 00B2     else if(Uc_led_count == 5)   Uc_led_data = Uint_data_led2/1000;
_0x6002C:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x5)
	BRNE _0x6002E
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xE
	RJMP _0x6003F
; 0003 00B3     else if(Uc_led_count == 6)   Uc_led_data = (Uint_data_led2/100)%10;
_0x6002E:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x6)
	BRNE _0x60030
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xF
	RJMP _0x60040
; 0003 00B4     else if(Uc_led_count == 7)   Uc_led_data = (Uint_data_led2/10)%10;
_0x60030:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x7)
	BRNE _0x60032
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x10
	RJMP _0x60040
; 0003 00B5     else if(Uc_led_count == 8)   Uc_led_data = (Uint_data_led2%10);
_0x60032:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x8)
	BRNE _0x60034
	RCALL SUBOPT_0x11
	RJMP _0x60040
; 0003 00B6     else if(Uc_led_count == 9)   Uc_led_data = Uint_data_led3/1000;
_0x60034:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x9)
	BRNE _0x60036
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xE
	RJMP _0x6003F
; 0003 00B7     else if(Uc_led_count == 10)   Uc_led_data = (Uint_data_led3/100)%10;
_0x60036:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xA)
	BRNE _0x60038
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xF
	RJMP _0x60040
; 0003 00B8     else if(Uc_led_count == 11)   Uc_led_data = (Uint_data_led3/10)%10;
_0x60038:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xB)
	BRNE _0x6003A
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x10
	RJMP _0x60040
; 0003 00B9     else if(Uc_led_count == 12)   Uc_led_data = (Uint_data_led3%10);
_0x6003A:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xC)
	BRNE _0x6003C
	RCALL SUBOPT_0x12
_0x60040:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0x6003F:
	STS  _Uc_led_data,R30
; 0003 00BA     SELECT_LED(Uc_led_count,Uc_led_data);
_0x6003C:
	LDS  R30,_Uc_led_count
	ST   -Y,R30
	LDS  R26,_Uc_led_data
	RCALL _SELECT_LED
; 0003 00BB     Uc_led_count++;
	LDS  R30,_Uc_led_count
	SUBI R30,-LOW(1)
	STS  _Uc_led_count,R30
; 0003 00BC     if(Uc_led_count > NUM_LED_SCAN*4)    Uc_led_count = 1;
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x9)
	BRLO _0x6003D
	LDI  R30,LOW(1)
	STS  _Uc_led_count,R30
; 0003 00BD }
_0x6003D:
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(131)
	OUT  0x2D,R30
	LDI  R30,LOW(0)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	SBI  0x15,4
	__DELAY_USB 133
	CBI  0x15,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__DELAY_USB 133
	LSL  R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LDS  R26,_Uc_led_count
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
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
