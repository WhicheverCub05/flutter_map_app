import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await FlutterDownloader.initialize( // should be await
      debug: kDebugMode, ignoreSsl: true );

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
      home: const Make3DViewer(title: '3D Model viewer'),
    );
  }
}

class Make3DViewer extends StatefulWidget {
  const Make3DViewer({super.key, required this.title});

  final String title;
  // https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
  @override
  State<Make3DViewer> createState() => _Make3DViewerState();
}


class _Make3DViewerState extends State<Make3DViewer> {
  String localAssetPath = '';
  String localAssetFileName = '';
  String defaultAssetPath = 'assets/models/'; 
  String defaultlocalAssetFileName = 'NASA_moon.glb';
  
  String assetAPIUrl = 'https://hypamaps-api.azurewebsites.net/viewer/model/';
  String assetAPIName = '';
  String assetDownloadUrl = '';
  String assetCoordinates = '';

  String currentModelSrc = '';

  bool usingLocalModel = true;
  bool autoRotate_ = true;

  // had this.localAssetFileName, String? newAssetPath
  _Make3DViewerState() {
    debugPrint("_Make3DViewerState is called");
    debugPrint("using -> localAssetFileName: $localAssetFileName, assetPath: $localAssetPath");
    if (!kIsWeb) {requestDownloadPermissions();}
  }
  

  Future<void> requestDownloadPermissions() async {
    await Permission.storage.request();
  }


  Future<String> getDownloadFilePath(String fileName) async {
    Directory appDocDir = await getApplicationCacheDirectory();
    String appDocPath = appDocDir.path;
    return '$appDocPath$fileName';
  }


  void setModelSrc({String? newSrc}) {
    // when changing state, can't add arguments so need to pull fileName from input or set variable
    setState(() {
      if (newSrc != null) { currentModelSrc = newSrc;}

      if (currentModelSrc == '') {
        currentModelSrc = '$defaultAssetPath$defaultlocalAssetFileName';
        debugPrint("default asset path: $defaultAssetPath");
      }

      if (currentModelSrc.contains('http')) {
        usingLocalModel = false;
      } else {
        usingLocalModel = true;
      }

      autoRotate_ = false;
    });
  }


  Future<void> downloadMapModelFromAPI({String? downloadUrl}) async {
    if (downloadUrl != null) { assetDownloadUrl = downloadUrl; }
    
    // assetDownloadUrl = "https://homologmodels.blob.core.windows.net/models/5d8dc969-b06e-44a0-814f-e0a669fa5292";
    assetDownloadUrl = "https://science.nasa.gov/wp-content/uploads/2023/09/Moon_1_3474.glb?emrc=66381d00ac290";
    String saveFileName = 'test.glb';

    
    // 

    debugPrint('saving $saveFileName in $defaultAssetPath from $assetDownloadUrl');
    await FlutterDownloader.enqueue(
      url: assetDownloadUrl, 
      savedDir: defaultAssetPath,
      fileName: saveFileName,
      showNotification: false,
      openFileFromNotification: false,
      headers: {}
      );
    
    setModelSrc(newSrc: '$defaultAssetPath$saveFileName');

    //'https://hypamaps-api.azurewebsites.net/viewer/model/'
    //5d8dc969-b06e-44a0-814f-e0a669fa5292
  }


  @override 
  Widget build(BuildContext context) {

    setModelSrc();

    debugPrint("returning the Flutter3DViewer with model $currentModelSrc");
    return Scaffold (
      
      appBar: AppBar (title: const Text('3D viewer demo'),),
      body: SizedBox (
        height: MediaQuery.of(context).size.height,
        //decoration: BoxDecoration(color: Colors.blue[500]),
        child: ModelViewer(
          src:currentModelSrc,
          key: ValueKey(currentModelSrc),
          backgroundColor: const Color.fromARGB(255, 20, 20, 16),
          alt: '3D Map Model',
          autoRotate: autoRotate_,
          autoRotateDelay: 2,
        ),
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: downloadMapModelFromAPI,
        tooltip: 'change 3D model',
        child: const Icon(Icons.loop),
        ),
    );     
  }
}
