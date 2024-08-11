//+------------------------------------------------------------------+
//|                                               1.CloseTradeOrders |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//#property script_show_inputs
//--- input parameters
//input int Input1 = 0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {
   if (OrdersTotal() != 0) {
      for (int i = OrdersTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            int orderType = OrderType();
            if (orderType == OP_BUYLIMIT || orderType == OP_SELLLIMIT || orderType == OP_BUYSTOP || orderType == OP_SELLSTOP) {
               continue;
            }

            if (orderType == OP_BUY) {
               OrderClose(OrderTicket(), OrderLots(), Bid, 0, clrNONE);
               Print("Closing BUY order with ticket: ", OrderTicket(), " and ", OrderLots(), "lots");
            } else {
               OrderClose(OrderTicket(), OrderLots(), Ask, 0, clrNONE);
               Print("Closing SELL order with ticket: ", OrderTicket(), " and ", OrderLots(), "lots");
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
