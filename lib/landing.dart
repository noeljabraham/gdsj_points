import 'package:flutter/material.dart';
import 'package:gdsj_points/main_screen.dart';
import "package:gdsj_points/group.dart";

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Padding(
              padding: EdgeInsets.only(top: 130),
              child: Center(
                child: Text(
                  'Welcome to GDSJ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
              child: const Text("Individual Leaderboard"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          ))),
              child: const Text("Group Leaderboard"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupScreen()),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
