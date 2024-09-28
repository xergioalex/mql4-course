//+------------------------------------------------------------------+
//|                                             Modelo_Ejecucion.mqh |
//|                                                        Quantdemy |
//|                                        https://www.quantdemy.com |
//+------------------------------------------------------------------+
#property copyright "Quantdemy"
#property link      "https://www.quantdemy.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    20101
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//--- includes
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Función que devuelve true si hay operaciones abiertas por un EA. |
//+------------------------------------------------------------------+
bool Operaciones_Abiertas(int magic)
  {
   int tipo;                                                //Variable donde guardaremos el tipo de orden
   int error = 0;                                           //Variable que contendrá el conteo de errores si se dan

   if(OrdersTotal() != 0)                                   //Si hay ordenes abiertas o pendientes ( != 0)... ejecutaremos nuestro código
     {
      for(int o = OrdersTotal() - 1; o >= 0; o--)           //Creamos un bucle for para recorrer todas las ordenes abiertas y pendientes que tengamos.
        {
         if(OrderSelect(o, SELECT_BY_POS, MODE_TRADES))     //Si hemos podido seleccionar la orden... seguimos con ella para procesarla
           {
            //Vamos a buscar las ordenes que estén ABIERTAS
            tipo = OrderType();                             //Guardamos el tipo de orden que tenemos seleccionada (con OrderSelect()) en la variable "tipo"

            if((tipo == OP_BUY || tipo == OP_SELL) && magic == OrderMagicNumber())
              {
               return (true);
              }
           }
        }
      return (false);
     }
   else
      return (false);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------------------------+
//| Función que devuelve el tamaño de lotes en función de un factor de apalancamiento. |
//+------------------------------------------------------------------------------------+
double Lotes_Apalancamiento(double leverage)
  {
   double lotes = 0;                                        //Variable donde guardaremos el valor final de lotes a negociar
   double min_lotes = MarketInfo(NULL, MODE_LOTSTEP);       //Definimos el tamaño mínimo para el incremento de lotes

   lotes = AccountEquity() / 100000 * leverage;             //Dividir el equity entre 100k (1 lote estándar) multiplicamos por el factor de apalancamiento deseado
   lotes = MathRound(lotes / min_lotes) * min_lotes;        //Normalizar el valor de lotes según el mínimo incremento

   return (lotes);
  }

//+------------------------------------------------------------------+


//+----------------------------------------------------------------------------------+
//| Función que devuelve la distancia en puntos (entero) entre la entrada y el stop. |
//+----------------------------------------------------------------------------------+
int Distancia_Stop(double precio_entrada, double precio_stop)
  {
   int diferencia = 0;

   switch(Digits)
     {
      case 5:
         diferencia = (int)(NormalizeDouble(MathAbs(precio_entrada - precio_stop), Digits) * 100000);
         //Print("---------------------- DEBUG 5 --------------------------- ", diferencia);
         return (diferencia);
         break;               //En este caso específico, podriamos eliminar el break dado que la instrucción anterior es un return, y el break no se ejecutaría nunca.

      case 3:
         diferencia = (int)(NormalizeDouble(MathAbs(precio_entrada - precio_stop), Digits) * 1000);
         //Print("----------------------DEBUG 3 --------------------------- ", diferencia);
         return (diferencia);
         break;

      case 2:
         diferencia = (int)(NormalizeDouble(MathAbs(precio_entrada - precio_stop), Digits) * 100);
         //Print("----------------------DEBUG 2 --------------------------- ", diferencia);
         return (diferencia);
         break;

      default :
         return (0);
         break;
     }
  }
//+------------------------------------------------------------------+


//+-----------------------------------------------------------------------------------+
//| Función calcula el tamaño de lotes de una posición en seún un risk determinado. |
//+-----------------------------------------------------------------------------------+
double Lotes_Riesgo(double risk, int dist_stop)
  {
   double lotes = 0;                                              //Variable donde guardaremos el tamaño final de lotes a negociar
   double min_lotes = MarketInfo(NULL, MODE_LOTSTEP);             //Definimos el tamaño mínimo para el incremento de lotes
   double valor_tick = MarketInfo(NULL, MODE_TICKVALUE);          //Definimos el valor del tick en la divisa de la cuenta
   
   lotes = (AccountEquity() * risk / 100) / (dist_stop * valor_tick);       //Calculamos el tamañp de posicion en función del Equity y la distancia del Stop
   lotes = MathRound(lotes / min_lotes) * min_lotes;                          //Normalizar el valor de lotes según el mínimo incremento

   return (lotes);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------------+
//| Esta función cierra y cancela todas las ordenes abiertas y pendientes. |
//+------------------------------------------------------------------------+
void Cerrar_Cancelar_Todo()
  {
   int tipo;                                          //Variable donde guardaremos el tipo de orden
   int error = 0;                                     //Variable que contendrá el conteo de errores si se dan

   if(OrdersTotal() != 0)                             //Si hay ordenes abiertas o pendientes ( != 0)... ejecutaremos nuestro código
     {
      for(int o = OrdersTotal() - 1; o >= 0; o--)     //Creamos un bucle for para recorrer todas las ordenes abiertas y pendientes que tengamos.
        {
         if(OrderSelect(o, SELECT_BY_POS, MODE_TRADES))  //Si hemos podido seleccionar la orden... seguimos con ella para procesarla
           {
            //Vamos a buscar las ordenes que estén ABIERTAS
            tipo = OrderType();                       //Guardamos el tipo de orden que tenemos seleccionada (con OrderSelect()) en la variable "tipo"

            if(tipo == OP_BUYLIMIT || tipo == OP_SELLLIMIT || tipo == OP_BUYSTOP || tipo == OP_SELLSTOP)
              {
               //continue;                              //Si la orden es pendiente (BUY/SELL STOP || BUY/SELL LIMIT), continue manda el control a la siguiente iteración del FOR
               if(!OrderDelete(OrderTicket(), clrNONE))
                 {
                  Alert(ErrorDescription(GetLastError()));
                  error++;
                  continue;
                 }
              }

            if(tipo == OP_BUY)      //Si es una compra...
              {
               if(!OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, clrNONE))      //..Cerraremos la compra con una venta
                 {
                  Alert(ErrorDescription(GetLastError()));
                  error += 1;
                 }

               else
                  Print("Vamos a cerrar la orden de COMPRA con ticket ", OrderTicket(), " y de ", OrderLots(), " lotes.");
              }
            if(tipo == OP_SELL)     //...sino, significa que tenemos una venta, y...
              {
               if(!OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, clrNONE))      //...Cerraremos la venta con una compra
                 {
                  Alert(ErrorDescription(GetLastError()));
                  error += 1;
                 }

               else
                  Print("Vamos a cerrar la orden de VENTA con ticket ", OrderTicket(), " y de ", OrderLots(), " lotes.");
              }
           }
        }

      if(error == 0)
         Alert("Todas las ordenes se han podido cerrar y/o cancelar correctamente");
      else
         Alert("Algo no ha ido bien. Ha ocurrido algún error.");
     }
   else
      Alert("No hay ninguna orden que cerrar y/o cancelar.");

  }
//+------------------------------------------------------------------+
