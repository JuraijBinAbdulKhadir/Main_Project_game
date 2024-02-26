import 'package:chess_one/Components/Square.dart';
import 'package:chess_one/Components/piece.dart';
import 'package:chess_one/Values/Colors.dart';

import 'package:flutter/material.dart';

import 'Components/dead_piece.dart';
import 'Helper/rc_help.dart';



class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {

  late List<List<ChessPiece?>> board;

  //current selected piece..
  ChessPiece? selectedPiece;

  int selectedRow=-1;//row index of selected piece..
  int selectedCol=-1;//colum index of selected piece..

  //VALID MOVES..
  List<List<int>> validMoves=[];

  //LIST OF WHITE PIECES THAT HAS TAKEN
  List<ChessPiece> whitePieceTaken=[];

  //LIST OF BLACK PIECES TAKEN
  List<ChessPiece>blackPieceTaken=[];

  //TURNS  OF GAME
  bool isWhiteTurn=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeBoard();
  }
 //INITIALIZE BOARD>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void _initializeBoard(){
    late List<List<ChessPiece?>> newBoard=List.generate(8, (index) => List.generate(8,(index) => null,));



    //place pawns..
    for(int i = 0;i<8;i++){
      newBoard[1][i]=ChessPiece(type: ChessPieceType.pawn, w: false, imgpath: 'lib/images/pawn.png');
      newBoard[6][i]=ChessPiece(type: ChessPieceType.pawn, w: true, imgpath: 'lib/images/pawn.png');

    }

    //place rooks..
    newBoard[0][0]=ChessPiece(type: ChessPieceType.rook, w: false, imgpath: 'lib/images/rook.png');
    newBoard[7][0]=ChessPiece(type: ChessPieceType.rook, w: true, imgpath: 'lib/images/rook.png');

    newBoard[0][7]=ChessPiece(type: ChessPieceType.rook, w: false, imgpath: 'lib/images/rook.png');
    newBoard[7][7]=ChessPiece(type: ChessPieceType.rook, w: true, imgpath: 'lib/images/rook.png');

    //place knights..
    newBoard[0][1]=ChessPiece(type: ChessPieceType.knight, w: false, imgpath: 'lib/images/knight.png');
    newBoard[7][1]=ChessPiece(type: ChessPieceType.knight, w: true, imgpath: 'lib/images/knight.png');

    newBoard[0][6]=ChessPiece(type: ChessPieceType.knight, w: false, imgpath: 'lib/images/knight.png');
    newBoard[7][6]=ChessPiece(type: ChessPieceType.knight, w: true, imgpath: 'lib/images/knight.png');

    //place Bishops..
    newBoard[0][2]=ChessPiece(type: ChessPieceType.bishop, w: false, imgpath: 'lib/images/bishop.png');
    newBoard[7][2]=ChessPiece(type: ChessPieceType.bishop, w: true, imgpath: 'lib/images/bishop.png');

    newBoard[0][5]=ChessPiece(type: ChessPieceType.bishop, w: false, imgpath: 'lib/images/bishop.png');
    newBoard[7][5]=ChessPiece(type: ChessPieceType.bishop, w: true, imgpath: 'lib/images/bishop.png');

    //place Queen..
    newBoard[0][3]=ChessPiece(type: ChessPieceType.queen, w: false, imgpath: 'lib/images/crown.png');
    newBoard[7][4]=ChessPiece(type: ChessPieceType.queen, w: true, imgpath: 'lib/images/crown.png');

    //place King..
    newBoard[0][4]=ChessPiece(type: ChessPieceType.king, w: false, imgpath: 'lib/images/king.png');
    newBoard[7][3]=ChessPiece(type: ChessPieceType.king, w: true, imgpath: 'lib/images/king.png');

    board=newBoard;
  }
//USR SELECT PIECE
  void pieceSelected(int row,int col){
    setState(() {


      // //No piece has been selected....
       if(selectedPiece == null && board[row][col] != null){
         if(board[row][col]!.w  == isWhiteTurn){
           selectedPiece=board[row][col];
           selectedRow=row;
           selectedCol=col;
         }
       }

      //there is a piece already selected,but usr can select another piece..

      else if(board[row][col] != null && board[row][col]!.w == selectedPiece!.w){
        selectedPiece=board[row][col];
        selectedRow=row;
        selectedCol=col;
      }
      //if piece selected and usr taps another..
      else if(selectedPiece != null && validMoves.any((element) => element[0]==row && element[1]==col )){
        movePiece(row, col);
      }
      //if piece selected calc valid moves..
      validMoves=calculateRawValidMoves(selectedRow,selectedCol,selectedPiece);
    });
  }


