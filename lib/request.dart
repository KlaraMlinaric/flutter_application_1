import 'package:http/http.dart' as http;

// self note: KORISTI 10.0.2.2 KAO IP DA IZBJEGNES DUSEVNE BOLI

Future<int> joinGame(String ip, String name) async{

  var url = Uri.http("$ip:8000", "join_game");
  var body = {"username": name};
  
  int code;
  try {
    var response = await http.post(url, body: body);
    code = response.statusCode;
  } catch(err) {
    code = 400;
  }
  return code;
}

Future<int> newGame(String ip, String name, int timeInterval, double radius) async{

  var url = Uri.http("$ip:8000", "new_game");
  var body = {
    "username": name,
    "timeInterval": timeInterval,
    "radius": radius
    };
  
  int code;
  try {
    var response = await http.post(url, body: body);
    code = response.statusCode;
  } catch(err) {
    code = 400;
  }
  return code;
}