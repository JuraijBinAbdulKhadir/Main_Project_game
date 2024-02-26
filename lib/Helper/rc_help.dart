bool w(index)
{
  int x=index ~/ 8;//row
  int y=index % 8;//column
  //alt colors.
  bool w = (x+y) %2==0;
  return w;
}

bool isInBoard(int row,int col){
  return row>=0 && row<8 && col>=0 && col < 8;
}