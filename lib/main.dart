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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
    print("Entered intistate");
    super.initState();
    fetchCollectionData();
  }

  // Function to fetch all documents from a Firestore collection
  Future<void> fetchCollectionData() async {
    try {
      print("fetchCollectionData run ho gaya Step 2");
      // Replace 'yourCollectionPath' with the path of your Firestore collection
      List<Map<String, dynamic>> data =
          await _firebaseServices.getCollectionData('Predictions');
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

  // Function to refresh data from the collection
  Future<void> refreshData() async {
    await fetchCollectionData(); // Call fetch function to refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello Hello"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : collectionData.isNotEmpty
              ? ListView.builder(
                  itemCount: collectionData.length,
                  itemBuilder: (context, index) {
                    final doc = collectionData[index];
                    return Column(
                      children: [
                        TextButton(
                          child: Text("Refresh"),
                          onPressed: refreshData,
                        ),
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('Document ${index + 1}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: doc.entries.map((entry) {
                                return Text('${entry.key}: ${entry.value}');
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
              : const Center(
                  child: Text(
                    'Error Displaying Data',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
    );
  }
}

