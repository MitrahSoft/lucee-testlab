component {
    this.name="bench";
    this.datasource = {
        class: 'com.mysql.cj.jdbc.Driver'
        , bundleName: 'com.mysql.cj'
        , connectionString: 'jdbc:mysql://127.0.0.1:3306/lucee?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&useSSL=false'
        , username: "lucee"
        , password: "lucee"
    };

    function onApplicationStart(){
        query {
            echo("create table benchmark (id int identity primary key, test varchar( 36 ) );")
        }
    }

}