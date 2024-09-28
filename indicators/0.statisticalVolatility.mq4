//+------------------------------------------------------------------+
//|                                      statistical_volatility.mq4 |
//|                                                        XergioAleX |
//|                                        https://www.xergioalex.com |
//+------------------------------------------------------------------+
#property copyright "XergioAleX"
#property link      "https://www.xergioalex.com"
#property version   "1.00"
#property description "This indicator will calculate the statistical volatility"
#property description "and this was designed by XergioAleX."
#property icon   "\\Icons\\indicator-icon.ico"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2

//--- plot buffer_vol
#property indicator_label1  "buffer_vol"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot buffer_media
#property indicator_label2  "buffer_media"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2


//-- includes
#include <MovingAverages.mqh>

//-- enumeración
enum tipo
  {
   Simple,
   Exponencial
  };


//--- input parameters
input int      periodo_vol = 20;                //Periodo para el cálculo de la volatilidad:
input int      periodo_media = 40;              //Periodo para el cálculo de la media:
input tipo     tipo_media;                      //Tipo de media a utilizar:
input color    color_vol = clrDodgerBlue;       //Color del histograma de volatilidad:
input color    color_media = clrRed;            //Color de la media móvil:

//--- indicator buffers
double         buffer_volBuffer[];
double         buffer_mediaBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Definimos la precisión
   IndicatorDigits(Digits);      //Definimos la precisión para los valores de nuestro indicador

//--- Parámetros de dibujo
   SetIndexStyle(0, DRAW_HISTOGRAM, EMPTY, EMPTY, color_vol);
   SetIndexStyle(1, DRAW_LINE, EMPTY, EMPTY, color_media);
   SetIndexDrawBegin(0, periodo_vol);
   SetIndexDrawBegin(1, periodo_media);

//--- indicator buffers mapping
   SetIndexBuffer(0, buffer_volBuffer);
   SetIndexBuffer(1, buffer_mediaBuffer);

//--- Características de la subventana
   IndicatorShortName("Volatilidad Estadística Quantdemy MQL4 (" + IntegerToString(periodo_vol) + ", " + IntegerToString(periodo_media) + ")");
   SetIndexLabel(0, "Volatilidad");
   SetIndexLabel(1, "Media");

//Comprobación de los parámetros de entrada
   if(periodo_vol <= 1 || periodo_media <= 1)
     {
      if(periodo_vol <= 1)
         Alert("Atención: el valor del periodo para la volatilidad es incorrecto. Debe ser o 2, o mayor.");    //Alertar al usuario del parámetro de volatilidad incorrecto

      if(periodo_media <= 1)
         Alert("Atención: el valor del periodo para la media es incorrecto. Debe ser o 2, o mayor.");          //Alertar al usuario del parámetro de la media incorrecto

      return (INIT_FAILED);            //Si periodo_vol ó periodo_media son iguales o inferiores a 1, la inicialización NO TIENE ÉXITO
     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit;  //Declaramos la variable limit de tipo entero

   limit = rates_total - prev_calculated;    //Utilizamos la diferencia entre rates - prev para calcular el indicador durante la primera ejecución y detectar cada nueva vela.

   for(int i = 0; i < limit; i++)
     {
      //Calcular la volatilidad estadística
      if(i == limit - 1)
         buffer_volBuffer[i] = iStdDev(NULL, 0, periodo_vol, 0, MODE_SMA, (int)log(Close[i] / Close[i]), i);
      else
         buffer_volBuffer[i] = iStdDev(NULL, 0, periodo_vol, 0, MODE_SMA, (int)log(Close[i] / Close[i + 1]), i);
     }

//Cálculo de la media móvil sobre la volatilidad
   switch(tipo_media)
     {
      case 0:
         SimpleMAOnBuffer(rates_total, prev_calculated, 1, periodo_media, buffer_volBuffer, buffer_mediaBuffer);
         break;
      case 1:
         ExponentialMAOnBuffer(rates_total, prev_calculated, 1, periodo_media, buffer_volBuffer, buffer_mediaBuffer);
         break;
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
