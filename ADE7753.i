
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

void    SPI_7753_SEND(unsigned char data);
unsigned char    SPI_7753_RECEIVE(void);
void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3);
unsigned int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data);
void    ADE7753_INIT(void);

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

extern unsigned char Uc_led_count;
extern unsigned char   Uc_led_data;
extern unsigned int    Uint_data_led1;
extern unsigned int    Uint_data_led2;
extern unsigned int    Uint_data_led3;

void    SCAN_LED(void);

void    SPI_7753_SEND(unsigned char data)
{
unsigned char   cnt;
unsigned char   tmp = data;

for(cnt = 0;cnt < 8; cnt++)
{
if((tmp & 0x80) == 0x80)   PORTC.2 = 1;
else PORTC.2 = 0;

PORTC.4 = 1;
delay_us(50);
PORTC.4 = 0;
delay_us(50);
tmp <<= 1;
}
}

unsigned char    SPI_7753_RECEIVE(void)
{
unsigned char cnt;
unsigned char data;
data = 0;
for(cnt = 0;cnt < 8; cnt++)
{
PORTC.4 = 1;
delay_us(50);
if(PINC.3 == 1)   
{
data += 1;
}
data <<= 1;   
PORTC.4 = 0; 
delay_us(50); 
}
return data;
}

void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3)
{
unsigned char data[4];
unsigned char   i;
data[0] = data_1;
data[1] = data_2;
data[2] = data_3;

switch (IC_CS)
{
case 1:
{
PORTC.5 = 0;
PORTB.0 = 1;
PORTB.0 = 1;
break;
}
case 2:
{
PORTC.5 = 1;
PORTB.0 = 0;
PORTB.0 = 1;
break;
}
case 3:
{
PORTC.5 = 1;
PORTB.0 = 1;
PORTB.0 = 0;
break;
}
}
addr &= 0x3F;
addr |= 0x80;
delay_us(100);
SPI_7753_SEND(addr);
delay_us(100);
for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
delay_us(100);
PORTC.5 = 1;
PORTB.0 = 1;
PORTB.0 = 1;
}
unsigned int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
{
unsigned char   i;
unsigned char   data[4];
unsigned long int res;
for(i=0;i<4;i++)    data[i] = 0;
switch (IC_CS)
{
case 1:
{
PORTC.5 = 0;
PORTB.0 = 1;
PORTB.0 = 1;
break;
}
case 2:
{
PORTC.5 = 1;
PORTB.0 = 0;
PORTB.0 = 1;
break;
}
case 3:
{
PORTC.5 = 1;
PORTB.0 = 1;
PORTB.0 = 0;
break;
}
}
delay_us(100);
addr &= 0x3F;
SPI_7753_SEND(addr);
delay_us(100);
for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
delay_us(100);
PORTC.5 = 1;
PORTB.0 = 1;
PORTB.0 = 1;
res = 0;
for(i=0;i<num_data;i++)
{
res <<= 8;
res += data[i];
}
if(addr == 0x16)    return  (res/448);
if(addr == 0x17)    return  (res/2060);
return (data[2] + data[1] + data[0]);
}

void    ADE7753_INIT(void)
{
ADE7753_WRITE(1,0x09,2,0x00,0x00,0x00);
ADE7753_WRITE(1,0x1F,1,0X2a,0X00,0X00);
ADE7753_WRITE(1,0x1E,1,0XFF,0X00,0X00);
}
