import 'package:flutter/cupertino.dart';
import 'package:misheel/events_list/presentation/add_events_dialog.dart';
import 'package:misheel/events_list/classes/event_item.dart';
import 'package:flutter/material.dart';
import 'package:misheel/events_list/classes/event_record.dart';
import 'package:localstorage/localstorage.dart';
import 'package:misheel/home_page/presentation/reusable_dialog.dart';


class RecordData extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<RecordData> {
  final EventRecord list = EventRecord();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;

  _addItem(String title, int color) {
    setState(() {
      final item = new EventItem(title: title, color: color);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.deleteItem('todos');

    setState(() {
      list.items = storage.getItem('todos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: (){
            showDialog(
                context: context,
                child: ShowAlertDialog(
                text: 'Do you want to all events title',
                function: (){
                _clearStorage();
                Navigator.pop(context);
            }));
    }),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(2.0),
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

              int length = storage.getItem('todos') != null
                  ? storage.getItem('todos').length
                  : 0;


              List<Widget> widgets = list.items.map((item) {
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){
                    for(int i =0; i < length; i++){
                      if(storage.getItem('todos')[i]['title'] == item.title){
                        storage.getItem('todos').removeAt(i);
                        break;
                      }
                    }
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("${item.title} Event Title deleted", style: TextStyle(fontWeight: FontWeight.bold),)));
                  },
                  key: Key('key'),
                  child: Card(
                    color: Color(item.color),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Text(item.title,
                        style: TextStyle(fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),),
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
                itemExtent: 50.0,
              );
            },
          )),
      floatingActionButton:  FloatingActionButton(
        onPressed: (){
          showDialog(context: context, child: AddEventDialog()).then((value) =>
           value != null? _addItem(value[0], value[1]) : null
          );
        },
        child: Icon(Icons.add),),
    );
  }
}
