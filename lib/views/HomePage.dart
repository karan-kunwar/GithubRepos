import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CommitPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _repositories = [];

  @override
  void initState() {
    super.initState();
    _getRepositories();
  }

  Future<void> _getRepositories() async {
    final String url = 'https://api.github.com/users/freeCodeCamp/repos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _repositories = json.decode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Github Repositories'),
        ),
        body: ListView.builder(
            itemCount: _repositories.length,
            itemBuilder: (context, index){
              final repo = _repositories[index];
              return ListTile(
                title: Text(repo['name']),
                subtitle: Text(repo['description'] ?? 'No description provided'),
                trailing: Text('${repo['stargazers_count']} stars'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommitsPage(repo['name']),
                    ),
                  );
                },
              );
            }
        )

    );
  }
}
