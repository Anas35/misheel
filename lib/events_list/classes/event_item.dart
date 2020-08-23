
class EventItem {
  String title;
  int color;

  EventItem({this.title, this.color});

  toJSONEncodable() {
    Map<String, dynamic> m = Map();

    m['title'] = title;
    m['done'] = color;

    return m;
  }

}



