import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_news_app_using_newsapi/screens/home_screen.dart';
import 'package:flutter_news_app_using_newsapi/screens/home_screen_new.dart';
import 'package:flutter_news_app_using_newsapi/screens/news_list_rtdb.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                clientId:
                    "200592454522-5veu1eav63890oennqobe6j4aal4s3ke.apps.googleusercontent.com",
              ),
            ],
          );
        } else {
          return HomeScreenNew();
        }
      },
    );
  }
}
