component {
	this.name="bench2";
	this.datasource1 = {
		class: 'com.mysql.cj.jdbc.Driver'
		, bundleName: 'com.mysql.cj'
		, connectionString: 'jdbc:mysql://127.0.0.1:3306/lucee?useSSL=false'
		, username: "lucee"
		, password: "lucee"
	};

	function onApplicationStart2(){
		return;
		query {
			echo("drop table if exists benchmark")
		}	
		query {
			echo("create table benchmark (id INT AUTO_INCREMENT PRIMARY KEY, test VARCHAR( 36 ) )")
		}
	}
}