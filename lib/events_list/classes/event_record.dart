import 'package:misheel/events_list/classes/event_item.dart';

class EventRecord {
  List<EventItem> items;

  EventRecord() {
    items = List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

