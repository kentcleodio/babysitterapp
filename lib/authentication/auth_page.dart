import 'package:babysitterapp/authentication/login_page.dart';
import 'package:babysitterapp/authentication/welcome_authenticated_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //   user no logged in
          if (snapshot.hasData) {
            return BabySitterWelcomePage();
          } else {
            return BabySitterLoginPage();
          }
        },
      ),
    );
  }
}
