<cfscript>
    q = extensionList();
    json = serializeJSON( q );
    st = deserializeJSON( json );
</cfscript>