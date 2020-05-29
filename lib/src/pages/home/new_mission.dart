import 'package:flutter/material.dart';
import 'package:history_go/src/components/custom_app_bar.dart';

class NewMissionPage extends StatelessWidget {
  Widget _infoPicture() {
    return Hero(
      tag: 'infoPic',
      child: SizedBox(
          height: 300.0,
          width: 280.0,
          //child: Image.asset('',  fit: BoxFit.cover)
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }

  Widget _actionButton(String title, Color color) {
    return Container(
      width: 330.0,
      height: 60.0,
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
          //Navigator.of(context).pushNamed();
        },
        color: color,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Stockholms blodbad", backButton: true,),
      body: Center(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ]),
          ),
          child: Column(
            children: <Widget>[
              _infoPicture(),
              _infoText("Estimerad tid: 2 timmar"),
              _infoText("Längd: 8 km"),
              _infoText("Beskrivning: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam sit amet euismod ex. Cras imperdiet elementum augue, et finibus mi egestas vel."),
              _actionButton('Starta uppdrag!', Colors.deepOrangeAccent)
            ],
          ),
        ),
      ),
    );
  }
}
