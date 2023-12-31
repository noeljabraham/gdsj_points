// ignore: unused_import
import 'dart:ffi';
import 'package:animated_text_kit/animated_text_kit.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
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
              color: Colors.blue, // Customize the color of the wave dots
              size: 50.0, // Customize the size of the wave dots
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final body = {"secret": "onlyforgdscajce"};
  TextEditingController _searchController = TextEditingController();
  String? searchedName = "";
  List<dynamic> leaderboardData = [];
  List<dynamic> originalLeaderboardData = [];
  Map<String, int> originalRanks = {};

  bool isLoading = true; // Track the loading state

  Future fetchLeaderboardData() async {
    try {
      final response = await http.post(
        Uri.parse('https://shy-fawn-fatigues.cyclic.app/leaderboard'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        originalRanks.clear();
        for (int i = 0; i < data.length; i++) {
          originalRanks[data[i]['name']] = i + 1;
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
    } else {
      return data.where((entry) {
        final entryName = entry['name'].toLowerCase();
        return entryName.contains(name.toLowerCase());
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData().then((data) {
      setState(() {
        leaderboardData = data;
        originalLeaderboardData = leaderboardData;
        isLoading = false; // Set loading to false when data is loaded
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
                                              setState(() {
                                                _searchController.clear();
                                                searchedName = "";
                                                leaderboardData =
                                                    originalLeaderboardData;
                                              });
                                            }),
                                        hintText: 'Search by name',
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
                                      final filteredData = searchByName(
                                          originalLeaderboardData,
                                          searchedName ?? "");

                                      setState(() {
                                        leaderboardData = filteredData;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: leaderboardData.length,
                                itemBuilder: (context, index) {
                                  final entry = leaderboardData[index];
                                  final rank =
                                      originalRanks[entry['name']] ?? "";

                                  return ListTile(
                                    title: Text(
                                      'Rank: $rank - ${entry['name']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Score: ${entry['score']}',
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
                                    launchUrl(
                                      Uri.parse(
                                          'https://gdsc-ajce.github.io/home/individual.html'),
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
