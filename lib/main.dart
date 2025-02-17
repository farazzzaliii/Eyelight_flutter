import 'package:ai/controller/scanner.dart';
import 'package:ai/view/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Camera Object Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FullScreenContainerWidget(),
    );
  }
}

class FullScreenContainerWidget extends StatefulWidget {
  @override
  _FullScreenContainerWidgetState createState() =>
      _FullScreenContainerWidgetState();
}

class _FullScreenContainerWidgetState extends State<FullScreenContainerWidget> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioInstructionOn = true;

  @override
  void initState() {
    super.initState();
    _loadAudioInstructionState();
  }

  Future<void> _loadAudioInstructionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _audioInstructionOn = prefs.getBool('audio_instruction_on') ?? true;
    });
  }

  Future<void> _saveAudioInstructionState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_instruction_on', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text(
          'Eyelight',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.amber[800],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber[900],
                ),
                child: Text(
                  'Eyelight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              SwitchListTile(
                value: _audioInstructionOn,
                onChanged: (value) {
                  setState(() {
                    _audioInstructionOn = value;
                  });
                  _saveAudioInstructionState(value);
                },
                title: Text(
                  'Audio Instruction',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () async {
          if (_audioInstructionOn) {
            await _audioPlayer.play(AssetSource('instruction.mp3')); // Corrected path
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Eyelight.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioInstructionOn = true;

  @override
  void initState() {
    super.initState();
    _loadAudioInstructionState();
  }

  Future<void> _loadAudioInstructionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _audioInstructionOn = prefs.getBool('audio_instruction_on') ?? true;
    });
  }

  Future<void> _saveAudioInstructionState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_instruction_on', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        centerTitle: true,
        title: Text(
          'Eyelight',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.amber[800],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber[900],
                ),
                child: Text(
                  'Eyelight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              SwitchListTile(
                value: _audioInstructionOn,
                onChanged: (value) {
                  setState(() {
                    _audioInstructionOn = value;
                  });
                  _saveAudioInstructionState(value);
                },
                title: Text(
                  'Audio Instruction',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
               // if (_audioInstructionOn) {
                  await _audioPlayer.play(AssetSource('currency.mp3')); // Corrected path
                //}

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraView(
                      scanController: ObjectScanController(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/currency.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                //if (_audioInstructionOn) {
                  await _audioPlayer.play(AssetSource('object.mp3')); // Corrected path
                //}

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraView(
                      scanController: ObjectScanController2(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/object.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                //if (_audioInstructionOn) {
                  await _audioPlayer.play(AssetSource('text.mp3')); // Corrected path
                //}

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraView(
                      scanController: ObjectScanController3(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/text.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}