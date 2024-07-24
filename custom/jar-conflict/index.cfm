<cfscript>

    dir = getDirectoryFromPath(getCurrentTemplatePath()) & "poi-ext";

    files = directoryList( dir, true );

    poiJarPaths = [];

    systemOutput( files, true );

    for ( file in files ){
        if ( listLast( file, ".") eq "jar" && listLast( file, "/") contains "poi-" )
        arrayAppend(poiJarPaths, file );
    }
    systemOutput( poiJarPaths, true );
    
    workBook = CreateObject(
        "java",
        "org.apache.poi.hssf.usermodel.HSSFWorkbook",
        poiJarPaths
    ).Init();
</cfscript>