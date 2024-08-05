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