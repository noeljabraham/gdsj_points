import 'dart:ffi';
import 'package:animated_text_kit/animated_text_kit.dart';
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
  // String secret = "onlyforgdscajce";
  final body = {"secret": "onlyforgdscajce"};

  Future fetchLeaderboardData() async {
    try {
      final response = await http.post(
        Uri.parse('https://shy-fawn-fatigues.cyclic.app/leaderboard'),
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
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://shy-fawn-fatigues.cyclic.app/leaderboard'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: {"secret": secret},
    //   );

    //   if (response.statusCode == 200) {
    //     final List<dynamic> data = json.decode(response.body);
    //     return data;
    //   } else {
    //     if (kDebugMode) {
    //       print('API Request Failed: ${response.statusCode}');
    //     }
    //     if (kDebugMode) {
    //       print('API Response: ${response.body}');
    //     }
    //     throw Exception('Failed to load leaderboard data');
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error: $e');
    //   }
    //   throw Exception('An error occurred while fetching data');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchLeaderboardData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              final leaderboardData = snapshot.data;
              // dynamic indScore = leaderboardData[0]['score'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 36),
                      child: Text(
                        'Individual Leaderboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(
                                'Google Cloud Computing Foundations\nDeadline: 2nd Oct, 2023, 10:30 pm',
                                duration: Duration(milliseconds: 4000),
                                textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Colors.blue)),
                            RotateAnimatedText(
                                'Generative AI Arcade Game\nDeadline: 30th September, 2023, 5pm',
                                duration: Duration(milliseconds: 4000),
                                textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                          isRepeatingAnimation: true,
                          repeatForever: true,
                          
                          pause: Duration(milliseconds: 800),
                        ),

                        // child: Text(
                        //   "Google Cloud Computing Foundations Deadline: 2nd Oct, 2023, 10:30 pm IST\nGenerative AI Arcade Game Deadline:30th September, 2023, 5pm IST",
                        //   // 'Your Individual Score: $indScore',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 15,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Container(
                        width: 400,
                        height: 450,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Individual Leaderboard',
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
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
