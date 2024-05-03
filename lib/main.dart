import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D viewer',
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 81, 157, 227),
          brightness: Brightness.dark,
          ),
      
        textTheme: const TextTheme (
          headlineMedium: TextStyle (
            fontSize: 20,
          ),
        ),
      ),
      home: const MyHomePage(title: '3D map viewer'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Model Viewer')),
        body: 
          // const Display3DModel(fileName: 'Astronaut.glb',),
          const Flutter3DViewer(src: 'assets/models/demo.glb')
        ),
        // body: const ModelViewer(
        //   backgroundColor: Color.fromARGB(255, 255, 238, 160),
        //   src: 'https://science.nasa.gov/wp-content/uploads/2023/09/Moon_1_3474.glb?emrc=66300e115c07b',
        //   alt: '3D Map Model',
        //   ar: true,
        //   autoRotate: true,
        //   iosSrc: 'https://homologmodels.blob.core.windows.net/models/5d8dc969-b06e-44a0-814f-e0a669fa5292',
        //   disableZoom: false,
        // ),
      );
  }
}


class Display3DModel extends StatefulWidget {

  const Display3DModel({super.key, required this.fileName, this.child});

  final String fileName;
  final Widget? child;
  // https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
  @override
  State<Display3DModel> createState() => _Display3DModelState();
}


class _Display3DModelState extends State<Display3DModel> {
  String fileName = '';
  String modelPath = '';

  void changeModel() {
    setState(() {
      String assetPath = 'assets/models/';
      modelPath = '$assetPath$fileName';
      File? sourceFile = File(modelPath);
      
      Future checkDirectory() async {
          final Directory assetDirectory = await getTemporaryDirectory();
          final List<FileSystemEntity> files = assetDirectory.listSync();

          for (final FileSystemEntity file in files) {
            final FileStat fileStat = await file.stat();
            debugPrint('Path: ${file.path}');
            debugPrint('type: ${fileStat.type}');
            debugPrint('size: ${fileStat.size}');
            }
          }
      
      if (sourceFile.existsSync()) {
        debugPrint("file $modelPath exists");
      } else {
        debugPrint("can't find $modelPath");
        modelPath = '${assetPath}Box.glb';
        debugPrint("instead using $modelPath \n");
        checkDirectory();
      }
    });
  }

  @override 
  Widget build(BuildContext context) {
    Flutter3DController controller = Flutter3DController();
    controller.setCameraTarget(0, 0, 0);
    controller.setCameraOrbit(0, 0, 0);
    return (
      Flutter3DViewer(
        progressBarColor: Colors.blue,
        src:modelPath,
        controller: controller,
      )
    );     
  }
}