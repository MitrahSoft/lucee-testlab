<cfscript>
	q = queryNew( "id,name,data", "integer,varchar,varchar" );
	names= [ 'micha', 'zac', 'brad', 'pothys', 'gert' ];
	loop array="#names#" item="n" {
		r = queryAddRow( q );
		querySetCell( q, "id", r, r );
		querySetCell( q, "name", n, r );
	}
	// native engine
	q_native = QueryExecute(
		sql = "SELECT id, name FROM q ORDER BY name",
		options = { dbtype: 'query' }
	);
	/*

	throw "zac"; // i am seeing the following code run somehow?
	// hsqldb engine, coz join
	q_hsqlb = QueryExecute(
		sql = "SELECT t1.name FROM q_native t1, q_native t2 WHERE t1.id = t2.id errrrrrrrrrrrror",
		options = { dbtype: 'query' }
	);
	if ( q_native.recordcount != q_hsqlb.recordcount )
		throw "qoq recordcounts don't match, #q_native.recordcount# != #q_hsqlb.recordcount#";
	*/

</cfscript>