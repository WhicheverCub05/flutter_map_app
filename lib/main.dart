import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 81, 157, 227),
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
    return Scaffold(
      
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueGrey[400],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
        
          // TRY THIS: Invoke "debug painting" : p 
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // const ModelViewer(
            //   src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
            //   alt: 'Test model',
            //   ar: true,
            //   autoRotate: true,
            //   iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
            //   // https://pub.dev/packages/model_viewer_plus#pubspecyaml
            //   ),
          ],
        ),
      ),
      
      backgroundColor: Colors.grey[800],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
