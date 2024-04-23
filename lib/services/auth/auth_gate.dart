import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather/services/auth/login_or_register.dart';
import 'package:weather/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          //user is not logged in
          else {
            return const LogInOrRegister();
          }
        },
      ),
    );
  }
}
