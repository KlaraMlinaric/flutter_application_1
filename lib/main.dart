import 'package:flutter/material.dart';
import 'map.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required by FlutterConfig for maps
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFA1045A)),
        scaffoldBackgroundColor: const Color(0xff303030),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ime'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _selectedOption = 'Create Game';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA1045A),
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
                        style: TextStyle(
                          color: Color(0xFFA1045A),
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),

            // Enter code
            if (_selectedOption == 'Join Game')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Enter Code',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
              ),

            SizedBox(
              height: 50.0,
              width: 300,
            ), //padding form enter code bar
            StartButton(
              nicknameController: _nicknameController,
              codeController: _codeController,
              onPressed: () {
                //String nickname = _nicknameController.text;
                String code = _codeController.text;

                if (_selectedOption == 'Join Game' && code == '1234') {
                  // PIN is correct
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSample(), // Use MapScreen here
                    ),
                  );
                } else {
                  print('Incorrect PIN');
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
  final TextEditingController nicknameController;
  final TextEditingController codeController;
  final VoidCallback onPressed;

  StartButton({
    required this.nicknameController,
    required this.codeController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        'Start Game',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }
}


//request sa servera za "room"