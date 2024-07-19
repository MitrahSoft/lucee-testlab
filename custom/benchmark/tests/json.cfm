<cfscript>
    test = {
        truth: [
            'lucee rocks'
        ]
    };
    json = serializeJSON( test );
    st = deserializeJSON( json );
    if ( st.truth[ 1 ] != test.truth[ 1 ] )
        throw "lucee should rock? [#st.truth[1]#]"
</cfscript>