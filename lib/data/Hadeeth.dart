class Hadeeth {
  static const MUSLIM = "Muslim";
  String number;
  String hadeeth;
  String tafseer;
  String hadeethBook;

  Hadeeth(this.number, this.hadeeth, this.tafseer, this.hadeethBook);

  factory Hadeeth.fromList(List<dynamic> list) {
    return Hadeeth(list[0], list[1], list[2], MUSLIM);
  }
}
