import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //TODO: Använda getPlacesFromCoords i PlaceRepo för att lista platserna ist för koordinaterna.
  //Behöver nödvändigtvis inte göras här, är nog snyggare att abstrahera det till firestore_service klassen eller nåt.
  List<String> places;
  final FirestoreService _firestoreService = FirestoreService();

  String _message = 'Du har inga besökta platser än, eller så laddas dem!';

  @override
  void initState() {
    super.initState();
    _getPlaces();
  }

  Widget _profilePicture() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: CircleAvatar(
        radius: 120.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/profil.png'),
      ),
    );
  }

  Future<void> _getPlaces() async {
    User user = Globals.instance.user;
    if (user != null) {
      print('got user to profilePage: ' + user.toString());
      //user = await _firestoreService.getUser(user.id);
      if (user != null) {
        //Globals.instance.user = user;
        setState(() {
          places = user.visited;
        });
        print('Gick igenom getPlaces');

        if (places == null) {
          setState(() {
            _message = "ditt konto saknar en platslista...ops";
          });
          print('User does not have a visited field in firestore...');
        } else if (places.isEmpty) {
          setState(() {
            _message = "Du har inga besökta platser än";
          });
        }
      } else {
        print('User is null in Getplaces');
      }
    } else {
      print('User is null in Profilpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Profil",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              _profilePicture(),
              places == null
                  ? Container(
                      child: Center(
                        child: Text(
                          _message,
                          style: TextStyle(
                              fontFamily: 'Avenir-Medium',
                              color: Colors.grey[400]),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('Besökta platser: '),
                    ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: places.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Button("Coord: " + places[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
