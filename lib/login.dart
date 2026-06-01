import 'package:demo_fireman/components/arvore.dart';
import 'package:demo_fireman/game.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/nuvem2.png", height: 70),
                  Image.asset("assets/nuvem2.png", height: 70),
                ],
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> Game()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 194, 14, 2),
                        const Color.fromARGB(255, 207, 101, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Text(
                    "PLAY",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.volume_up_sharp, size: 25, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.settings, size: 25, color: Colors.white),
                ],
              ),
              Container(
                width: double.maxFinite,
                color: Colors.grey,
                height: 25,
              ),
              Container(
                width: double.maxFinite,
                color: Colors.brown,
                height: 60,
              ),
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            bottom: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Arvore(), Arvore()],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            bottom: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/poste.png", height: 200),
                Image.asset("assets/poste.png", height: 200),
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            child: Image.asset("assets/nome_app.png", height: 150),
          ),
        ],
      ),
    );
  }
}
