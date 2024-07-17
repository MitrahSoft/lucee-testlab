<cfscript>
	params = {
		test: {value: createUUID(), sqltype="varchar" }
	};

	query params=params result="result" {
		echo( "INSERT INTO benchmark( test ) VALUES ( :test )" );
	}
	params.id = { value: result.generatedKey, sqltype="numeric" };

	query name="q" params=params {
		echo( "select test from benchmark where test = :test and id = :id " );
	}
	
	if ( q.id != params.id || q.test != params.test || q.recordcount !=1 )
		throw "invalid result [#params.toJson()#], [#q.toJson()#]";
</cfscript>