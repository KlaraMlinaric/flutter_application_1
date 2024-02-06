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
  final TextEditingController _timeIntervalController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1045A),
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
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),

            // Enter code
            if (_selectedOption == 'Join Game')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Code',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Time Interval (minutes)',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),


                      // User input for radius
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextField(
                          controller: _radiusController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Radius (kilometers)',
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
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
            ), // Padding for enter code bar

            StartButton(
              nicknameController: _nicknameController,
              codeController: _codeController,
              onPressed: () {
                if (_selectedOption == 'Join Game') {
                } else if (_selectedOption == 'Create Game') {
                  int timeInterval =
                      int.tryParse(_timeIntervalController.text) ?? 0;
                  double radius =
                      double.tryParse(_radiusController.text) ?? 0.0;

                  //map screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSample(),
                    ),
                  );
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
      child: const Text(
        'Start Game',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
    );
  }
}
