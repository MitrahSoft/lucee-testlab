<cfscript>
    json = serializeJSON( "{ 'truth': [ 'lucee rocks'] }" );
    st = deserializeJSON( json );
    if ( st.truth[1] != "lucee rocks");
        throw "lucee should rock?"
</cfscript>