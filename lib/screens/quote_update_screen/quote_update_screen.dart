import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quoter/services/auth.dart';
import 'components/input_field.dart';
import 'package:quoter/services/database_services.dart';
import 'components/category_chip.dart';

class UpdateQuote extends StatefulWidget {
  final AuthBase auth;
  const UpdateQuote({Key? key, required this.auth}) : super(key: key);

  @override
  State<UpdateQuote> createState() => _UpdateQuoteState();
}

List<String> dropdown_categories = <String>['Select Category'];

class _UpdateQuoteState extends State<UpdateQuote> {
  TextEditingController quoteController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  String dropdownValue = dropdown_categories.first;
  Map<int, String> categories = {};

  void deleteCategory(int id) {
    categories.remove(id);
  }

  void addToCategoryChip() {
    FirebaseFirestore.instance
        .collection("category")
        .doc("allCategory")
        .get()
        .then((value) {
      int length = value["totalCategory"];
      print(length);
      for (int i = 0; i < length; i++) {
        print(value["category"][i]);
        print("Hello");
        dropdown_categories.add(value["category"][i]);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    addToCategoryChip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Quote Update"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      int dd_index = dropdown_categories.indexOf(value);
                      if (dd_index > 0) {
                        categories.addAll({dd_index: value.toString()});
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
}
