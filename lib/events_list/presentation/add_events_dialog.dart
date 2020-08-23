import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {

  List<Color> colour = [Colors.red, Colors.blue, Colors.green, Colors.orange];
  String title;
  int colorsIndex;
  String error;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();},
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(5),
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create Event', style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700]),),),
                Text('Title: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                        fontSize: 20.0,
                        height: 2.0,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Text('Colors: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                Container(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  List.generate(4, (index) => Padding(
                    padding: EdgeInsets.all(6),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          colorsIndex == null ? colorsIndex = index : colorsIndex == index ? colorsIndex = null : colorsIndex = index;
                        });
                      },
                      child: CircleAvatar(
                        child: Center(
                          child: colorsIndex != index ?
                          Text('') :
                          Icon(Icons.done, color: Colors.white,),
                        ),
                        backgroundColor: colour[index],
                      ),
                    ),
                  ),
                  ),
                ),
                ),
                error == null ? Text('') : Text(error,
                  style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.blue,
                    child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    onPressed: _emptyInput,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _emptyInput() {
    if(controller.value.text.isEmpty && colorsIndex == null){setState(() {
      error = 'Please add a title and select a color';
    });}
    else if(controller.value.text.isEmpty){setState(() {
      error = 'Please add a title';
    });}
    else if(colorsIndex == null){setState(() {
      error = 'Please select a color';
    });}
    else {
      _save();
    }
  }

  void _save() {
    var result = sendData(controller.value.text, colour[colorsIndex].value);
    controller.clear();
    colorsIndex = null;
    Navigator.pop(context, result != null ? result : null );
  }

  sendData(String text, int color) => [text, color];

}
