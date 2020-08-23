import 'package:misheel/home_page/classes/record.dart';

class AddRecord {
  List<Record> record;

  AddRecord() {
    record = List();
  }

  toJSONEncodable() {
    return record.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

}