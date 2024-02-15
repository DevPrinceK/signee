// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarsScreen extends StatefulWidget {
  const BookmarsScreen({super.key});

  @override
  State<BookmarsScreen> createState() => _BookmarsScreenState();
}

class _BookmarsScreenState extends State<BookmarsScreen> {
  List favSigns = [];

  void getFavSigns() async {
    // get the list of favourite favSigns
    var mybox = Hive.box('signee_db');
    List signs = mybox.get('signatures', defaultValue: []);
    List filteredSigns =
        signs.where((element) => element['favourite'] == true).toList();
    setState(() {
      favSigns = filteredSigns;
    });
    print(favSigns);
  }

  void _showDetails(name, sign, date, id, isFavourite) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(name),
          content: Image.memory(sign, height: 300, width: 300),
          actions: [
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.purple[700],
                size: 40,
              ),
              onPressed: () {},
            ),
            // const Spacer(),
            IconButton(
              icon: Icon(
                isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // const Spacer(),
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
        );
      },
    );
  }

  void deleteFav(int index) {
    var mybox = Hive.box('signee_db');
    var signatures = mybox.get('signatures').toList();
    signatures[index]['favourite'] = false;
    mybox.put('signatures', signatures);
    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Fav Signature Removed')),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );
    getFavSigns();
  }

  @override
  void initState() {
    super.initState();
    getFavSigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.purple[200],
      ),
      body: favSigns.isEmpty
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
                    "No Favourite Signatures",
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
                    "Your Favourite Signatures:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: favSigns.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _showDetails(
                              favSigns[index]['name'],
                              favSigns[index]['signature'] as Uint8List,
                              favSigns[index]['date'],
                              index,
                              favSigns[index]['favourite'],
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
                                          favSigns[index]['signature']
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
                                            "${favSigns[index]['name']}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${favSigns[index]['date']}",
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
                                          deleteFav(index);
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
