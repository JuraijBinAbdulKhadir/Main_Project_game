import 'package:chess_one/Board.dart';
import 'package:flutter/material.dart';
class Hhh extends StatefulWidget {
  const Hhh({super.key});

  @override
  State<Hhh> createState() => _HhhState();
}

class _HhhState extends State<Hhh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>Board()  ));} ,child: Text('Click Me!'),),
      ),
    );
  }
}
