import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_news_app_using_newsapi/screens/news_detail_screen.dart';
import 'package:flutterfire_ui/database.dart';

class NewsListRtdb extends StatelessWidget {
  NewsListRtdb({super.key});

  final query = FirebaseDatabase.instance.ref().child('news/articles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseDatabaseListView(
        query: query,
        pageSize: 50,
        itemBuilder: (context, dataSnapshot) {
          final Map<dynamic, dynamic> article =
              dataSnapshot.value as Map<dynamic, dynamic>;

          User? currentUser = FirebaseAuth.instance.currentUser;

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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey,
                    );
                  },
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
        },
      ),
    );
  }
}
