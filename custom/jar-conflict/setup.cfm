<cfscript>
    files = [
        "https://repo1.maven.org/maven2/org/apache/poi/poi-ooxml/5.3.0/poi-ooxml-5.3.0.jar",
        "https://repo1.maven.org/maven2/org/apache/poi/poi/5.3.0/poi-5.3.0.jar"
    ]
    dir = getDirectoryFromPath(getCurrentTemplatePath()) & "jars";
    directoryCreate( dir );

    for ( fileUrl in files ){
        http url=fileUrl path=dir file=ListLast( fileUrl,"/ ");
    }
    files = directoryList( dir, true );
    systemOutput( files );
</cfscript>
