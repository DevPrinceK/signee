// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:signee/data/sharing.dart';

class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  List<Map<String, dynamic>> signatures = [];

  void _showDetails(name, sign, date, id, isFavourite) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Center(child: Text(name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(sign, height: 300, width: 300),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.purple[700],
                      size: 40,
                    ),
                    onPressed: () async {
                      bool res = await shareImage(sign);
                      if (res) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Image Shared')),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Image Not Shared')),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () {
                      addFavorite(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void addFavorite(id) {
    // add to favorites
    var mybox = Hive.box('signee_db');
    var signatures = mybox.get('signatures').toList();
    signatures[id]['favourite'] = true;
    mybox.put('signatures', signatures);

    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Added to Favorites')),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );

    Navigator.of(context).pop();
  }

  void getSignatures() {
    var mybox = Hive.box('signee_db');
    List<dynamic> rawSignatures = mybox.get('signatures', defaultValue: []);

    List<Map<String, dynamic>> convertedSignatures = [];

    for (dynamic rawSignature in rawSignatures) {
      if (rawSignature is Map<String, dynamic>) {
        convertedSignatures.add(rawSignature);
      } else {
        // Handle the case where the signature is not in the expected format

        // convert the signature to the expected format
        convertedSignatures.add(rawSignature.cast<String, dynamic>());
      }
    }

    setState(() {
      signatures = convertedSignatures;
    });
  }

  void deleteSignature(int index) {
    var mybox = Hive.box('signee_db');
    signatures.removeAt(index);
    mybox.put('signatures', signatures);
    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Signature Deleted')),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );
    getSignatures();
  }

  @override
  void initState() {
    super.initState();
    getSignatures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signatures'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.purple[200],
      ),
      body: signatures.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.grey,
                  ),
                  Text(
                    "No Signatures",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Signatures:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: signatures.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _showDetails(
                              signatures[index]['name'],
                              signatures[index]['signature'] as Uint8List,
                              signatures[index]['date'],
                              index,
                              signatures[index]['favourite'],
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.memory(
                                          signatures[index]['signature']
                                              as Uint8List,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${signatures[index]['name']}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${signatures[index]['date']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        onPressed: () {
                                          deleteSignature(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
