import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:localstorage/localstorage.dart';
import 'package:misheel/home_page/presentation/reusable_dialog.dart';
import 'package:misheel/home_page/presentation/show_events_dialog.dart';
import 'package:misheel/events_list/presentation/events.dart';
import 'package:misheel/home_page/classes/record.dart';
import 'package:misheel/home_page/classes/add_record.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AddRecord eventRecord = AddRecord();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized2 = false;
  bool initialized3 = false;

  Widget eventsIcon(int date, int color) => Container(
        decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.all(Radius.circular(1000))),
        child: Center(child: Text(date.toString())),
      );

  EventList<Event> addedEven = EventList<Event>(events: {});

  addEvents(DateTime eventDate, String title, int color) {
    setState(() {
      final item = Record(date: eventDate, title: title, colorNo: color);
      eventRecord.record.add(item);
      saveToStorage();
      addRecord();
    });
  }

  _clearStorage() async {
    await storage.deleteItem('event');

    setState(() {
      eventRecord.record = storage.getItem('event') ?? [];
      addedEven.clear();
    });
  }

  addRecord() {
    int length = storage.getItem('event') != null
        ? storage.getItem('event').length
        : 0;
    for (int i = 0; i < length; i++) {
      var data = storage.getItem('event')[i];
      DateTime date = DateTime.parse(data['time']);
      addedEven.add(
          date,
          Event(
              title: data['title'],
              date: date,
              icon: eventsIcon(date.day, data['colorNo'])));
    }
  }

  saveToStorage() {
    storage.setItem('event', eventRecord.toJSONEncodable());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mishell'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.delete),
              onPressed: (){
            showDialog(context: context, child: ShowAlertDialog(text: 'Do you want to delete all added event',
            function: (){
              _clearStorage();
              Navigator.pop(context);
            },));
              })
        ],
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Events'),
              actions: [IconButton(icon: Icon(Icons.arrow_forward), onPressed: (){Navigator.pop(context);})],
              leading: Text(''),
            ),
            Expanded(
              child: FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!initialized3) {
                  var items = storage.getItem('event');

                  if (items != null) {
                    eventRecord.record = List<Record>.from(
                      (items as List).map(
                            (item) => Record(
                            title: item['title'],
                            date: DateTime.parse(item['time']),
                            colorNo: item['colorNo']),
                      ),
                    );
                  }

                  initialized3 = true;
                }

                return storage.getItem('event') == null ?
                Center(
                  child: Text('No Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                )
                    : ListView(
                  children: eventRecord.record.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Text(DateFormat('dd-MM-yyyy').format(e.date)),),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: Color(e.colorNo),),
                              SizedBox(width: 10,),
                              Text(e.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    );

                  }).toList(),
                );
              }
                ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          storage.getItem('event') == null ? print('null') : addRecord();

          if (!initialized2) {
            var items = storage.getItem('event');

            if (items != null) {
              eventRecord.record = List<Record>.from(
                (items as List).map(
                  (item) => Record(
                      title: item['title'],
                      date: DateTime.parse(item['time']),
                      colorNo: item['colorNo']),
                ),
              );
            }

            initialized2 = true;
          }

          return CalendarCarousel<Event>(
            height: MediaQuery.of(context).size.height * 0.70,
            markedDateShowIcon: true,
            markedDatesMap: addedEven,
            markedDateMoreShowTotal: null,
            markedDateIconMaxShown: 1,
            markedDateIconBuilder: (events) {
              return events.icon;
            },
            onDayPressed: (DateTime date, List<Event> events) {
              showDialog(context: context, child: ShowEventDialog(date: date),
              ).then((value) => value != null ? addEvents(value[0], value[1], value[2]) : null);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.event),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordData(),
                ));
          }),
    );
  }
}
