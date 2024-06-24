<cfscript>
    default = fileRead( expandPath('{lucee-config}.CFConfig.json') );
    fileWrite( expandPath("./.CFConfig-default.json"), default ) 
</cfscript>