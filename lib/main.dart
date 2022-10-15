import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app_using_newsapi/NewsModel.dart';
import 'package:flutter_news_app_using_newsapi/api_keys.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  List<NewsModel> newsItems = [];

  Future<List<NewsModel>> getNewFromApi() async {
    var url =
        "https://newsapi.org/v2/top-headlines?pageSize=100&country=us&apiKey=${ApiKeys.newApiKey}";

    var myUri = Uri.parse(url);

    var apiResponse = await http.get(myUri);

    var statusCode = apiResponse.statusCode;

    print("Status Code: " + statusCode.toString());

    List<NewsModel> newsList = [];
    if (apiResponse.statusCode == 200) {
      var data = apiResponse.body;

      var json = jsonDecode(data);

      var tResults = json["totalResults"];

      var myArticles = json["articles"];

      // print(tResults);

      // print(myArticles);

      for (var article in myArticles) {
        var articleTitle = article["title"];

        var source = article["source"]["name"];

        NewsModel myModel = NewsModel(
            title: articleTitle,
            source: source,
            urlToImage: article["urlToImage"] ?? "");

        newsList.add(myModel);
      }

      return newsList;
    } else {
      return newsList;
    }

    // Response
    // 1- Status Code (200 - OK, 400 - Problem, 500 - Server Side Issue)
    // 2- Data (apiResponse.data)
  }

  @override
  void initState() {
    super.initState();

    getNewFromApi().then((newList) {
      setState(() {
        newsItems.addAll(newList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build Function Called!");

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: newsItems.length > 0
          ? ListView.builder(
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.network(
                      newsItems[index].urlToImage,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    ListTile(
                      title: Text(newsItems[index].title),
                    )
                  ],
                );
              },
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Loading..."),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ),
    );
  }
}
