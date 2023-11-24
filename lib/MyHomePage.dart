import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bc/Article.dart';
import 'package:bc/NewsCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apiKey = 'f459acde94124ad682b341cadc163841';
  String baseUrl = 'https://newsapi.org/v2/top-headlines';
  String category = 'general';
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    String url = '$baseUrl?category=$category&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        articles = (jsonData['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        setState(() {});
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: category,
            onChanged: (String? newValue) {
              setState(() {
                category = newValue!;
                fetchNews();
              });
            },
            items: <String>[
              'general',
              'business',
              'entertainment',
              'health',
              'science',
              'sports',
              'technology',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return NewsCard(article: articles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}