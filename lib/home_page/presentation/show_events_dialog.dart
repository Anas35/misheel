import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:misheel/events_list/classes/event_item.dart';
import 'package:misheel/events_list/classes/event_record.dart';


class ShowEventDialog extends StatefulWidget {

  final DateTime date;

  ShowEventDialog({this.date});

  @override
  _ShowEventDialogState createState() => _ShowEventDialogState();
}

class _ShowEventDialogState extends State<ShowEventDialog> {

  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  final EventRecord list = EventRecord();

  @override
  Widget build(BuildContext context) {

    DateTime date = widget.date;

    return Dialog(
      child: Container(
        height: 150,
        child: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!initialized) {
              var items = storage.getItem('todos');

              if (items != null) {
                list.items = List<EventItem>.from(
                  (items as List).map(
                        (item) => EventItem(
                      title: item['title'],
                      color: item['done'],
                    ),
                  ),
                );
              }

              initialized = true;
            }

            List<Widget> widgets = list.items.map((item) {
              return GestureDetector(
                onTap: () {
                  var add = sendData(date, item.title, item.color);
                  Navigator.pop(context, add);
                },
                child: Card(
                  color: Color(item.color),
                  child: Container(
                    height: 50,
                    padding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      item.title,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              );
            }).toList();

            return storage.getItem('todos') == null ?
            Center(
              child: Text('No Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            )
                : ListView(
              children: widgets,
            );
          },
        ),
      ),
    );
  }

  sendData(DateTime date,String title, int color) => [date, title, color];

}
