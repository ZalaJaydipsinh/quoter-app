import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quoter/constant.dart';
import 'package:quoter/screens/quotes_screen/components/quote_list_tile.dart';
import 'package:quoter/screens/quotes_screen/display.dart';
import 'package:quoter/services/auth.dart';
import 'package:quoter/services/category_service.dart';
import 'package:quoter/services/database_services.dart';
import 'package:quoter/widget/custom_dialog.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late UserQuoteDatabaseService userQuoteDatabaseService;
  List<String> allTextCategory = [];
  List fetchdata = [];
  void getOwnProjectDetails() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      fetchdata = snapshot.data()!['quote'];
      fetchdata.map((e) => print('e printed: ${e['text']}'));
      // print("qutoes: $fetchdata");
    });
  }

  @override
  void initState() {
    userQuoteDatabaseService =
        UserQuoteDatabaseService(uid: widget.auth.currentUser!.uid);
    // CategoryService().insertCategory("Zala");
    getOwnProjectDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            try {
              await widget.auth.signOut();
            } catch (e) {
              print(e);
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.auth.currentUser!.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.data == null) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      Text(
                        "Fetching Data...",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              }

              final DocumentSnapshot document =
                  snapshot.data as DocumentSnapshot;

              final Map<String, dynamic> documentData =
                  document.data() as Map<String, dynamic>;

              List checkingForEmptyList = documentData['quote'];
              if (documentData['quote'] == null ||
                  checkingForEmptyList.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "No Quotes Available...",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              }

              final List<Map<String, dynamic>> itemDetailList =
                  (documentData['quote'] as List)
                      .map((itemDetail) => itemDetail as Map<String, dynamic>)
                      .toList();
              var itemDetailsListReversed = itemDetailList.reversed.toList();

              fetchDataAndNavigate(int length) {
                FirebaseFirestore.instance
                    .collection("category")
                    .doc(widget.auth.currentUser!.uid)
                    .get()
                    .then((value) {
                  final length = value["totalCategory"];
                  final fullCategory = value["category"];
                  //TODO: Navigate From here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayQuoteList(
                          itemLength: itemDetailsListReversed.length,
                          item: itemDetailsListReversed,
                          fullCategory: fullCategory,
                          auth: widget.auth),
                    ),
                  );
                });
                // print(allTextCategory);
                // return CustomQuoteListTile(
                //   quoteText: text,
                //   author: author,
                //   colorIndex: 0,
                // );
              }

              fetchDataAndNavigate(itemDetailsListReversed.length);
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
