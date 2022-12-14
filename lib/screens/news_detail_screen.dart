import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatefulWidget {
  final article;
  final articleKey;

  const NewsDetailsScreen({super.key, this.article, this.articleKey});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isReadLater = false;

  @override
  void initState() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("/read_later_news/")
        .child(currentUser!.uid)
        .child(widget.articleKey)
        .get()
        .then((response) {
      if (response.value != null) {
        setState(() {
          isReadLater = true;
        });
      } else {
        setState(() {
          isReadLater = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: Column(
        children: [
          Image.network(
            widget.article['urlToImage'] ?? "",
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
          SizedBox(
            height: 18,
          ),
          ListTile(
            title: Text(
              widget.article['title'] ?? "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    final newsObject = widget.article;

                    User? currentUser = FirebaseAuth.instance.currentUser;

                    // check if user has already favorited this article

                    if (isReadLater) {
                      await FirebaseDatabase.instance
                          .ref()
                          .child("/read_later_news/")
                          .child(currentUser!.uid)
                          .child(widget.articleKey)
                          .remove();

                      setState(() {
                        isReadLater = false;
                      });
                    } else {
                      await FirebaseDatabase.instance
                          .ref()
                          .child("/read_later_news/")
                          .child(currentUser!.uid)
                          .child(widget.articleKey)
                          .set(newsObject);

                      setState(() {
                        isReadLater = true;
                      });
                    }
                  },
                  icon: Icon(
                      isReadLater ? Icons.bookmark : Icons.bookmark_border),
                ),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Share.share(widget.article['url'] ?? "");
                    },
                    icon: Icon(Icons.adaptive.share)),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse(widget.article['url']));
                    },
                    icon: Icon(Icons.open_in_browser)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.article['content'] ?? "",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
