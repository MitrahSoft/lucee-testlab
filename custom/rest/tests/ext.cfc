component restpath="/test" rest="true" {

    remote string function sas()  httpmethod="GET" restpath="check"{
      return "success";
    }
  
}