//+------------------------------------------------------------------+
//|                                                    variables.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
  datetime today = TimeCurrent();
  Print("Today is: ", today);

  datetime date1 = D'2020.07.01';
  datetime date2 = D'2020.07.06 15:45';
  datetime date3 = D'06.07.2020 15:45';
  datetime date4 = D'2020.07.06 14:16:30';
  Print("Date1 is: ", date1);
  Print("Date2 is: ", date2);
  Print("Date3 is: ", date3);
  Print("Date4 is: ", date4);
}
//+------------------------------------------------------------------+
