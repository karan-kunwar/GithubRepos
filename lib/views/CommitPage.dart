import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommitsPage extends StatefulWidget {
  final String repoName;

  CommitsPage(this.repoName, {super.key});

  @override
  _CommitsPageState createState() => _CommitsPageState();
}

class _CommitsPageState extends State<CommitsPage> {
  List<dynamic> _commits = [];

  @override
  void initState() {
    super.initState();
    _getCommits();
  }

  Future<void> _getCommits() async {
    final String url =
        'https://api.github.com/repos/freeCodeCamp/${widget.repoName}/commits';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _commits = json.decode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName} Commits'),
      ),
      body: ListView.builder(
        itemCount: _commits.length,
        itemBuilder: (context, index) {
          final commit = _commits[index];
          final author = commit['commit']['author']['name'];
          final message = commit['commit']['message'];
          final date = commit['commit']['author']['date'];
          return ListTile(
            title: Text(message),
            subtitle: Text('Committed by $author'),
            trailing: Text(date),
          );
        },
      ),
    );
  }
}