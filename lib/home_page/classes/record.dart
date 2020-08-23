
class Record {

  String title;
  DateTime date;
  int colorNo;

  Record({this.date, this.title, this.colorNo});

  toJSONEncodable() {
    Map<String, dynamic> r = Map();

    r['title'] = title;
    r['time'] = date.toIso8601String();
    r['colorNo'] = colorNo;

    return r;
  }


}