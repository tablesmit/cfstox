<cfcomponent output="true">
<!--- 
Supported indicators:
SMA - Smple moving average 
DX - Directional Movement Index
ADX - Average Directional Movement Index
CCI - Commodity Channel Index
Plus DI - Plus Directional Indicator
Plus DM - Plus Directional Movement


Coming Soon:

 --->
<cffunction  name="init">
	<cfset paths[1] =  "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\model\ta-lib.jar">
	<cfset server.loader = createObject("component", "cfstox.model.JavaLoader").init(paths) />
	<cfset talib  = server.loader.create("com.tictactec.ta.lib.Core") />
	<cfset Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger") />
	<cfset Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger") />
	<cfdump var="#Minteger1#"> 
	<cfdump var="#talib#">
	<cfdump var="#this#">
	<cfset foo = getMetaData(this) />
	<cfdump var="#this#">
	<!--- <cfabort> --->
	<cfreturn this />
</cffunction>

<!--- 
int outBegIdx;
int outNbElement;
double[] inputClose = new double [] { 75.2, 76.5, 75.8, 75.3, 75.0, 74.5 }; //this is just for example. inputClose array will be generated by you in you app.
double[] output = new double[inputClose.Length];
TA.Lib.Core.SMA(0, inputClose.Length - 1, inputClose, count, out outBegIdx, out outNbElement, output);
//output will be SMA values 

 public RetCode sma( int startIdx,
      int endIdx,
      double inReal[],
      int optInTimePeriod,
      MInteger outBegIdx,
      MInteger outNBElement,
      double outReal[] )
   {
      if( startIdx < 0 )
         return RetCode.OutOfRangeStartIndex ;
      if( (endIdx < 0) || (endIdx < startIdx))
         return RetCode.OutOfRangeEndIndex ;
      if( (int)optInTimePeriod == ( Integer.MIN_VALUE ) )
         optInTimePeriod = 30;
      else if( ((int)optInTimePeriod < 2) || ((int)optInTimePeriod > 100000) )
         return RetCode.BadParam ;
      return TA_INT_SMA ( startIdx, endIdx,
         inReal, optInTimePeriod,
         outBegIdx, outNBElement, outReal );
   }
   RetCode TA_INT_SMA( int startIdx,
      int endIdx,
      double inReal[],
      int optInTimePeriod,
      MInteger outBegIdx,
      MInteger outNBElement,
      double outReal[] )
   {
      double periodTotal, tempReal;
      int i, outIdx, trailingIdx, lookbackTotal;
      lookbackTotal = (optInTimePeriod-1);
      if( startIdx < lookbackTotal )
         startIdx = lookbackTotal;
      if( startIdx > endIdx )
      {
         outBegIdx.value = 0 ;
         outNBElement.value = 0 ;
         return RetCode.Success ;
      }
      periodTotal = 0;
      trailingIdx = startIdx-lookbackTotal;
      i=trailingIdx;
      if( optInTimePeriod > 1 )
      {
         while( i < startIdx )
            periodTotal += inReal[i++];
      }
      outIdx = 0;
      do
      {
         periodTotal += inReal[i++];
         tempReal = periodTotal;
         periodTotal -= inReal[trailingIdx++];
         outReal[outIdx++] = tempReal / optInTimePeriod;
      } while( i <= endIdx );
      outNBElement.value = outIdx;
      outBegIdx.value = startIdx;
      return RetCode.Success ;
   }
--->

