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

## Exercise 5 (Functions)

```
void OnStart() {
 bool pajaro_1_cantando = true;
 bool perro_esta_ladrando = Perro_Ladrando(Pajaro_2_Cantando(pajaro_1_cantando));
 Print("¿El perro está ladrando? La respuesta es: ", perro_esta_ladrando);
}

bool Pajaro_2_Cantando(bool p1_cantando){
   return(!p1_cantando);
}

bool Perro_Ladrando(bool p2_cantando){
   return(!p2_cantando);
}
```


## Arrays

Arrays on MQL4 can contain up to 4 dimensions.

```
int array1[];  // Dynamic
int array2[3];  // Static
int array3[][3];  // 2D Array: 3 static columns, dynamic rows
int array4[][3][4];  // 3D Array
int array5[][3][4][5];  // 4D Array
```

Filling out arrays
```
int array1[5] = {1, 2, 3, 4, 5};  // Dynamic
int array2[3] = {1, 2, 3};  // Static
int array3[][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};  // 2D Array: 3 static columns, dynamic rows
int array4[][3][4] = {{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}}};  // 3D Array
int array5[][3][4][5] = {{{{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}}, {{16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}, {26, 27, 28, 29, 30}}}};  // 4D Array
```


## Types of Programs

Scripts:
- Executed only one time: OnStart()
- They are deleted after execution: OnStop()
- Trading: Operations in the market can be executed
- Can NOT create graphic elements.
- Simultaneous execution: Only one script can be executed at the same time.
- Can't execute other programs

Experts:
- Executed in the chart for indefinitely time after every Tick().
- They are deleted after the chart is closed.
- Trading: Operations in the market can be executed
- Can create graphic elements.
- Simultaneous execution: Only one expert can be executed at the same time.
- Can execute other programs (Scripts or expert Advisors): iCustom()

Indicators:
- Executed in the chart for indefinitely time after every Tick().
- They are deleted after the chart is closed.
- Trading: Operations in the market can NOT be executed
- Can NOT create graphic elements. 
- Simultaneous execution: We can have multiple indicators in the chart.
- Can't execute other programs


Only Scripts and Experts advisors allow to execute trading operations.
Only the Indicators can create graphic elements.
The graphic elements can be created in the chart using buffers.
The simultaneous execution of scripts and experts is not allowed.
The simultaneous execution of indicators is allowed.
Desde un expert Advisor es posible llamar a un script o indicador usando iCustom()
Pero desde un script o indicador NO es posible llamar a otro script, indicador, o un expert advisor.


## Trade Functions

There are many trade orders that can be executed. More info about them here:
https://docs.mql4.com/trading

![Trade Functions](assets/trade-functions.png)


## Creating our first Script

### Script 1: Close all trade orders