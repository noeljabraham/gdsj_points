import 'package:flutter/material.dart';
import 'package:GCSJ/main_screen.dart';
import 'package:GCSJ/group.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.2,
                    bottom: screenHeight * 0.05,
                  ),
                  child: Center(
                    child: Text(
                      'Welcome to GCSJ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 220, 167, 10),
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Image.asset("images/supercloud.png"),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                SizedBox(
                  height: screenHeight * 0.055,
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: const Text("Individual Leaderboard"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: screenHeight * 0.055,
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: const Text("Group Leaderboard"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.25,
                    right: screenWidth * 0.1,
                    left: screenWidth * 0.1,
                  ),
                  child: Image.asset("images/gdsc.png"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
