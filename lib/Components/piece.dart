enum ChessPieceType {pawn,rook ,knight,bishop,queen,king}

class ChessPiece{
  final ChessPieceType type;
  final bool w;
  final String imgpath;

  ChessPiece({required this.type,required this.w,required this.imgpath});
}