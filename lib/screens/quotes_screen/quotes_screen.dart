import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quoter/constant.dart';
import 'package:quoter/main.dart';
import 'package:quoter/services/auth.dart';
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
          icon: Icon(Icons.logout),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
        ),
      ),
    );
  }
}

class CustomQuoteListTile extends StatefulWidget {
  const CustomQuoteListTile({
    Key? key,
    required this.quoteText,
    required this.author,
    required this.colorIndex,
  }) : super(key: key);
  final String quoteText;
  final String author;
  final int colorIndex;

  @override
  State<CustomQuoteListTile> createState() => _CustomQuoteListTileState();
}

class _CustomQuoteListTileState extends State<CustomQuoteListTile> {
  Widget closeButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black38,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(72, 76, 82, 0.16),
              offset: Offset(0, 12),
              blurRadius: 16.0,
            )
          ],
        ),
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFFE7EEFB),
        ),
      ),
    );
  }

  void handleFullScreen(String quote, String author) {
    CustomShowDialog().showFullScreenDialog(
      context,
      false,
      0.00,
      0.95,
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Flexible(
                  child: Text(
                    "Quote App",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                closeButton(),
              ],
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(72, 76, 82, 0.16),
                      offset: Offset(0, 12),
                      blurRadius: 16.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        quote,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(author),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFF73A0F4),
                      Color(0xFF4A47F5),
                    ],
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(72, 76, 82, 0.16),
                      offset: Offset(0, 12),
                      blurRadius: 16.0,
                    )
                  ],
                ),
                height: 47.0,
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  "Ok!",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'SF Pro Text',
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.white12,
              offset: Offset(0, 5),
              blurRadius: 16.0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 7.0,
              height: size.height * 0.17,
              decoration: BoxDecoration(
                color: kBarColorSet[widget.colorIndex],
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RotationTransition(
                  turns: const AlwaysStoppedAnimation(180 / 360),
                  child: Icon(
                    Icons.format_quote,
                    color: kBarColorSet[widget.colorIndex],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.quoteText,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  widget.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // style: const TextStyle(
                  // ),
                ),
                const SizedBox(height: 5.0),
                SizedBox(
                  width: size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          CustomButtonQuoteTile(
                            onPressed: () {},
                            icon: Icons.favorite_outline_rounded,
                          ),
                          const SizedBox(width: 8.0),
                          CustomButtonQuoteTile(
                            onPressed: () {},
                            icon: Icons.share_rounded,
                          ),
                          const SizedBox(width: 8.0),
                          CustomButtonQuoteTile(
                            onPressed: () {},
                            icon: Icons.edit_rounded,
                          ),
                        ],
                      ),
                      CustomButtonQuoteTile(
                        onPressed: () =>
                            handleFullScreen(widget.quoteText, widget.author),
                        icon: Icons.fullscreen_rounded,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomButtonQuoteTile extends StatelessWidget {
  const CustomButtonQuoteTile({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);
  final Function onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Icon(
        icon,
        size: 20.0,
      ),
    );
  }
}
