import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBsH3nQcp5HsBYUtr_lsZEbP0SELoEv-4U",
          authDomain: "laundry-tracking-44be5.firebaseapp.com",
          projectId: "laundry-tracking-44be5",
          storageBucket: "laundry-tracking-44be5.appspot.com",
          messagingSenderId: "96292080853",
          appId: "1:96292080853:web:3f4bd92721dfe45059265c",
          measurementId: "G-186M3HBPGS"
      )
  ); // Initialize Firebase
  runApp(const MyApp()); // Replace MyApp() with your main widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Laundry Management System',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent[700],
          elevation: 2,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  List<Map<String, dynamic>> collectionData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCollectionData();
  }

  Future<void> fetchCollectionData() async {
    try {
      List<Map<String, dynamic>> data = await _firebaseServices.getCollectionData('Predictions');
      setState(() {
        collectionData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching collection data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    await fetchCollectionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Laundry Management System"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : collectionData.isNotEmpty
          ? ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: collectionData.length,
          itemBuilder: (context, index) {
            final doc = collectionData[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  'Machine ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: doc.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          })
          : const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      ),
    );
  }
}
