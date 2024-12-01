
import 'package:flutter/material.dart';
import 'database_helper.dart';

class SavedReposScreen extends StatelessWidget {
  const SavedReposScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchSavedRepos() async {
    return await DatabaseHelper.instance.getRepos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Repos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSavedRepos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved repos found.'));
          } else {
            return Column(
              children: [
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(child: Text('Avatar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(child: Text('Repo Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(child: Text('Node ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final repo = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.network(
                                  repo['avatar_url'] ?? '',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    repo['name'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    repo['node_id'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

