# mql4-course
MQL4 Course Notes

## MQL4 (MetaQuotes Language 4)
---

To write script or develop for Meta Trader 4

The following config for metaeditor can improve the colors of the editor using dark mode:

Steps to apply the colors:

1. Open MetaEditor
2. Open Folder Data
3. Open config folder
4. Open metaeditor.ini
5. Put the following code at the end of the file.
```
[Colors]
Color0=2302755
Color1=13882323
Color2=14737632
Color3=16102666
Color4=11119017
Color5=42495
Color6=9541731
Color7=65280
Color8=16775720
Color9=10025880
Color10=65535
Color11=16748574
Color12=64636
Color13=12616447
Color14=16711935
```

6. Restart the metaeditor.


## Connecting code with the market

To connect our code with the market an event should be triggered.
The main trigger for an event are the ticks.

- Tick: The minimum amount of change size in the price of an active.
This change could be in the price of the bit and the ask.

Our program will be execute when a new Tick is received. This could occurs in milliseconds.

The code on MQL4 should be compiled to be executed.

So, our program will not be executed all time. Just will be executed when a new Tick is received.
This means our program could be executed more frequently in some times of the day when there are more movements in the market.


## Control Triggers

![Control Flow](assets/control-flow.png)

There are some special triggers to control when our code could be executed.

OnTick(): Occurs after a change on the price.
OnTimer(): Occurs after a change in the time.
OnStart(): Occurs when the script is started.
OnStop(): Occurs when the script is stopped.


## Variables

MQL4 is a typed language. This means that we need to specify the type of the variable.

Example for integer variable:
```
int myvar = 20;
```

Datetime vars:
```
datetime date1 = D'2020.07.01';
datetime date2 = D'2020.07.06 15:45';
datetime date3 = D'06.07.2020 15:45';
datetime date4 = D'2020.07.06 14:16:30';
Print("Date1 is: ", date1);
Print("Date2 is: ", date2);
Print("Date3 is: ", date3);
Print("Date4 is: ", date4);
```

## Docs

Take a look at more information about mql4 types and variables:
https://docs.mql4.com/basis/types

Take a look at more information about mql4 functions:
https://docs.mql4.com/basis/functions


## Operators

https://docs.mql4.com/basis/operators


## Exercise 1

Check if the number is even or odd.
```
int mynumber = 55;
if (mynumber % 2 == 0) {
  Print("Even number");
} else {
  Print("Odd number");
}
```

## Exercise 2

Get all the numbers that can be divided by 5 between 1 and 50.
```
int index = 1;
while (index <= 50) {
  if(contador % 5 == 0) {
    Print("The number ", index, " can be divided by 5.");s
  }
  index++;
}
```

## Exercise 3

Raise numbers to the square
for(int i = 1; i < 21; i++) {
   Print("The number ", i, " raised to the square is: ", i*i);
}

## Exercise 4 (Switch Case)

```
int code = 10;
switch(code) {
   case 10:
      Print("Botella de agua");
      break;
   case 20:
      Print("Lata de refresco");
      break;
   case 30:
      Print("Chocolate");
      break;
   case 40:
      Print("Gominolas");
      break;
   case 50:
      Print("Galletas");
      break;
   default:
      Print("Este producto no está disponible");
      break;
}
```