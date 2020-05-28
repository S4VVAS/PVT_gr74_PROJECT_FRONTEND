import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/pages/pages.dart';

class MissionsPage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  Widget _missionListView(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.only(top: 8.0, bottom: 12.0, left: 20.0, right: 20.0),
      //margin: const EdgeInsets.only(bottom: 15.0),
      decoration: new BoxDecoration(
        color: Colors.white54
            .withOpacity(0.3), //new Color.fromRGBO(255, 0, 0, 0.0),
        borderRadius: new BorderRadius.all(Radius.circular(12)),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Text(
            'Populära uppdrag nära dig',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          Button('Stockholms blodbad', onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewMissionPage()));
          }, color: Colors.red[200]),
          Button('Runda 2', color: Colors.red[200]),
          Button('Runda 3', color: Colors.red[200]),
          Button('Runda 4', color: Colors.red[200]),
          Button('Runda 5', color: Colors.red[200]),
          Button('Runda 6', color: Colors.red[200]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Uppdrag"),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ]),
          ),
          child: Column(
            children: <Widget>[
              _missionListView(context),
              SizedBox(height: 8.0),
              Button.pushRoute('Skapa nytt uppdrag', "/someRoute", color: Colors.deepOrangeAccent),
              Button.pushRoute('Utförda uppdrag', "/someRoute", color: Colors.red),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
