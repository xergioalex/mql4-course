//+------------------------------------------------------------------+
//|                                                CustomStragety.mq4 |
//|                                                        XergioAleX |
//|                                        https://www.xergioalex.com |
//+------------------------------------------------------------------+
#property copyright "XergioAleX"
#property link      "https://www.xergioalex.com"
#property version   "1.00"
#property description "This is an expert advisor that protect our account"
#property description "based on the open positions."
#property description "Alert: Use only based on our own risk"
#property icon   "\\Icons\\indicator-icon.ico"
#property strict


//--- includes
#include <xergioalex/custom_execution_model.mqh>
#include <stdlib.mqh>//

enum pos
  {
   Porcentaje_Riesgo,
   Apalancamiento,
   Lotes_Fijos
  };

enum tip_media
  {
   Simple,
   Exponencial
  };

//--- Menu de entrada ---
input string      s0 = "---------- MagicNumber de la Estrategia ----------";        //---------- MagicNumber de la Estrategia ----------
input int         magicnumber = 1010101010;                                         //MagicNumber de la estrategia (10 dígitos):

input string      s1 = "---------- Parámetros de los indicadores ----------";       //---------- Parámetros de los indicadores ----------
input int         periodo_rsi = 14;                                                 //Periodo para el RSI:
input int         periodo_vol = 20;                                                 //Periodo para la Volatilidad:
input int         periodo_media = 40;                                               //Periodo para la Media:
input tip_media   tipo_media;                                                       //Tipo de Media:

input string      s2 = "---------- Gestión de posiciones ----------";               //---------- Gestión de posiciones ----------
input pos         calc_pos;                                                         //Método para el cálculo de las posiciones:
input double      riesgo = 1.0;                                                     //Riesgo por operación en %:
input double      apalancamiento = 2.0;                                             //Factor de apalancamiento por operación:
input double      fijo = 0.01;                                                      //Número de lotes fijos por operación:
input int         mult_vol_sl = 100;                                                //Multiplicador de Volatilidad para SL:
input double      mult_tp = 3;                                                      //Factor Riesgo/Beneficio para TP:

input string      s3 = "---------- Seguridad ----------";                           //---------- Seguridad ----------
input double      stop_out = 1000;                                                  //Stop Global (Equity mínima de la cuenta):
input double      max_lotes = 1.00;                                                 //Tamaño máximo de una posición:
input int         max_slippage = 1000;                                              //Slippage máximo:
input int         segundos_ejecucion = 5;                                           //Segundos para la comprobación del Stop-Out (min 1):
extern bool       trading_permitido = true;                                         //Trading permitido (true por defecto):
input int         num_max_iteraciones = 5;                                          //Número máximo de iteraciones para ejecutar la orden:



//---- Variables Globales
datetime ultima_vela;            //Aqui guardaremos el valor de tiempo para ejecutar código en cada inicio de vela
double   volatilidad;            //Variable para guardar el valor del indicador de la volatilidad
double   media_volatilidad;      //Variable para guardar el valor de la media de la volatilidad
double   rsi_actual;             //Variable para guardar el último valor del RSI
double   rsi_anterior;           //Variable para guardar el valor 2 veces anterior del RSI



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(segundos_ejecucion);

   ultima_vela = 0;           //Inicializamos variable ultima_vela a 0

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(trading_permitido)
     {
      if(ultima_vela != Time[0])
        {
         if(!Operaciones_Abiertas(magicnumber)) //Aquí evaluaremos si tenemos alguna posición abierta
           {
            //--- DETECCIÓN DE LA SEÑAL PRINCIPAL    ---> Condiciones dadas por el RSI && Volatilidad

            //--- 1r lugar: Entrada siempre debe ser cuando la volatilidad > su media
            volatilidad = iCustom(NULL, 0, "xergioalex\\statistical_volatility.ex4", periodo_vol, periodo_media, tipo_media, clrDodgerBlue, clrRed, 0, 1);
            media_volatilidad = iCustom(NULL, 0, "xergioalex\\statistical_volatility.ex4", periodo_vol, periodo_media, tipo_media, clrDodgerBlue, clrRed, 1, 1);

            if(volatilidad > media_volatilidad)
              {
               //--- 2o lugar: queremos que el RSI haya cruzado al alza 70 para VENTA, y a la baja el 30 para COMPRA
               rsi_actual = iRSI(NULL, 0, periodo_rsi, PRICE_CLOSE, 1);
               rsi_anterior = iRSI(NULL, 0, periodo_rsi, PRICE_CLOSE, 2);

               //--- DETECCIÓN DE SEÑAL DE VENTA
               if(rsi_anterior <= 70 && rsi_actual > 70)
                 {
                  //TENDREMOS SEÑAL DE VENTA
                  Abrir_Operacion(OP_SELL, volatilidad);
                 }

               //--- DETECCIÓN DE SEÑAL DE COMPRA
               if(rsi_anterior >= 30 && rsi_actual < 30)
                 {
                  //TENDREMOS SEÑAL DE COMPRA
                  Abrir_Operacion(OP_BUY, volatilidad);
                 }
              }
           }
         ultima_vela = Time[0];
        }
     }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
