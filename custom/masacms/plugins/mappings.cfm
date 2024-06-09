<cfscript>
    if (fileExists(expandpath("/core/tests/.cfconfig.json"))){
		systemOutput("importing cfconfig.json (mappings)", true);
		cfg= configImport(
			type: "server",
			data: deserializeJSON(fileRead(expandpath("/core/tests/.cfconfig.json"))),
			password="admin"
		);
        systemOutput(cfg, true);
	}
   // sleep(2000);
    systemOutput(getApplicationSettings().datasources.toJson(), true);
    dbinfo type="Version" datasource="masacms" name="verify";
    systemOutput(verify.toJson(), true);
</cfscript>