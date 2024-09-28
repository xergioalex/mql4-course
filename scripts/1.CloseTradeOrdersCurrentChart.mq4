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
   // Check if there are any open orders
   if (OrdersTotal() != 0) {
      // Loop through all open orders in reverse order
      for (int i = OrdersTotal() - 1; i >= 0; i--) {
         // Select the order by its position in the list of open orders
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            // Get the type of the selected order
            int orderType = OrderType();
            // Skip pending orders (buy limit, sell limit, buy stop, sell stop)
            if (orderType == OP_BUYLIMIT || orderType == OP_SELLLIMIT || orderType == OP_BUYSTOP || orderType == OP_SELLSTOP) {
               continue;
            }

            // Close market orders (buy or sell)
            if (orderType == OP_BUY) {
               // Close buy order at the current Bid price
               OrderClose(OrderTicket(), OrderLots(), Bid, 0, clrNONE);
               Print("Closing BUY order with ticket: ", OrderTicket(), " and ", OrderLots(), "lots");
            } else {
               // Close sell order at the current Ask price
               OrderClose(OrderTicket(), OrderLots(), Ask, 0, clrNONE);
               Print("Closing SELL order with ticket: ", OrderTicket(), " and ", OrderLots(), "lots");
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
