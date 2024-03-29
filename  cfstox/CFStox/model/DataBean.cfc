<cfcomponent  displayname="DataBean" output="false"  hint="I represent the values and indicators for a given day" >

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="DataBean">
		<cfargument name="strData"  />
		<cfscript>
		set("Symbol",strData.Symbol);	
		set("Date",strData.DateOne);	
		set("HKOpen",strData.Open);
		set("HKHigh",strData.High);
		set("HKLow",strData.Low);
		set("HKClose",strData.Close);
		set("HKVolume",strData.Volume);
		set("Open",strData.Open);
		set("High",strData.High);
		set("Low",strData.Low);
		set("Close",strData.Close);
		set("Volume",strData.Volume);
		set("ADX",strData.ADX);
		set("CCI",strData.CCI);
		set("CCI5",strData.CCI5);
		set("RSI",strData.RSI); 
		set("LinearReg",strData.LinearReg);
		set("LinearReg10",strData.linearReg10); 
		set("LinearRegAngle",strData.LinearRegAngle);
		set("LinearRegIntercept",strData.LinearRegIntercept);
		set("LinearRegSlope",strData.LinearRegSlope);
		set("LinearRegSlope10",strData.LinearRegSlope10);
		set("LRSDelta",strData.LRSDelta);
		set("Momentum",strData.Momentum);
		set("S1",strData.S1);
		set("S2",strData.S2);
		set("R1",strData.R1);
		set("R2",strData.R2);
		set("PP",strData.PP);  
		// trade info
		Set("NewHighBreakout","false"); //high greater than prev local high
		Set("NewHighReversal","false"); // bounce off new local high 
		Set("NewLowBreakDown","false"); //new low greater than previous local low
		Set("NewLowReversal","false"); // bounce off new local low
		Set("PreviousLocalHigh",0);
		Set("PreviousLocalLow",0);
		Set("PreviousLocalHighDate","00/00/0000");
		Set("PreviousLocalLowDate","00/00/0000");
		Set("NewLocalLow",false);
		Set("NewLocalHigh",false);
		Set("NewLow",false);
		Set("NewHigh",false);
		Set("OpenLongAlert","false");
		Set("OpenLong","false");
		Set("OpenShortAlert","false");
		Set("OpenShort",false);
		Set("CloseLongAlert","false");
		Set("CloseLong","false");
		Set("CloseShortAlert","false");
		Set("CloseShort","false");
		Set("HKGoShort","false");
		Set("HKCloseShort","false");
		Set("HKGoLong","false");
		Set("HKCloseLong","false");
		Set("UseR1Entry","false");
		Set("UseR2Entry","false");
		Set("UseS1Entry","false");
		Set("UseS2Entry","false");
		Set("TradeDate","00/00/0000");
		Set("TradePrice",0);
		Set("EntryDate","00/00/0000");
		Set("EntryPrice",0);
		Set("EntryPoint","R2");
		Set("ExitDate","00/00/0000");
		Set("ExitPrice",0);
		Set("ExitPoint","S1");
		Set("ProfitLoss",0);
		Set("NetProfitLoss",0);
		Set("StopLossPrice",0);
		Set("StopLossTriggered",false);
		Set("RSIstatus","");
		Set("CCIstatus","");
		Set("MomentumStatus","");
		Set("BolBandStatus","");
		Set("MACDStatus","");
		Set("R1Breakout1Day",false);
		Set("R1BreakOut2Days",false);
		Set("R2Breakout1Day",false);
		Set("R2BreakOut2Days",false);
		Set("S1Breakdown1Day",false);
		Set("S1Breakdown2Days",false);
		Set("S2Breakdown1Day",false);
		Set("S2Breakdown2Days",false);
		Set("R1Status","");
		Set("R2Status","");
		Set("S1Status","");
		Set("S2Status","");
		Set("TBStatus","");
		Set("TBStatusChange","");
		Set("TradeType","");
		// candle patterns
		Set("Engulfing",strData.Engulfing);
		Set("Hammer",strData.Hammer);
		Set("HangingMan",strData.HangingMan);
		Set("ThreeInside",strData.ThreeInside);
		Set("ThreeOutside",strData.ThreeOutside);
		Set("ThreeBlackCrows",strData.ThreeBlackCrows);
		Set("Harami",strData.Harami);
		Set("HaramiCross",strData.HaramiCross);
		Set("LongLine",strData.LongLine);
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemento" description="" access="public" displayname="" output="false" returntype="Any">
		<cfreturn variables />
	</cffunction>
	
	<cffunction name="Set" description="" access="public" displayname="" output="false" returntype="void">
		<cfargument name="fieldname" required="true"  />
		<cfargument name="data" required="true"  />
		<cfset variables[#fieldname#] = arguments.data />
		<cfreturn />
	</cffunction>	
	
	<cffunction name="Get" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="fieldname" required="true"  />
		<cfreturn variables[#fieldname#] />
	</cffunction>	
	
	
</cfcomponent>