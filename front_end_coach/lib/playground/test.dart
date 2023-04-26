// main function

void main() {
  DateTime rn = DateTime.now();
  String date = DateTime.now().toString().substring(0, 10);

  print("[ $date ]");
}