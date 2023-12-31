import 'package:animated_text_kit/animated_text_kit.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCubeGrid(
              color: Colors.blue, // Customize the color of the cube grid
              size: 50.0, // Customize the size of the cube grid
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final body = {"secret": "onlyforgdscajce"};
  TextEditingController _searchController = TextEditingController();
  String? searchedName;
  List<dynamic> groupScores = [];
  List<dynamic> originalLeaderboardData = [];
  Map<String, int> originalRanks = {}; // Map to store original ranks of groups

  bool isLoading = true;

  Future fetchGroupScores() async {
    try {
      final response = await http.post(
        Uri.parse('https://shy-fawn-fatigues.cyclic.app/group-scores'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Store the original ranks in the map
        originalRanks.clear();
        for (int i = 0; i < data.length; i++) {
          originalRanks[data[i]['group']] = i + 1;
        }

        return data;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return e;
    }
  }

  List<dynamic> searchByName(List<dynamic> data, String name) {
    if (name.isEmpty) {
      return data;
    }

    return data.where((entry) {
      final groupName = entry?['group'] ?? '';
      return groupName.toLowerCase().contains(name.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchGroupScores().then((data) {
      setState(() {
        groupScores = data;
        originalLeaderboardData = groupScores;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? LoadingScreen()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.05,
                      ),
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
                                    fontSize: screenWidth * 0.037,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Colors.blue)),
                            RotateAnimatedText(
                                'Generative AI Arcade Game\nDeadline: 30th September, 2023, 5pm',
                                duration: const Duration(milliseconds: 4000),
                                textStyle: TextStyle(
                                    fontSize: screenWidth * 0.037,
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
                      padding: EdgeInsets.all(screenWidth * 0.04),
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
                              'Group Leaderboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            // Update the UI with the filtered data
                                            setState(() {
                                              _searchController.clear();
                                              searchedName = "";
                                              groupScores =
                                                  originalLeaderboardData;
                                            });
                                          },
                                        ),
                                        hintText:
                                            'Search by group name', // Change hint text
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchedName = value;
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      // Call the search function to filter the groupScores
                                      final filteredData = searchByName(
                                          originalLeaderboardData,
                                          searchedName ?? "");

                                      // Update the UI with the filtered data
                                      setState(() {
                                        groupScores = filteredData;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: groupScores.length,
                                itemBuilder: (context, index) {
                                  final entry = groupScores[index];
                                  final rank =
                                      originalRanks[entry?['group'] ?? ""] ??
                                          "";

                                  return ListTile(
                                    title: Text(
                                      'Rank: $rank - ${entry?['group'] ?? ""}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Score: ${entry?['score'] ?? ""}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the https://gdsc-ajce.github.io/home/group.html page
                                    launchUrl(
                                      Uri.parse(
                                          'https://gdsc-ajce.github.io/home/group.html'),
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(Icons.public),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