//Calculate raw valid moves....
  List<List<int>> calculateRawValidMoves(int row,int  col,ChessPiece? piece){
   List<List<int>> candidateMoves=[];

   if(piece==null){return [];}


   //direction..
    int direction=piece.w?-1:1;

    switch(piece.type){
      case ChessPieceType.pawn:
        //forward 1 pos..

        if( isInBoard(row+direction,col) && board[row+direction][col] == null){
          candidateMoves.add([row+direction,col]);
        }
        //forward 2 pos at start..


        if((row==1 && !piece.w)||(row==6 && piece.w)){
          if( isInBoard(row+2*direction, col) && board[row+2*direction][col] == null && board[row+direction][col] == null){
            candidateMoves.add([row+2*direction,col]);
          }
        }

        //kill diagonally..
        if( isInBoard(row+direction, col-1) && board[row+direction][col-1] != null && board[row+direction][col-1]!.w ){
          candidateMoves.add([row+direction,col-1]);
        }
        if( isInBoard(row+direction, col+1) && board[row+direction][col+1] != null && board[row+direction][col+1]!.w ){
          candidateMoves.add([row+direction,col+1]);
        }

       break;


      case ChessPieceType.rook:
        //horizontal and vertical moves..
        var directions=[
          [-1,0],//up
          [1,0],//down
          [0,-1],//left
          [0,1],//right
        ];

        for(var direction in directions){
          var i=1;
          while(true){

            var newRow=row+i*direction[0];
            var newCol=col+i*direction[1];
            if( !isInBoard(newRow, newCol) ){break;}

            if( board[newRow][newCol] != null){
              if(board[newRow][newCol]!.w != piece.w){   candidateMoves.add([newRow,newCol]);/*KILL*/ }
                break;//blocked...
            }
            candidateMoves.add([newRow,newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:

        //all 8 L-shaped directions..
        var knightMoves=[
          [-2,-1],//up 2 left 1
          [-2,1],//up 2 right 1
          [-1,-2],//up 1 left 2
          [-1,2],//up 1 right 2
          [1,-2],//down 1 left 2
          [1,2],//down 1 right 2
          [2,-1],//down 2 left 1
          [2,1],// down 2 right 1
        ];

        for(var move in knightMoves){
          var newRow = row+move[0];
          var newCol = col+move[1];

          if( !isInBoard(newRow, newCol) ) {continue;}
          if( board[newRow][newCol] != null) {
            if(board[newRow][newCol]!.w !=piece.w){
              candidateMoves.add([newRow,newCol]);//KILL...
            }
            continue;//BLOCK..
          }
          candidateMoves.add([newRow,newCol]);

        }

        break;
      case ChessPieceType.bishop:
        // diagonal directions..
         var directions =[
           [-1,-1],// up left
           [-1,1],//up right
           [1,-1],// down left
           [1,1],//down right
         ];
         for (var direction in directions){
           var i=1;
           while(true){
             var newRow=row + i * direction[0];
             var newCol=col + i * direction[1];

             if(!isInBoard(newRow,newCol)){ break;}

             if(board[newRow][newCol] != null){

               if(board[newRow][newCol]!.w !=piece.w){

                 candidateMoves.add([newRow,newCol]);//CAPTURE...
               }
               break;//BLOCK..

             }
             candidateMoves.add([newRow,newCol]);
             i++;
           }
         }
        break;
      case ChessPieceType.queen:
        //All 8 direction up,down,left,right,4 diagonals
        var directions=[
          [-1,0],//up
          [1,0],//down
          [0,-1],//left
          [0,1],//right
          [-1,-1],//up left
          [-1,1],//up right
          [1,-1],//down left
          [1,1],//down right
        ];
        for (var direction in directions){
          var i=1;
          while(true){
            var newRow= row + i * direction[0];
            var newCol=col + i * direction[1];

            if(!isInBoard(newRow,newCol)){
              break;
            }
            if(board[newRow][newCol] != null){
              if(board[newRow][newCol]!.w !=piece.w){

                candidateMoves.add([newRow,newCol]);//CAPTURE
              }
              break;//BLOCK
            }
            candidateMoves.add([newRow,newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //All 8 direction up,down,left,right,4 diagonals
        var directions=[
          [-1,0],//up
          [1,0],//down
          [0,-1],//left
          [0,1],//right
          [-1,-1],//up left
          [-1,1],//up right
          [1,-1],//down left
          [1,1],//down right
        ];

        for(var direction in directions){
          var newRow =row + direction[0];
          var newCol=col + direction[1];
          if(!isInBoard(newRow, newCol)){
            continue;
          }
          if(board[newRow][newCol] !=null){
            if(board[newRow][newCol]!.w !=piece.w){
              candidateMoves.add([newRow,newCol]);//CAPTURE
            }
            continue;
          }
          candidateMoves.add([newRow,newCol]);
        }
        break;

      default:

    }
   return candidateMoves;
  }

  //MOVE PIECES
  void movePiece(int newRow,int newCol){
    //if new spot has enemy piece
    if(board[newRow][newCol] != null){
      var capturedPiece = board[newRow][newCol];
      if(capturedPiece!.w){
        whitePieceTaken.add(capturedPiece);
      }
      else{blackPieceTaken.add(capturedPiece);}
    }

    //MOVE AND CLEAR OLD
    board[newRow][newCol]=selectedPiece;
    board[selectedRow][selectedCol]=null;


    //CLEAR  SELECTION
    setState(() {
      selectedPiece=null;
      selectedRow=-1;
      selectedCol=-1;
      validMoves=[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child:
      Scaffold(
        backgroundColor: backgroundColor,

        body:Column(
          children: [
            //WHITE TAKEN
            Expanded(

                child:GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                    itemCount: whitePieceTaken.length,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                    itemBuilder: (context,index)=>DeadPiece( imagePath: whitePieceTaken[index].imgpath,isWhite: true, )) ),
            
            //CHESS BOARD
            Expanded(
              flex: 3,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemCount: 8 * 8,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
              
                    int row=index ~/8;
                    int col=index%8;
                    bool isSelected=selectedRow == row &&selectedCol==col;
              
                    //check valid move..
                    bool  isValidMove=false;
                    for(var position in validMoves){
                      if(position[0]==row && position[1]==col){isValidMove=true;}
                    }
                    return Square(
                      isWhite: w(index),
                      piece: board[row][col],
                      isSelect: isSelected,
                      onTap:()=> pieceSelected(row, col),
                      isValidMove:isValidMove ,);
                  } ),
            ),
            //BLACK TAKEN
            Expanded(
                child:GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                    itemCount: blackPieceTaken.length,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                    itemBuilder: (context,index)=>DeadPiece( imagePath: blackPieceTaken[index].imgpath,isWhite: false, )) ),
            
          ],
        ),
      ),
    );
  }
}
