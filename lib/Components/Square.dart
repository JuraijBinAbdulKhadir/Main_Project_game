import 'package:chess_one/Components/piece.dart';
import 'package:chess_one/Values/Colors.dart';
import 'package:flutter/material.dart';
class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelect;
  final bool isValidMove;
  final void Function()? onTap;


  const Square({super.key,required this.isWhite,required this.piece,required this.isSelect,required this.onTap,required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if(isSelect){squareColor=Colors.green;}
    else if(isValidMove){squareColor=Colors.green[300];}
    else{squareColor=isWhite? foregroundColor:backgroundColor;}

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove? 8 : 0),
        child: piece!=null?Image.asset(piece!.imgpath,color: piece!.w?Colors.white:Colors.black,):null,
      ),
    );
  }
}
