<cfcomponent displayname="controller" output="false">
	<cffunction name="init" description="init method" access="public" displayname="" output="false" returntype="controller">
		<cfset loadObjects() />
		<cfset this.diagnostics = false />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunEvent" description="" access="public" displayname="" output="false" returntype="void">
		<cfscript>
		
		</cfscript>
		<cfreturn />
	</cffunction>
	
	<cffunction name="Historical" description="Generate historical data reports" access="public" displayname="" output="false" returntype="any">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		request.view = "historical";
		request.symbol = "#arguments.symbol#";
		request.method = "Historical";
		
		GetData(argumentcollection:arguments);
		//session.objects.ReportService.ReportRunner(reportName:"HistoryReport",dataType:"Original");
		//session.objects.ReportService.ReportRunner(reportName:"PivotReport",datatype:"Original");
		//session.objects.ReportService.ReportRunner(reportName:"CandleReport",datatype:"Original");
		request.qryDataOriginal = session.objects.DataStorage.GetData("qryDataOriginal");
		request.qryDataHA 		= session.objects.DataStorage.GetData("qryDataHA");
		request.xmldata 		= session.objects.DataStorage.GetData("XMLDataOriginal");
		request.xmldataHA 		= session.objects.DataStorage.GetData("XMLDataHA");
		return ;
		</cfscript> 
	</cffunction>
	
	<cffunction name="AnalyseData" description="Generate historical data reports" access="public" displayname="" output="false" returntype="any">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		request.view = "historical";
		request.symbol = "#arguments.symbol#";
		request.method = "Historical";
		GetData(argumentcollection:arguments);
		request.qryDataOriginal = session.objects.DataStorage.GetData("qryDataOriginal");
		request.qryDataHA 		= session.objects.DataStorage.GetData("qryDataHA");
		request.xmldata 		= session.objects.DataStorage.GetData("XMLDataOriginal");
		request.xmldataHA 		= session.objects.DataStorage.GetData("XMLDataHA");
 		local.ReportArray = session.objects.StrategyService.Analyse();
		session.objects.ReportService.AnalyseDataReport(symbol:arguments.symbol,data:local.reportArray);
		// for unit testing 
		return local.ReportArray;
		</cfscript> 
	</cffunction>	
	<cffunction name="loadSQL" description="load the remote SQL table" access="public" displayname="" output="false" returntype="Struct">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		local.view = "viewSQL";
		session.objects.DataService.GetStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") ; 
		local.qryDataHA		= session.objects.DataService.GetHAStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") ; 
		local.qryDataOriginal = session.objects.DataService.GetOriginalStockData();
		structAppend(request,local); 
		structAppend(request,arguments);
		request.method = "loadSQL";
		return local;
		</cfscript> 
	</cffunction>
	
	<cffunction name="backtest" description="provide results using given system" access="public" displayname="" output="false" returntype="struct">
		<!---- todo: add entry exit excel output ---->
		<!--- <cfargument name="argumentData"> --->
		<!--- the query is loaded with all indicators/rules run. this simplifies the application of a 
		particular set of rules in the trading system. We also can display on a chart the indicator values
		ie how much it went outside the bollinger band, went over under pivot points, etc
		 --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfargument name="SystemName" required="false" default="BearishCandles">
		<cfscript>
		var local = structnew(); 
		local.view = "historical";
		local.data = historical(symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate);
		local.result = session.objects.SystemService.RunSystem(SystemName:arguments.SystemName,qryData:local.data);
		session.objects.ReportService.ReportRunner(reportName:"BacktestReport",data:local.result.get("tradeHistory"),symbol:arguments.symbol);
		request.method = "backtest";  
		return local;
		</cfscript>
	</cffunction>
	
	<cffunction name="strategyreport" description="provide results using given system" access="public" displayname="" output="false" returntype="struct">
		<!---- todo: add entry exit excel output ---->
		<!--- <cfargument name="argumentData"> --->
		<!--- the query is loaded with all indicators/rules run. this simplifies the application of a 
		particular set of rules in the trading system. We also can display on a chart the indicator values
		ie how much it went outside the bollinger band, went over under pivot points, etc
		 --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		local.view = "historical";
		historical(argumentcollection:arguments);
		session.objects.StrategyService.Analyse();
		session.objects.ReportService.ReportRunner(reportName:"StrategyReport");
		return;
		</cfscript>
	</cffunction>
	
	<cffunction name="watchlist" description="run systems against watchlist" access="public" displayname="" output="false" returntype="struct">
		<cfset var local = structnew() />
		<cfset local.view = "watchlist">
		<!--- <cfset local.theList = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
