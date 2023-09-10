import 'dart:ffi';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchLeaderboardData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                width: screenWidth,
                height: screenHeight,
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              final leaderboardData = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.05),
                      child: Text(
                        'GCSJ Leaderboard',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(
                                'Google Cloud Computing Foundations\nDeadline: 2nd Oct, 2023, 10:30 pm',
                                duration: const Duration(milliseconds: 4000),
                                textStyle: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Colors.blue)),
                            RotateAnimatedText(
                                'Generative AI Arcade Game\nDeadline: 30th September, 2023, 5pm',
                                duration: const Duration(milliseconds: 4000),
                                textStyle: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                          isRepeatingAnimation: true,
                          repeatForever: true,
                          pause: const Duration(milliseconds: 800),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.04,
                        screenHeight * 0.01,
                        screenWidth * 0.04,
                        screenHeight * 0.01,
                      ),
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.66,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          children: [
                            Text(
                              'Individual Leaderboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
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
