import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quoter/screens/quotes_screen/quotes_screen.dart';
import 'package:quoter/services/auth.dart';
import 'components/input_field.dart';
import 'components/category_chip.dart';
import 'package:quoter/services/database_services.dart';
import 'package:quoter/screens/category_screen/add_category_screen.dart';
import 'components/fetch_categories.dart';

class TextRecognition extends StatefulWidget {
  final AuthBase auth;
  const TextRecognition({Key? key, required this.auth}) : super(key: key);

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  bool textScanning = false;
  List<String> dropdown_categories = [];
  String scannedText = "";
  String dropdownValue = 'Select Category';
  Map<int, String> categories = {};

  XFile? imageFile;

  TextEditingController quoteController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  void deleteCategory(int id) {
    categories.remove(id);
  }

  // Future<List<String>> addToCategoryChip() async {
  //   List<String> cats = <String>['Select Category'];
  //   await FirebaseFirestore.instance
  //       .collection("category")
  //       .doc(widget.auth.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     int length = value["totalCategory"];
  //     print(length);
  //     for (int i = 0; i < length; i++) {
  //       print(value["category"][i]);
  //       cats.add(value["category"][i]);
  //     }
  //   });
  //   return cats;
  // }

  void fetchCategories() async {
    dropdown_categories = await addToCategoryChip(widget.auth.currentUser!.uid);
    dropdownValue = dropdown_categories.first;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Quote Extract"),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuoteScreen(auth: widget.auth)))
                  },
              icon: Icon(Icons.format_quote)),
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddCategory(auth: widget.auth)))
                  },
              icon: Icon(Icons.category_outlined)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: quoteController,
                  decoration: InputDecoration(
                    labelText: "Quote",
                    border: myinputborder(), //normal border
                    enabledBorder: myinputborder(), //enabled border
                    focusedBorder: myfocusborder(),
                    //focused border
                    // set more border style like disabledBorder
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: "Author Name",
                    border: myinputborder(), //normal border
                    enabledBorder: myinputborder(), //enabled border
                    focusedBorder: myfocusborder(), //focused border
                    // set more border style like disabledBorder
                  ),
                ),
                Wrap(
                  children: categories.entries
                      .map(
                        (e) => category_chip(
                          label: e.value,
                          id: e.key,
                          deleteChip: () {
                            setState(() {
                              deleteCategory(e.key);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                // category_chip(),
                const SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.grey),
                  underline: Container(
                    height: 2,
                    color: Colors.yellowAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                      int dd_index = dropdown_categories.indexOf(dropdownValue);
                      if (dd_index > 0) {
                        dd_index--;
                        print("dd_index:: $dd_index");
                        categories.addAll({dd_index: dropdownValue.toString()});
                      }
                    });
                  },
                  items: dropdown_categories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () {
                      UserQuoteDatabaseService(
                              uid: widget.auth.currentUser!.uid)
                          .insertQuote(
                        quoteController.text.trim(),
                        authorController.text.trim(),
                        categories.keys.toList(),
                        DateTime.now(),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuoteScreen(auth: widget.auth)));
                    },
                    icon: Icon(Icons.save_rounded),
                    label: const Text(
                      "Save",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning. ${e.toString()}";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.devanagiri);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    quoteController.text = scannedText;
    setState(() {});
    textRecognizer.close();
  }
}