//--- Comprobación del Stop Out
   if(AccountEquity() < stop_out)
     {
      Alert("ATENCIÓN: Nivel de Stop Out alcanzado. Cerrando todas las operaciones abiertas y pendientes.");
      Cerrar_Cancelar_Todo();
      trading_permitido = false;
     }
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Función que abre una operación del tipo especificado.            |
//+------------------------------------------------------------------+
void Abrir_Operacion(int tipo_operacion, double vol)
  {

   double precio_stop = 0;          //Variable donde guardaremos el precio del Stop-Loss
   double precio_tp = 0;            //Variable donde guardaremos el precio del Take Profit
   double precio_entrada = 0;

   switch(tipo_operacion)
     {
      case OP_BUY:
         precio_stop = NormalizeDouble(Ask - (mult_vol_sl * vol), Digits);
         precio_tp = NormalizeDouble(Ask + (mult_tp * mult_vol_sl * vol), Digits);
         precio_entrada = NormalizeDouble(Ask, Digits);
         break;

      case OP_SELL:
         precio_stop = NormalizeDouble(Bid + (mult_vol_sl * vol), Digits);
         precio_tp = NormalizeDouble(Bid - (mult_tp * mult_vol_sl * vol), Digits);
         precio_entrada = NormalizeDouble(Bid, Digits);
         break;
     }

//-------------------- Cálculo del tamaño de la posición según lo elegido por el usuario

   double lotes = 0;                              //Variable donde guardaremos el tamaño de lotes a negociar

   switch(calc_pos)
     {
      case 0:
         lotes = Lotes_Riesgo(riesgo, Distancia_Stop(precio_entrada, precio_stop));    //Lotes según % de riesgo
         break;

      case 1:
         lotes = Lotes_Apalancamiento(apalancamiento);    //Lotes seún factor de apalancamiento
         break;

      case 2:
         lotes = fijo;     //Lotes fijos
         break;
     }

   if(lotes < MarketInfo(NULL, MODE_MINLOT))         //Si lotes es inferior al step mínimo
     {
      Alert("El tamaño de lotes es inferior al mínimo permitido. La operación no se ejecutará.");
      return;
     }

   if(lotes > max_lotes)
     {
      lotes = max_lotes;
      Alert("Se ha modificado el tamaño de los lotes a ", lotes, " debido a la restricción de tamaño máximo");
     }

//-------------------- FIN del Cálculo del tamaño de la posición según lo elegido por el usuario


//-------------------- INICIO de envío de órdenes a mercado
   int espera_milisegundos = 10;
   int ticket = 0;
   int contador = 0;

   switch(tipo_operacion)
     {
      //MANDAMOS ORDEN DE COMPRA
      case OP_BUY:
         while(!IsTradeAllowed())                        //Si el servidor está ocupado...
           {
            //Código de espera
            Sleep(espera_milisegundos);                  //Esperamos ciertos milisegundos para ver si el servidor ya está disponible
            contador++;                                  //Añadimos 1 a la variable contador
            if(contador > num_max_iteraciones)           //Comprobamos si contador es mayor a nuestro número máximo de iteraciones 
               return;
            RefreshRates();                              //Actualizamos valores de precio
           }

         //Mandamos la orden
         ticket = OrderSend(NULL, OP_BUY, lotes, Ask, max_slippage, precio_stop, precio_tp, "RSI_Quantdemy", magicnumber, 0, clrNONE);        //Enviamos orden de compra

         if(ticket < 0)                                  //Si ticket es inferior a 0, significa que hemos tenido un error
           {
            Alert(ErrorDescription(GetLastError()));     //Alertamos del error
           }
         break;

      //MANDAMOS ORDEN DE VENTA
      case OP_SELL:
         while(!IsTradeAllowed())                        //Si el servidor está ocupado...
           {
            //Código de espera
            Sleep(espera_milisegundos);                  //Esperamos ciertos milisegundos para ver si el servidor ya está disponible
            contador++;                                  //Añadimos 1 a la variable contador
            if(contador > num_max_iteraciones)           //Comprobamos si contador es mayor a nuestro número máximo de iteraciones
               return;
            RefreshRates();                              //Actualizamos valores de precio
           }

         //Mandamos la orden
         ticket = OrderSend(NULL, OP_SELL, lotes, Bid, max_slippage, precio_stop, precio_tp, "RSI_Quantdemy", magicnumber, 0, clrNONE);        //Enviamos orden de compra

         if(ticket < 0)                                  //Si ticket es inferior a 0, significa que hemos tenido un error
           {
            Alert(ErrorDescription(GetLastError()));     //Alertamos del error
           }
         break;
     }

//-------------------- FIN de envío de órdenes a mercado

  }
//+------------------------------------------------------------------+
