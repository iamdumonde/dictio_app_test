import 'dart:convert';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String word;

  const ResultScreen({super.key, required this.word});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<Map<String, dynamic>>? _futureWordData;

  @override
  void initState() {
    super.initState();
    _futureWordData = _fetchWordData(widget.word);
  }

  Future<Map<String, dynamic>> _fetchWordData(String word) async {
    var http;
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0];
    } else {
      throw Exception("Failed to load Word data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureWordData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Nothing Found"),
            );
          } else {
            final wordData = snapshot.data!;
            final List meanings = wordData['meanings'] ?? [];
            return ListView.builder(
              itemCount: meanings.length,
              itemBuilder: (context, index) {
                final meaning = meanings[index];
                final String partsOfSpeech = meaning['partOfSpeech'] ?? '';
                final List definations = meaning['definitions'] ?? '';
                final List synonyms = meaning['synonyms'] ?? '';
                final List antonyms = meaning['antonyms'] ?? '';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partsOfSpeech,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (definations.isNotEmpty)
                            ...definations.map((defination) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    defination['definition'] ?? '',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  if (defination['example'] != null)
                                    Text(
                                      "Example: ${defination['example']}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                ],
                              );
                            }).toList(),
                          if (synonyms.isNotEmpty)
                            Text(
                              "Synonyms : ${synonyms.join(", ")}",
                              style: TextStyle(color: Colors.green),
                            ),
                          if (antonyms.isNotEmpty)
                            Text(
                              "Antonyms : ${antonyms.join(", ")}",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Test on real device, emulator may show and give not correct result
