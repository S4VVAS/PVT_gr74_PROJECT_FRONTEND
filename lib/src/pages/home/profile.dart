import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';
import 'package:history_go/src/services/place_repository.dart';

User user = Globals.instance.user;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  String _message = 'Du har inga besökta platser än, eller så laddas dem!';

  final Completer<DocumentSnapshot> _initial = new Completer();

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("users")
        .document(user.id)
        .get()
        .then((value) => _initial.complete(value));
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
/*     User user = Globals.instance.user;
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
    } */
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
              Center(
                child: Text('Besökta platser: '),
              ),
              _initial.isCompleted ?
              Expanded (
                child: VisitedList(_initial.future),
              ) : Expanded(child: Align(child: Text("Loading.."), alignment: Alignment.center,),)
            ],
          ),
        ),
      ),
    );
  }
}

//places får korrekta platserna efter api callet i setplacesFromData har körts,
// så om man gör om VisitedList till en stateful widget och kör setState(() {places.addAll(result) })
// i getPlacesFromData så borde widgeten byggas om automatiskt och då returnera listviewn med plasterna! :)
class VisitedList extends StatelessWidget {
  VisitedList(this._initial) {_initial.then((value) => initialData = value);}
  Future<DocumentSnapshot> _initial;
  DocumentSnapshot initialData;

  final Completer<Set<Place>> _placeCompleter = new Completer();
  final HashSet<Place> places = new HashSet<Place>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection("users")
            .document(user.id)
            .snapshots(),
        initialData: initialData,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              print(snapshot.data.documentID);
              print(snapshot.data.data["visited"]);
              setPlacesFromData(HashSet.from(snapshot.data.data["visited"]));
              return _placeCompleter.isCompleted ? ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: places.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text(
                                "${places.elementAt(index).entries[0].title}"));
                      },
                    ):
                    Align(child: Text("Loading.."), alignment: Alignment.center,);
          }
        });
  }

  Future<void> setPlacesFromData(HashSet<String> coords) async {
    print(coords);
    PlaceRepository().getPlacesFromCoords(coords).then((result) {
      print("before:" + places.toString());
      print(result.toString);
      places.addAll(result);
      _placeCompleter.complete(places);
      print("after:" + places.toString());
    });
  }
}
