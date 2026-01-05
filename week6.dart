void main() {
  printX(11);
  printMountain(5);
}


void printX(int size) {
  print("#   #");
  print(" # # ");
  print("  #  ");
  print(" # # ");
  print("#   #");
  
  String str = "";
  for(int y = 0; y < size; y++) {
    str = "";
    for(int x = 0; x < size; x++) {
      bool isBorder = x == 0 || x == size - 1 || y == 0 || y == size - 1;
      bool isDiagonal = x == y || x == size - y - 1;
      bool con = isBorder || isDiagonal;
      str += con ? '#' : ' ';
    }
    print(str);
  }
}

void printMountain(int n) {  
  for(int y = 0; y < n; y++) {
    var str = "";
    for(int i = 0; i < n; i++) {
      for(int x = 1; x <= n * 2 - 1; x++) {
        var con = (x == n && y == 0)|| x == n - y || x == n + y;
        if(x == n * 2 - 1 && i != n - 1) continue;
        str += con ? '#' : ' ';
      }
    }
    print(str);
  }
}
