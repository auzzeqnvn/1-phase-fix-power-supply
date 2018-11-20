
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

extern unsigned char Uc_led_count;
extern unsigned char   Uc_led_data;
extern unsigned int    Uint_data_led1;
extern unsigned int    Uint_data_led2;
extern unsigned int    Uint_data_led3;

void    SCAN_LED(void);

void    SPI_7753_SEND(unsigned char data);
unsigned char    SPI_7753_RECEIVE(void);
void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3);
unsigned int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data);
void    ADE7753_INIT(void);

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned int    AI10_Voltage_buff[10];
unsigned int    AI10_Currrent_buff[10];
unsigned long   Ulong_tmp;
unsigned char   Uc_Buff_count = 0;
unsigned char   Uc_Loop_count;
bit Bit_sample_full = 0;

interrupt [2] void ext_int0_isr(void)
{

}

interrupt [3] void ext_int1_isr(void)
{

}

interrupt [14] void timer1_ovf_isr(void)
{

(*(unsigned char *) 0x85)=0xA000 >> 8;
(*(unsigned char *) 0x84)=0xA000 & 0xff;

SCAN_LED();
}

unsigned int read_adc(unsigned char adc_input)
{
(*(unsigned char *) 0x7c)=adc_input | ((0<<7       ) | (0<<6       ) | (0<<5       ));

delay_us(10);

(*(unsigned char *) 0x7a)|=(1<<6       );

while (((*(unsigned char *) 0x7a) & (1<<4       ))==0);
(*(unsigned char *) 0x7a)|=(1<<4       );
return (*(unsigned int *) 0x78) ;
}

void main(void)
{

#pragma optsize-
(*(unsigned char *) 0x61)=(1<<7       );
(*(unsigned char *) 0x61)=(0<<7       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );
#pragma optsize+

DDRB=(0<<7       ) | (0<<6       ) | (1<<5       ) | (0<<4       ) | (1<<3       ) | (0<<2       ) | (1<<1       ) | (0<<0       );

PORTB=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

DDRC=(0<<6       ) | (1<<5       ) | (1<<4       ) | (0<<3       ) | (1<<2       ) | (0<<1       ) | (0<<0       );

PORTC=(0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

DDRD=(0<<7       ) | (0<<6       ) | (1<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

PORTD=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

TCCR0A=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<1       ) | (0<<0       );
TCCR0B=(0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

(*(unsigned char *) 0x80)=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<1       ) | (0<<0       );
(*(unsigned char *) 0x81)=(0<<7       ) | (0<<6       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (1<<0       );
(*(unsigned char *) 0x85)=0x83;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;

(*(unsigned char *) 0xb6)=(0<<6       ) | (0<<5       );
(*(unsigned char *) 0xb0)=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<1       ) | (0<<0       );
(*(unsigned char *) 0xb1)=(0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );
(*(unsigned char *) 0xb2)=0x00;
(*(unsigned char *) 0xb3)=0x00;
(*(unsigned char *) 0xb4)=0x00;

(*(unsigned char *) 0x6e)=(0<<2       ) | (0<<1       ) | (0<<0       );

(*(unsigned char *) 0x6f)=(0<<5       ) | (0<<2       ) | (0<<1       ) | (1<<0       );

(*(unsigned char *) 0x70)=(0<<2       ) | (0<<1       ) | (0<<0       );

(*(unsigned char *) 0xc1)=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

ACSR=(1<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

(*(unsigned char *) 0x7f)=(0<<0       ) | (0<<1       );

SPCR=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

(*(unsigned char *) 0xbc)=(0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<2       ) | (0<<0       );

#asm("sei")
Uint_data_led1 = 0;
Uint_data_led2 = 0;
PORTD.5 = 1;
delay_ms(100);
PORTD.5 = 0;
while (1)
{

AI10_Voltage_buff[Uc_Buff_count] = ADE7753_READ(1,0x17,3);
AI10_Currrent_buff[Uc_Buff_count] = ADE7753_READ(1,0x16,3);
Uc_Buff_count++;
if(Uc_Buff_count > 9)
{
Uc_Buff_count = 0;
if(Bit_sample_full == 0)
{
Bit_sample_full = 1;
PORTD.5 = 1;
delay_ms(100);
PORTD.5 = 0;
}
}
if(Bit_sample_full)
{
Ulong_tmp = 0;
for(Uc_Loop_count = 0; Uc_Loop_count<10;Uc_Loop_count++)
{
Ulong_tmp += AI10_Voltage_buff[Uc_Loop_count];
}
Ulong_tmp /= 10;
Uint_data_led1 = (unsigned int) Ulong_tmp;
Ulong_tmp = 0;
for(Uc_Loop_count = 0; Uc_Loop_count<10;Uc_Loop_count++)
{
Ulong_tmp += AI10_Currrent_buff[Uc_Loop_count];
}
Ulong_tmp /= 10;
Uint_data_led2 = (unsigned int) Ulong_tmp;
}
delay_ms(500);
}
}