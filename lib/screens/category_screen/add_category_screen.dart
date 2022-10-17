import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quoter/screens/quotes_screen/quotes_screen.dart';
import 'package:quoter/services/auth.dart';
import 'components/input_field.dart';
import 'components/category_chip.dart';
import 'package:quoter/services/category_service.dart';
import 'package:quoter/services/database_services.dart';

class AddCategory extends StatefulWidget {
  final AuthBase auth;
  const AddCategory({Key? key, required this.auth}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  List<String> dropdown_categories = <String>['Select Category'];

  String? dropdownValue;
  int dropdownIndex = 0;
  // Map<int, String> categories = {};

  XFile? imageFile;

  TextEditingController categoryController = TextEditingController();
  // void deleteCategory(int id) {
  //   categories.remove(id);
  // }

  void addToCategoryChip() async {
    dropdown_categories = [];
    dropdown_categories.clear();
    dropdown_categories.add("Select Category");
    dropdownValue = dropdown_categories.first;
    await FirebaseFirestore.instance
        .collection("category")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((value) {
      int length = value["totalCategory"];
      // print(length);
      for (int i = 0; i < length; i++) {
        // print(value["category"][i]);
        dropdown_categories.add(value["category"][i]);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    addToCategoryChip();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Category"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    border: myinputborder(), //normal border
                    enabledBorder: myinputborder(), //enabled border
                    focusedBorder: myfocusborder(), //focused border
                    // set more border style like disabledBorder
                  ),
                ),
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
                      categoryController.text = value;
                      int dd_index =
                          dropdown_categories.indexOf(dropdownValue!);
                      if (dd_index > 0) {
                        dd_index--;
                        dropdownIndex = dd_index;
                        print("dd_index:: $dd_index");
                        // categories.addAll({dd_index: dropdownValue.toString()});
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
                      CategoryService(uid: widget.auth.currentUser!.uid)
                          .insertCategory(categoryController.text);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.add_rounded),
                    label: const Text(
                      "Add Category",
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () async {
                      List<String> updatedCategories = [];
                      updatedCategories.addAll(dropdown_categories);
                      updatedCategories.removeAt(0);
                      updatedCategories[dropdownIndex] =
                          categoryController.text;

                      await CategoryService(uid: widget.auth.currentUser!.uid)
                          .updateCategory(updatedCategories);
                      // Navigator.pop(context);
                      addToCategoryChip();
                    },
                    icon: Icon(Icons.update_rounded),
                    label: const Text(
                      "Update",
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () {
                      CategoryService(uid: widget.auth.currentUser!.uid)
                          .insertDummyCategory();
                    },
                    icon: Icon(Icons.update_rounded),
                    label: const Text(
                      "Insert Dummy category",
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
}
