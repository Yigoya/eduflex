import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/service/dbservice.dart';
import 'package:eduflex/state/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

DBservice dBservice = DBservice.instance;
void main() async {
  // runApp(ChangeNotifierProvider(
  //   create: (context) => MyProvider(),
  //   child: MyApp(),
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await dBservice.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeChanger(),
        builder: (context, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: Provider.of<ThemeChanger>(context).theme,
            home: AuthGate(),
          );
        });
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscribtion;
//   bool isConnected = true;
//   @override
//   void initState() {
//     super.initState();
//     _connectivitySubscribtion =
//         _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       setState(() {
//         isConnected = (result != ConnectivityResult.none);
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _connectivitySubscribtion.cancel();
//     super.dispose();
//   }

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   void fetchData() async {
//     Dio dio = Dio();

//     try {
//       // Make a GET request to a URL
//       Response response = await dio.get('http://127.0.0.1:8000/api');
//       print(response.data);
//     } catch (e) {
//       // Handle errors
//       print('Error: $e');
//     }
//   }

//   // Future<void> saveFile(String fileName, String content) async {
//   //   try {
//   //     // Get the application documents directory
//   //     Directory appDocumentsDirectory =
//   //         await getApplicationDocumentsDirectory();
//   //     String appDocumentsPath = appDocumentsDirectory.path;

//   //     // Combine the directory path with the file name
//   //     String filePath = '$appDocumentsPath/$fileName';

//   //     // Write the content to the file
//   //     File file = File(filePath);
//   //     await file.writeAsString(content);

//   //     print('File saved successfully at: $filePath');
//   //   } catch (e) {
//   //     print('Error saving file: $e');
//   //   }
//   // }

//   Future<void> _requestPermission() async {
//     if (await Permission.storage.request().isGranted) {
//       print('Permission granded');
//     } else {
//       // Permission denied, handle accordingly
//       print('Permission denied');
//     }
//   }

//   Future<void> _saveFile(String fileName, List<int> bytes) async {
//     try {
//       Directory appDocumentsDirectory =
//           await getApplicationDocumentsDirectory();
//       String appDocumentsPath = appDocumentsDirectory.path;
//       String filePath = '$appDocumentsPath/$fileName';

//       File file = File(filePath);
//       await file.writeAsBytes(bytes);

//       print('File saved successfully at: $filePath');
//     } catch (e) {
//       print('Error saving file: $e');
//     }
//   }

//   Future<Widget> _buildImage(String fileName) async {
//     Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
//     String appDocumentsPath = appDocumentsDirectory.path;
//     return Image.file(File('$appDocumentsPath/$fileName'),
//         width: 200, height: 200);
//   }

//   Future<String?> readFile(String fileName) async {
//     try {
//       // Get the application documents directory
//       Directory appDocumentsDirectory =
//           await getApplicationDocumentsDirectory();
//       String appDocumentsPath = appDocumentsDirectory.path;

//       // Combine the directory path with the file name
//       String filePath = '$appDocumentsPath/$fileName';

//       // Read the content of the file
//       File file = File(filePath);

//       // Check if the file exists
//       if (await file.exists()) {
//         String content = await file.readAsString();
//         print('File content: $content');
//         return content;
//       } else {
//         print('File not found.');
//         return null;
//       }
//     } catch (e) {
//       print('Error reading file: $e');
//       return null;
//     }
//   }

//   File? _selectedImage;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   // Widget _buildImage() {
//   //   return _selectedImage != null
//   //       ? Image.file(_selectedImage!, width: 200, height: 200)
//   //       : Container(
//   //           child: Text("no txt"),
//   //         ); // You can replace this with a placeholder or some default content
//   // }

//   Future<void> accessDownloadsDirectory() async {
//     Directory? downloadsDirectory = await getDownloadsDirectory();

//     if (downloadsDirectory != null) {
//       print("Downloads Directory: ${downloadsDirectory.path}");
//       List<FileSystemEntity> files = downloadsDirectory.listSync();
//       for (var file in files) {
//         print("File: ${file.path}");
//       }
//     } else {
//       print("Downloads directory not available on this platform.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: isConnected
//                   ? Text('Internet is active')
//                   : Text('No internet connection'),
//             ),
//             // _buildImage(),
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // _pickImage();
//           // await saveFile('example.txt', 'Hello, Flutter!');
//           // String? content = await readFile('example.txt');
//           // if (content != null) {
//           //   // Do something with the file content
//           // } else {
//           //   // Handle the case where the file doesn't exist
//           // }
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
