
import 'package:chess_one/Components/Board.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:flutter/material.dart';
class Hhh extends StatefulWidget {
  const Hhh({super.key});

  @override
  State<Hhh> createState() => _HhhState();
}

class _HhhState extends State<Hhh> {
  final parallaxTwo=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: ParallaxRain(
        trail: true,
        key: parallaxTwo,
        dropColors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.brown, Colors.blueGrey],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 100,
                color: Colors.deepPurpleAccent,
                child: Image.asset('lib/home items/ScreenShot Tool -20240228101617.png'),
              ),const SizedBox(height: 10,),


              ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Board()  ));} ,
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)))),
                child: const Text('Play Chess!',style: TextStyle(color: Colors.red),),),


            ],
          ),
        ),
      ),
    );
  }
}
