import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectCreation extends StatefulWidget {
  @override
  _ProjectCreationState createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final TextEditingController _controller = TextEditingController();
  String finalUrl = '';
  Map<String, dynamic> fetchedData = {}; // A map to store the fetched JSON data

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchJsonData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        setState(() {
          fetchedData = json.decode(response.body);
        });
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load project');
      }
    } catch (e) {
      print(e); // You might want to handle the error more gracefully in a production app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Project"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Project Name',
                hintText: 'Enter your project name here',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String projectName = _controller.text.trim();
                  finalUrl = "https://stuffjoy.github.io/space-mapper-projects/$projectName.json";
                });
                fetchJsonData(finalUrl);
              },
              child: Text('Submit'),
            ),
            if (finalUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'URL: $finalUrl',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: fetchedData.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = fetchedData.keys.elementAt(index);
                  return ListTile(
                    title: Text("$key"),
                    subtitle: Text("${fetchedData[key]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
