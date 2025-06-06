component extends="org.lucee.cfml.test.LuceeTestCase" labels="rest" {

    variables.localhost="http://127.0.0.1:8888";
    variables.adminPassword = "password";
    function run( testResults , testBox ) {
        describe( title="rest mapping tests", body=function() {
            it(title="rest mapping", body = function( currentSpec ) {
				//create a rest mapping
                RestInitApplication(expandPath("."), '/test', false, variables.adminPassword);

                http url="#localhost#/rest/test/test/check" result="local.result";
                expect( local.result.filecontent ).toBe('"success"');
                expect( local.result.status_code ).toBe(200);
            });
        });
    }
}