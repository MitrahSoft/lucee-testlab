<cfscript>

    var dir = getDirectoryFromPath(getCurrentTemplatePath()) & "jars";

    files = directoryList( dir, true );

    poiJarPaths = [];

    for ( file in files ){
        arrayAppend(poiJarPaths, file.path );
    }
    systemOutput( poiJarPaths, true );
    
    local.WorkBook = CreateObject(
        "java",
        "org.apache.poi.hssf.usermodel.HSSFWorkbook",
        poiJarPaths
    ).Init();
</cfscript>