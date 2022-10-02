import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quoter/screens/quotes_screen/quotes_screen.dart';
import 'package:quoter/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoter',
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      // home: const TextRecognition(),
      // home: const QuoteScreen(),
      home: Scaffold(
        body: Wrapper(
          auth: Auth(),
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // Not logged in
            return Center(
              child: MaterialButton(
                onPressed: () {
                  try {
                    auth.signInWithGoogle();
                  } catch (e) {
                    print("ERROR $e");
                  }
                },
                color: Colors.greenAccent,
                child: Text("Google Login"),
              ),
            );
          } else {
            return QuoteScreen(
              auth: auth,
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