> --->
<cfset local.theList = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM"
>
	<!--- SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF --->
		<cfset local.startDate = dateformat(now()-30,"mm/dd/yyyy") />
		<cfset local.endDate = dateformat(now(),"mm/dd/yyyy") />
		<cfset request.data = session.objects.systemservice.RunWatchList(SystemToRun:"test",watchlist:arguments.watchlist) />
		<cfreturn local />
	</cffunction>

	<cffunction name="PopulateData" description="populate the database with stock data" access="public" displayname="" output="false" returntype="struct">
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfset var local = structnew() />
		<cfset local.results = session.objects.DataService.putData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="GetData" description="Generate historical data reports" access="public" displayname="" output="false" returntype="void">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		session.objects.DataStorage.SetData(DataSet:"Symbol",theData:arguments.symbol);
		session.objects.DataStorage.SetData(DataSet:"startDate",theData:arguments.startDate); 
		session.objects.DataStorage.SetData(DataSet:"endDate",theData:arguments.endDate);  		
		local.stockdata = session.objects.DataService.GetStockData(argumentcollection:arguments);
		session.objects.DataStorage.SetData(DataSet:"qryDataOriginal", theData:local.stockData.qryDataOriginal ); 
		session.objects.DataStorage.SetData(DataSet:"qryDataHA", theData:local.stockData.qryDataHA );
		session.objects.DataStorage.SetData(DataSet:"High", theData:session.objects.DataService.GetHigh()  ); 
		session.objects.DataStorage.SetData(DataSet:"Low", theData:session.objects.DataService.GetLow() ); 
		session.objects.DataStorage.SetData(DataSet:"XMLDataOriginal", theData:session.objects.XMLGenerator.GenerateXML(dataType:"Original") );
		session.Objects.DataStorage.SetData(DataSet:"XMLDataHA", theData:session.objects.XMLGenerator.GenerateXML(dataType:"HeikenAshi") );
		return;
		</cfscript> 
	</cffunction>
	<cffunction name="LoadXMLData" description="set up XML Data for Charting" access="private" displayname="" output="false" returntype="any">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfscript>
		var local = structnew(); 
		session.objects.DataService.GetStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
		local.xmldata 		= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.symbol#",qrydata:local.qryDataOriginal,startdate:"#arguments.startdate#", high:local.high, low:local.low);
		local.xmldataha 	= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.Symbol#",qrydata:local.qryDataHA,startdate:"#arguments.startdate#", high:local.high, low:local.low);
		session.objects.ReportService.ReportRunner(reportName:"HistoryReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"PivotReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"CandleReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		//session.objects.ReportService.ReportRunner(reportName:"BreakoutReport",data:local.OriginalData,symbol:arguments.symbol);
		structAppend(request,local); 
		structAppend(request,arguments);
		request.method = "historical";
		return local;
		</cfscript> 
	</cffunction>

	<cffunction name="loadObjects" description="I load objects" access="private" displayname="" output="false" returntype="void">
	<!--- load the objects that we might need if not already loaded and set the loaded flag in session --->
	<cfset session.objects.XMLGenerator 	= createobject("component","cfstox.model.XMLGenerator").init() />
	<cfset session.objects.Indicators 		= createobject("component","cfstox.model.Indicators").init() />
	<cfset session.objects.Utility 			= createobject("component","cfstox.model.Utility").init() />
	<cfset session.objects.ta 				= createObject("component","cfstox.model.ta").init() />
	<cfset session.objects.http 			= createObject("component","cfstox.model.http").init() />
	<cfset session.objects.System 			= createObject("component","cfstox.model.system").init() />
	<cfset session.objects.DataService 		= createObject("component","cfstox.model.Dataservice").init() />
	<cfset session.objects.SystemService 	= createObject("component","cfstox.model.SystemService").init() />
	<cfset session.objects.SystemRunner 	= createObject("component","cfstox.model.SystemRunner").init() />
	<cfset session.objects.SystemTriggers	= createObject("component","cfstox.model.SystemTriggers").init() />
	<cfset session.objects.ReportService	= createObject("component","cfstox.model.ReportService").init() />
	<cfset session.objects.DataStorage 		= createObject("component","cfstox.model.DataStorage").init() />
	<cfset session.objects.StrategyService	= createObject("component","cfstox.model.StrategyService").init() />
	<cfreturn />
	</cffunction>	

	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="object" required="true" />
		<cfargument name="label" required="false" default="bean:"/>
		<cfargument name="abort" required="false"  default="true" />
		<cfdump label="#arguments.label#" var="#arguments.object#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>
	
</cfcomponent>