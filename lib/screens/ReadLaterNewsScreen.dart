import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_news_app_using_newsapi/screens/news_detail_screen.dart';
import 'package:flutterfire_ui/database.dart';

class ReadLaterNewsScreen extends StatefulWidget {
  const ReadLaterNewsScreen({super.key});

  @override
  State<ReadLaterNewsScreen> createState() => _ReadLaterNewsScreenState();
}

class _ReadLaterNewsScreenState extends State<ReadLaterNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseDatabaseListView(
          query: FirebaseDatabase.instance
              .ref()
              .child('read_later_news')
              .child(FirebaseAuth.instance.currentUser!.uid),
          itemBuilder: (context, dataSnapshot) {
            final Map<dynamic, dynamic> article =
                dataSnapshot.value as Map<dynamic, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailsScreen(
                      article: article,
                      articleKey: dataSnapshot.key,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    article['urlToImage'] ?? "",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(article['title'] ?? ""),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
