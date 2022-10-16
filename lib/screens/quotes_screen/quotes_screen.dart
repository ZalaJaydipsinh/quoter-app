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
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              try {
                // userQuoteDatabaseService.insertQuote(
                //     "Don't talk show me your code!",
                //     "Jay Chauhan",
                //     ["Coding"],
                //     DateTime.now());

              } catch (e) {
                print("ERROR: $e");
              }
            },
            icon: Icon(Icons.add),
          )
        ],
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
              var itemDetailsListReversed = itemDetailList.toList();

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
                          // categoryIndex: category,
                          fullCategory: fullCategory,
                          auth: widget.auth),
                    ),
                  );
                });
                print(allTextCategory);
                // return CustomQuoteListTile(
                //   quoteText: text,
                //   author: author,
                //   colorIndex: 0,
                // );
              }

              fetchDataAndNavigate(itemDetailsListReversed.length);
              return Container();
              // return Expanded(
              //   child: ListView.builder(
              //     itemCount: itemDetailsListReversed.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return _buildListTileHere(index);
              //     },
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}


/* child: ListView(
          physics: const BouncingScrollPhysics(),
          children: const <Widget>[
            CustomQuoteListTile(
              quoteText:
                  "The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children.",
              author: "Jaydipsinh Zala",
              colorIndex: 0,
            ),
            CustomQuoteListTile(
              quoteText:
                  "The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children.",
              author: "Jaydipsinh Zala",
              colorIndex: 1,
            ),
            CustomQuoteListTile(
              quoteText:
                  "The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children.",
              author: "Jaydipsinh Zala",
              colorIndex: 2,
            ),
            CustomQuoteListTile(
              quoteText:
                  "The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children.",
              author: "Jaydipsinh Zala",
              colorIndex: 3,
            ),
            CustomQuoteListTile(
              quoteText:
                  "The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children. The law of love could ne nest understand and learned through little children.",
              author: "Jaydipsinh Zala",
              colorIndex: 4,
            ),
          ],
        ), */