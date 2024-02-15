// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:signature/signature.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List signatures = [];
  String name = '';
  SignatureController controller = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportBackgroundColor: Colors.white,
  );
  TextEditingController nameController = TextEditingController();

  void _showNameDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text("Add a name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                saveSignature();
              },
              child: const Text('Save Signature'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void saveSignature() async {
    if (controller.isEmpty || nameController.text.isEmpty) {
      Navigator.pop(context);
      // snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Signature or name is empty')),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }
    var mybox = Hive.box('signee_db');
    var imgbyt = await controller.toPngBytes();
    var signature = {
      'name': nameController.text,
      'signature': imgbyt,
      'favourite': false,
      'date': DateTime.now().toString(),
    };
    signatures.add(signature);
    mybox.put('signatures', signatures);
    // remove dialog
    Navigator.pop(context);
    // clear signature
    controller.clear();
    nameController.clear();
    // snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Signature Saved')),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );
    return;
  }

  @override
  void initState() {
    super.initState();

    // get signatures from hive
    var mybox = Hive.box('signee_db');
    signatures = mybox.get('signatures', defaultValue: []);
    var _name = mybox.get('name', defaultValue: '');
    for (var sign in signatures) {
      print(sign['name']);
      print(sign['favourite']);
    }
    setState(() {
      signatures = signatures;
      name = _name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signee'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              const Text(
                'Welcome to Signee!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[100],
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Signature(
                      height: MediaQuery.of(context).size.height * 0.5 - 10,
                      width: MediaQuery.of(context).size.width * 0.9,
                      controller: controller,
                      backgroundColor: Colors.purple[100]!,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5 - 10,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[500],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        _showNameDialog();
                      },
                      child: const Text(
                        'Save Signature',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5 - 10,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        controller.clear();
                      },
                      child: const Text(
                        'Clear Signature',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[500],
        shape: const CircleBorder(),
        onPressed: () {
          _showNameDialog();
        },
        child: Icon(
          Icons.share,
          color: Colors.purple[100],
        ),
      ),
    );
  }
}