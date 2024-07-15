<cfscript>
    dir = getDirectoryFromPath( getCurrentTemplatePath() ) & "artifacts";
    files = directoryList( dir );

    for (f in files){
        systemOutput ( f, true );
    }
</cfscript>