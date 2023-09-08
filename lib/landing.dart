import 'package:flutter/material.dart';
import 'package:GCSJ/main_screen.dart';
import "package:GCSJ/group.dart";

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
          Padding(
              padding: EdgeInsets.only(top: 70, right: 40, left: 40),
              child: Image.asset("images/gdsc.png")),
          
          const Padding(
              padding: EdgeInsets.only(top: 90, bottom: 50),
              child: Center(
                child: Text(
                  'Welcome to GCSJ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 220, 167, 10),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Image.asset("images/supercloud.png"),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
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
