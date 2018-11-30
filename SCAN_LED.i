
extern unsigned char Uc_led_count;
extern unsigned char   Uc_led_data;
extern unsigned int    Uint_data_led1;
extern unsigned int    Uint_data_led2;
extern unsigned int    Uint_data_led3;

void    SCAN_LED(void);

#pragma used+
sfrb PINB=3;
sfrb DDRB=4;
sfrb PORTB=5;
sfrb PINC=6;
sfrb DDRC=7;
sfrb PORTC=8;
sfrb PIND=9;
sfrb DDRD=0xa;
sfrb PORTD=0xb;
sfrb TIFR0=0x15;
sfrb TIFR1=0x16;
sfrb TIFR2=0x17;
sfrb PCIFR=0x1b;
sfrb EIFR=0x1c;
sfrb EIMSK=0x1d;
sfrb GPIOR0=0x1e;
sfrb EECR=0x1f;
sfrb EEDR=0x20;
sfrb EEARL=0x21;
sfrb EEARH=0x22;
sfrw EEAR=0x21;   
sfrb GTCCR=0x23;
sfrb TCCR0A=0x24;
sfrb TCCR0B=0x25;
sfrb TCNT0=0x26;
sfrb OCR0A=0x27;
sfrb OCR0B=0x28;
sfrb GPIOR1=0x2a;
sfrb GPIOR2=0x2b;
sfrb SPCR=0x2c;
sfrb SPSR=0x2d;
sfrb SPDR=0x2e;
sfrb ACSR=0x30;
sfrb SMCR=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb SPMCSR=0x37;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

void    SPI_SENDBYTE(unsigned char  data,unsigned char action);

unsigned char   Uc_led_count = 1;
unsigned char   Uc_led_data = 0;
unsigned int    Uint_data_led1 = 0;
unsigned int    Uint_data_led2 = 0;
unsigned int    Uint_data_led3 = 0;
unsigned char   Uc_Select_led=1;

unsigned char   BCDLED[11]={0xB7,0x81,0x3D,0xAD,0x8B,0xAE,0xBE,0x85,0xBF,0xAF,0};

void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_first,unsigned char  byte_second,unsigned char  byte_third)
{
unsigned char   i;
unsigned char   data[4];
for(i=0;i<4;i++)    data[i] = 0;
data[0] = byte_first;
data[1] = byte_second;
data[2] = byte_third;

for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
SPI_SENDBYTE(data[i],1);
}

void    SCAN_LED(void)
{
unsigned char   byte1,byte2,byte3;
unsigned char    data;
unsigned char   bit_left;
bit_left = 0x01;
byte1 = 0;
byte2 = 0;
byte3 = 0;

Uc_Select_led++;
bit_left <<= (Uc_Select_led-1);
if(Uc_Select_led > 8)   
{
Uc_Select_led = 1;
bit_left = 0x01;
}

data = Uint_data_led1/1000;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x01;
data = Uint_data_led1/100%10;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x02;
data = Uint_data_led1/10%10;
byte1 = BCDLED[data];
byte1 |= 0x40;
if(byte1 & bit_left) byte3 |= 0x04;
data = Uint_data_led1%10;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x08;

data = Uint_data_led2/1000;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x80;
data = Uint_data_led2/100%10;
byte1 = BCDLED[data];
byte1 |= 0x40;
if(byte1 & bit_left) byte3 |= 0x40;
data = Uint_data_led2/10%10;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x20;
data = Uint_data_led2%10;
byte1 = BCDLED[data];
if(byte1 & bit_left) byte3 |= 0x10;

SEND_DATA_LED(2,bit_left,byte3,byte2);
}

void    SELECT_LED(unsigned char num_led,unsigned char    data)
{
unsigned char   byte1,byte2,byte3;
byte1 = 0;
byte2 = 0;
byte3 = 0;
switch(num_led)
{
case    1:
{
byte3 = 0x01;
byte2 = 0x01;
break;
}
case    2:
{
byte3 = 0x02;
byte2 = 0x02;

break;
}
case    3:
{
byte3 = 0x04;
byte2 = 0x04;
byte1 = 0x40;
break;
}
case    4:
{
byte3 = 0x08;
byte2 = 0x08;
break;
}
case    5:
{
byte3 = 0x40;
byte2 = 0x80;
break;
}
case    6:
{
byte3 = 0x20;
byte2 = 0x40;
byte1 = 0x40;
break;
}
case    7:
{
byte3 = 0x10;
byte2 = 0x20;
break;
}
case    8:
{
byte3 = 0x80;
byte2 = 0x10;
break;
}
case    9:
{
byte3 = 0x00;
byte2 = 0x40;
break;
}
case    10:
{
byte3 = 0x00;
byte2 = 0x20;
byte1 = 0x04;
break;
}
case    11:
{
byte3 = 0x00;
byte2 = 0x10;
break;
}
case    12:
{
byte3 = 0x00;
byte2 = 0x80;
break;
}
}
switch(data)
{
case    0:
{
byte1 |= 0xB7;
break;
}
case    1:
{
byte1 |= 0x81;
break;
}
case    2:
{
byte1 |= 0x3D;
break;
}
case    3:
{
byte1 |= 0xAD;
break;
}
case    4:
{
byte1 |= 0x8B;
break;
}
case    5:
{
byte1 |= 0xAE;
break;
}
case    6:
{
byte1 |= 0xBE;
break;
}
case    7:
{
byte1 |= 0x85;
break;
}
case    8:
{
byte1 |= 0xBF;
break;
}
case    9:
{
byte1 |= 0xAF;
break;
}    
}
SEND_DATA_LED(2,byte1,byte2,byte3);
}

