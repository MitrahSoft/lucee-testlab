<cfscript>

	systemOutput( "--- Bundle Test ---- " );
	systemOutput( "--- extensions are loaded on demand, so let's trigger them ---- " );
	systemOutput( "", true );

	systemOutput( "ESAPI", true );
	encodeForHTML( "lucee" );

	systemOutput( "", true );
	systemOutput( "CFZIP", true );
	file = getTempFile(getTempDirectory(), "test", "text" );
	zip action="zip" source="#file#" file="#getTempFile(getTempDirectory(), "test", "zip")#";

	systemOutput( "", true );
	systemOutput( "PDF", true );
	isPDFObject( file );

	systemOutput( "", true );
	systemOutput( "S3", true );
	s3exists( bucketName="extension-download", objectName="test", accessKeyId="test", secretAccessKey="test" ); // will throw

	/* 
	broken
	systemOutput( "", true );
	systemOutput( "Argon", true );
	generateArgon2Hash( "lucee" );
	*/
	adminPassword = "lucee-test";
	
	function checkPassword() {
		try {
			admin action="connect"
					type="server"
					password=adminPassword;
		} catch ( e ) {
			return false;
		}
		return true;
	}

	systemOutput( "see if password is set via env var: #checkPassword()#", true );

	if (!checkPassword() ) {
		systemOutput( "try updatePassword", true );
		dmin
			action="updatePassword"
			type="server"
			oldPassword=""
			newPassword="#adminPassword#";
	}

	if (!checkPassword() ) {
		systemOutput( "try writing password to #expandPath('{lucee-config}/password.txt')#", true );
		fileWrite( expandPath('{lucee-config}/password.txt'), adminPassword );

		systemOutput( "check password", true );
		admin
			action="checkPassword"
			type="server";	
	}

	systemOutput( "getBundles", true );
	
	admin type="server"
		password=adminPassword
		action="getBundles"
		returnvariable="bundles";

	for ( bundle in bundles ){
		systemOutput( "#chr(9)# #bundle.symbolicName#, #bundles.version#, #bundles.state#", true );
	}
	systemOutput( "--- finished ---- " );
</cfscript>