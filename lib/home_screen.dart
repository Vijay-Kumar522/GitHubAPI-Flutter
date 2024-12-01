import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_helper.dart';
import 'saved_repos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> fetchAndSaveRepos(BuildContext context) async {
    final url = Uri.parse('https://api.github.com/users/mralexgray/repos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> repos = json.decode(response.body);
      for (var repo in repos) {
        await DatabaseHelper.instance.insertRepo(
          {
            'node_id': repo['node_id'],
            'name': repo['name'],
            'avatar_url': repo['owner']['avatar_url'],
          },
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repos saved successfully!')),
      );
    } else {
      throw Exception('Failed to load repos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('GitHub Repos', style: TextStyle( fontWeight: FontWeight.bold))
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => fetchAndSaveRepos(context),
              child: const Text('Fetch and Save Repos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedReposScreen(),
                  ),
                );
              },
              child: const Text('View Saved Repos',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
