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
    
    // test case for https://luceeserver.atlassian.net/browse/LDEV-4998
    // Bad type on operand stack Exception calling poi
    // due to loading jars already loaded via context/lib

    workBook = CreateObject(
        "java",
        "org.apache.poi.hssf.usermodel.HSSFWorkbook",
        poiJarPaths
    ).Init();
</cfscript>