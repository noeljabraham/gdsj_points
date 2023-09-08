import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  // String secret = "onlyforgdscajce";
  final body = {"secret": "onlyforgdscajce"};

  Future fetchGroupScores() async {
    try {
      final response = await http.post(
        Uri.parse('https://shy-fawn-fatigues.cyclic.app/group-scores'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Padding(
                padding: EdgeInsets.only(top: 36, bottom: 15),
                child: Text(
                  'Group Leaderboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),),
              FutureBuilder(
                future: fetchGroupScores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        alignment: Alignment.center,
                        width: 400,
                        height: 550,
                        child: const CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    final groupScores = snapshot.data;

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 400,
                          height: 550,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Group Leaderboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: groupScores?.length,
                                  itemBuilder: (context, index) {
                                    final entry = groupScores?[index];
                                    return ListTile(
                                      title: Text(entry?['group'] ?? ''),
                                      subtitle: Text(
                                          'Score: ${entry?['score'] ?? ''}'),
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
        ));
  }
}