<cffunction  name="sma" hint="simple moving average - array of prices you want to average ie high, low, close">
	<!--- 
		int outBegIdx;
		int outNbElement;
		double[] inputClose = new double [] { 75.2, 76.5, 75.8, 75.3, 75.0, 74.5 }; //this is just for example. inputClose array will be generated by you in you app.
		double[] output = new double[inputClose.Length];
		TA.Lib.Core.SMA(0, inputClose.Length - 1, inputClose, count, out outBegIdx, out outNbElement, output);
       //output will be SMA values --->
	<!--- works <cfargument name="startIdx" type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="aryPrices" type="Array" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" type="Numeric"  default="10" required="false" />
	<cfargument name="maLen" type="Numeric"  default="2" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="2" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" /> --->
	<cfargument name="startIdx" type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="aryPrices" type="Array" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" type="Numeric"  default="10" required="false" />
	<cfargument name="maLen" type="Numeric"  default="3" required="false"  hint="must be greater than 1"/>
	<cfargument name="optInTimePeriod" type="Numeric"  default="1" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	
	<cfscript>
		
	var local = structNew();
	local.aryOut = ArrayNew(1);
	For (i=1;i LTE arguments.aryPrices.size(); i=i+1)
          local.aryOut[i] = 0;
    /* return local.aryout; */
    arguments.startIdx = javacast("int",arguments.startIdx);
    arguments.endIdx = javacast("int",arguments.endIdx);
    arguments.outBegIdx = javacast("int",arguments.outBegIdx);
    arguments.outNBElement = javacast("int",arguments.outNBElement);
    arguments.maLen = javacast("int",arguments.maLen);
	local.aryOut = javacast("double[]",local.aryout);
	local.aryPrices = javacast("double[]",arguments.aryPrices);
	Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger1.value = 1;
	Minteger2.value = 2;
	/* sma(int, int, double[], int, com.tictactec.ta.lib.MInteger, com.tictactec.ta.lib.MInteger, double[]) */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.SMA(arguments.startIdx,arguments.endIdx,local.aryPrices,arguments.maLen,Minteger1,Minteger2,local.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="DX" hint="Directional ">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	
	<cfscript>
	var local = structNew();
	local.aryOut 	= ArrayNew(1);
	local.aryHigh 	= ArrayNew(1);
	local.aryLow 	= ArrayNew(1);
	local.aryClose 	= ArrayNew(1);
	</cfscript>
	<cfloop query="arguments.qryPrices">
		<cfset local.aryOut[arguments.qryPrices.currentrow]		= 0 />
		<cfset local.aryHigh[arguments.qryPrices.currentrow]	= arguments.qryPrices.high />
		<cfset local.aryLow[arguments.qryPrices.currentrow]		= arguments.qryPrices.low />
		<cfset local.aryClose[arguments.qryPrices.currentrow]	= arguments.qryPrices.close />
	</cfloop>
	<cfscript>
    arguments.startIdx 	= javacast("int",arguments.startIdx);
    arguments.endIdx 	= javacast("int",arguments.endIdx);
    arguments.outBegIdx = javacast("int",arguments.outBegIdx);
    arguments.outNBElement = javacast("int",arguments.outNBElement);
    arguments.optInTimePeriod = javacast("int",arguments.optInTimePeriod);
	local.aryOut	= javacast("double[]",local.aryout);
	local.aryHigh 	= javacast("double[]",local.aryHigh);
	local.aryLow 	= javacast("double[]",local.aryLow);
	local.aryClose 	= javacast("double[]",local.aryClose);
	Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.DX(arguments.startIdx,arguments.endIdx,local.aryHigh, local.aryLow, local.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="ADX">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.ADX(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="CCI">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* cci(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.CCI(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="PLUS_DI">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DI(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="PLUS_DM">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DI(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<!--- <cffunction  name="PLUS_DM">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DI(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction> --->

<cffunction  name="ProcessArrays">
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfscript>
	var local = structNew();
	local.aryOut 	= ArrayNew(1);
	local.aryHigh 	= ArrayNew(1);
	local.aryLow 	= ArrayNew(1);
	local.aryClose 	= ArrayNew(1);
	for (
	 intRow = 1 ;
	 intRow LTE qryPrices.RecordCount ;
	 intRow = (intRow + 1) )
	 {
		local.aryOut[intRow]	= 0;
		local.aryHigh[introw]	= arguments.qryPrices[high][introw]; 
		local.aryLow[introw]	= arguments.qryPrices[low][introw];
		local.aryClose[introw]	= arguments.qryPrices[close][introw];
	}
    local.aryOut	= javacast("double[]",local.aryout);
	local.aryHigh 	= javacast("double[]",local.aryHigh);
	local.aryLow 	= javacast("double[]",local.aryLow);
	local.aryClose 	= javacast("double[]",local.aryClose);
	</cfscript>
	<cfreturn local />
</cffunction>

<cffunction  name="DoJavaCast">
	<cfargument name="argStruct" 	type="Struct" required="true"  hint="the array of prices to base on"/>
	<cfscript>
	arguments.argStruct.startIdx 		= javacast("int",arguments.argStruct.startIdx);
    arguments.argStruct.endIdx 			= javacast("int",arguments.argStruct.endIdx);
    arguments.argStruct.outBegIdx 		= javacast("int",arguments.argStruct.outBegIdx);
    arguments.argStruct.outNBElement 	= javacast("int",arguments.argStruct.outNBElement);
    arguments.argStruct.optInTimePeriod = javacast("int",arguments.argStruct.optInTimePeriod);
    </cfscript>
</cffunction>
	
<!--- 

AD                  Chaikin A/D Line
ADOSC               Chaikin A/D Oscillator
ADX                 Average Directional Movement Index
ADXR                Average Directional Movement Index Rating
APO                 Absolute Price Oscillator
AROON               Aroon
AROONOSC            Aroon Oscillator
ATR                 Average True Range
AVGPRICE            Average Price
BBANDS              Bollinger Bands
BETA                Beta
CCI                 Commodity Channel Index
CMO                 Chande Momentum Oscillator
DX                  Directional Movement Index
EMA                 Exponential Moving Average
KAMA                Kaufman Adaptive Moving Average
LINEARREG           Linear Regression
LINEARREG_ANGLE     Linear Regression Angle
LINEARREG_INTERCEPT Linear Regression Intercept
LINEARREG_SLOPE     Linear Regression Slope
MA                  Moving average
MACD                Moving Average Convergence/Divergence
MACDEXT             MACD with controllable MA type
MACDFIX             Moving Average Convergence/Divergence Fix 12/26
MAMA                MESA Adaptive Moving Average
MAVP                Moving average with variable period
MFI                 Money Flow Index
MINUS_DI            Minus Directional Indicator
MINUS_DM            Minus Directional Movement
MOM                 Momentum
OBV                 On Balance Volume
PLUS_DI             Plus Directional Indicator
PLUS_DM             Plus Directional Movement
PPO                 Percentage Price Oscillator
ROC                 Rate of change : ((price/prevPrice)-1)*100
ROCP                Rate of change Percentage: (price-prevPrice)/prevPrice
ROCR                Rate of change ratio: (price/prevPrice)
ROCR100             Rate of change ratio 100 scale: (price/prevPrice)*100
RSI                 Relative Strength Index
SAR                 Parabolic SAR
SAREXT              Parabolic SAR - Extended
SMA                 Simple Moving Average
STOCH               Stochastic
STOCHF              Stochastic Fast
STOCHRSI            Stochastic Relative Strength Index
TRANGE              True Range
TRIMA               Triangular Moving Average
TRIX                1-day Rate-Of-Change (ROC) of a Triple Smooth EMA
TSF                 Time Series Forecast
TYPPRICE            Typical Price
ULTOSC              Ultimate Oscillator
VAR                 Variance
WCLPRICE            Weighted Close Price
WILLR               Williams' %R
WMA                 Weighted Moving Average 
--->
</cfcomponent>