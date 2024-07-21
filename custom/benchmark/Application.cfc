component {
    this.name="bench-runner1";

    function onApplicationStart(){
        application.testSuite = [
            //"hello-world"
            //, "json"
          //  , "db"
            "qoq-hsqldb"
        ];
    }

    function onRequestStart(){
      request.adminPassword= "admin";
      pagePoolClear();
      configImport( {"inspectTemplate": "once" }, "server", request.adminPassword );
	  }

    function onRequestEnd(){
      echo("resetting inspectTemplate #now()#<br>");
		  configImport( {"inspectTemplate": "once" }, "server", request.adminPassword );
	  }
}