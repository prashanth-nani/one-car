#include <mega32.h>
#include <delay.h>
#include <stdlib.h>
// Alphanumeric LCD Module functions
#include <alcd.h>

// External Interrupt 2 service routine
int s,a[16][2],y,i,j,z,counter,score,speed=150;
char c[10];
void main(void);
void init()
{
    for(i=1;i<16;i++)
    for(j=0;j<=1;j++)
        a[i][j]=0;
    s=y=i=j=z=counter=score=0;
    speed=150;
}
void player(void)
{
      lcd_gotoxy(0,s);
      lcd_putchar('X');
      lcd_gotoxy(0,1-s);
      lcd_putchar(' ');
}
interrupt [EXT_INT2] void ext_int2_isr(void)
{
// Place your code here
  s++;
  delay_ms(100);
  if(s==2)
    s=0;
}
void finish()
{
    lcd_clear();
    lcd_puts("Game Over!!!");
    lcd_gotoxy(0,1);
    itoa(score,c);
    lcd_puts("Your score is ");
    lcd_puts(c);
    while(1)
    {
        if(PINB.0==1)
            { 
                delay_ms(1000);
                init();
                main();
            } 
    }
}
// Declare your global variables here
void obstacle(void)
{
   if(a[1][s]==1)
   {
        finish();
   }
   if(a[1][1-s]==2)
   {
        finish();
   } 
   if((a[1][0]==2) || (a[1][1]==2)){
    score++; 
    if(score>1)
          if(score%2==0)
                speed--;
   }
    z++;   
    z=(z+rand()%2)%2;
    y=(rand()+z)%4;
    if(y==1)
    {
        a[15][z]=1;
        a[15][1-z]=0;
    }
    if(y==0)
    {
        a[15][z]=0;    
        a[15][1-z]=1;
    } 
    if(y==3)
    {
        a[15][z]=0;    
        a[15][1-z]=2;
    } 
    if(y==2)
    {
        a[15][z]=2;    
        a[15][1-z]=0;
    } 
           
    for(i=1;i<15;i++)
    {
         a[i][0]=a[i+1][0];
         a[i][1]=a[i+1][1];
    } 
}
void print(void)
{
    for(i=15;i>=1;i--){
        for(j=0;j<2;j++){
            lcd_gotoxy(i,j);
            if(a[i][j]==1){
                lcd_putchar('0'); 
            }
            else if(a[i][j]==2)
                lcd_putchar('1');
                
            else
                lcd_putchar(' ');
        }
    }
}
void main(void)
{
PORTA=0x00;
DDRA=0x00;
PORTB=0x00;
DDRB=0x00;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
GICR|=0x20;
MCUCR=0x00;
MCUCSR=0x40;
GIFR=0x20;
TIMSK=0x00;
UCSRB=0x00;
ACSR=0x80;
SFIOR=0x00;
ADCSRA=0x00;
TWCR=0x00;
lcd_init(16);
#asm("sei")
lcd_puts("Press to start");
while(1)
{
    if(PINB.0==1)
    {
        delay_ms(50);
        while (1)
        {
            counter++;
            print();
            player();
            if(counter%speed==0)
                  {
                     obstacle();
                     counter=0;
                  }
        }
    }
}
}
