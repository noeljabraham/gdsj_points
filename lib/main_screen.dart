import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<dynamic>> fetchLeaderboardData() async {
    try {
      final response = await http.post(
        Uri.parse('https://shy-fawn-fatigues.cyclic.app/leaderboard'),
        headers: {'Content-Type': 'application/json'},
        body: {"secret": "onlyforgdscajce"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        if (kDebugMode) {
          print('API Request Failed: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('API Response: ${response.body}');
        }
        throw Exception('Failed to load leaderboard data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception('An error occurred while fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 36, left: 16),
            child: Text(
              'GDSJ-Points',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: 400,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Your Individual Score: 42',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: fetchLeaderboardData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              } else {
                final leaderboardData = snapshot.data;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: 400,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Leaderboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: leaderboardData?.length,
                              itemBuilder: (context, index) {
                                final entry = leaderboardData?[index];
                                return ListTile(
                                  title: Text(entry['name']),
                                  subtitle: Text('Score: ${entry['score']}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
