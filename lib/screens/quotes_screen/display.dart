import 'package:flutter/material.dart';
import 'package:quoter/screens/quotes_screen/components/quote_list_tile.dart';
import 'package:quoter/services/auth.dart';

class DisplayQuoteList extends StatelessWidget {
  const DisplayQuoteList({
    Key? key,
    required this.itemLength,
    required this.item,
    required this.fullCategory,
    required this.auth,
  }) : super(key: key);
  final int itemLength;
  final AuthBase auth;

  final List<Map<String, dynamic>> item;
  final List<dynamic> fullCategory;
  // final List<int> categoryIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("quotes"),
            Expanded(
              child: ListView.builder(
                itemCount: itemLength,
                itemBuilder: (BuildContext context, int index) {
                  return CustomQuoteListTile(
                    quoteText: item[index]["text"],
                    author: item[index]["author"],
                    categories: item[index]["category"],
                    fullCategory: fullCategory,
                    colorIndex: 0,
                    indexOfQuote: index,
                    auth: auth,
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
