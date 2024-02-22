import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'toast.dart';
import 'map.dart';

const double fontSize = 20.0;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required by FlutterConfig for maps
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFA1045A),
        scaffoldBackgroundColor: const Color(0xff303030),    
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hide&See'),
      color: const Color(0xffffffff),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedOption = 'Create Game';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _timeIntervalController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1045A),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue!;
                });
              },
              items: <String>['Create Game', 'Join Game']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFFA1045A),
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),

            // Enter ip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Server IP',
                  labelStyle: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
            const SizedBox(
              height: 0.0,
              width: 300,
            ),

            // White box
            if (_selectedOption == 'Create Game')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: Column(
                    children: [
                      // User input time interval
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextField(
                          controller: _timeIntervalController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          decoration: const InputDecoration(
                            labelText: 'Time Interval (minutes)',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: fontSize),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], 
                        ),
                      ),


                      // User input for radius
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextField(
                          controller: _radiusController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Radius (kilometers)',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: fontSize),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.replaceAll(',', '.'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),

            const SizedBox(
              height: 20.0,
              width: 300,
            ), // Padding for enter IP bar

            StartButton(
              usernameController: _usernameController,
              ipController: _ipController,

              onPressed: () async {
                String username = _usernameController.text;
                String ip = _ipController.text;

                LocationData startLoc = await Location().getLocation();
                String radius = _radiusController.text;
                String timeInterval = _timeIntervalController.text;

                Map body;
                Uri url;
                http.Response? response;

                if(_selectedOption == 'Create Game'){
                  url = Uri.http("$ip:8000", "new_game");
                  body = {
                    "username": username,
                    "startLoc": "${startLoc.latitude} ${startLoc.longitude}",
                    "radius": radius,
                    "timeInterval": timeInterval
                  };
                }else{
                  url = Uri.http("$ip:8000", "join_game");
                  body = {
                    "username": username
                  };
                }
                
                try {
                  response = await http.post(url, body: body);
                } catch(err) {
                  toast("Server not found");
                }

                if(response != null){
                  switch(response.statusCode){
                    case 200: {
                      Map settings = jsonDecode(response.body);
                      //ako je settings null onda nema gamea
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => MapSample(
                          username: username,
                          ip: ip,

                          startLoc: settings["startLoc"],
                          radius: double.parse(settings["radius"]),
                          timeInterval: int.parse(settings["timeInterval"]),
                          seeker: settings["seeker"]
                          ),
                        ),
                      );
                    }
                    break;

                    case 400: {
                      if(_selectedOption == 'Create Game'){
                        if(username == ""){
                          toast("Username is required");
                        }
                        else if(timeInterval == ""){
                          toast("Time interval is required");
                        }
                        else if(radius == ""){
                          toast("Radius is required");
                        }
                      }

                      else{
                        if(username == ""){
                          toast("Username is required");
                        }
                        else{
                          toast("Game not started yet");
                        }
                      }
                    }
                    break;

                    case 409:{
                      toast("Name already ni use");
                    }
                    break;

                    default: {
                      toast("Unknown error");
                    }
                    break;
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController ipController;
  final VoidCallback onPressed;

  const StartButton({
    super.key,
    required this.usernameController,
    required this.ipController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text(
        'Start Game',
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
