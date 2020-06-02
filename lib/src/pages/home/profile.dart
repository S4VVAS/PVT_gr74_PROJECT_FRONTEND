import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/pages/pages.dart';
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
              //Expanded(
              //  child: VisitedList(),
              //), 
            ],
          ),
        ),
      ),
    );
  }
}

class VisitedList extends StatefulWidget {
  @override
  _VisitedListState createState() => _VisitedListState();
}

class _VisitedListState extends State<VisitedList> {
  final Completer<Set<Place>> _placeCompleter = new Completer();
  final HashSet<Place> places = new HashSet<Place>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users").where("id", isEqualTo: user.id).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
              break;
            default:
              if (snapshot.data.documentChanges.first.type == DocumentChangeType.modified)
                print(snapshot.data.documentChanges.first.document.data["visited"]);
              //snapshot.data.documentChanges.forEach((change) { print(change.document.data.toString());});
              
              setPlacesFromData(List<String>.from(snapshot.data.documentChanges.first.document.data["visited"]));
              return _placeCompleter.isCompleted
                  ? ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return placeTile(document["visited"]);
                    }).toList()
                  )
                  
                  /* ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: places.length,
                      itemBuilder: (BuildContext context, int index) {
                        return placeTile(places.elementAt(index));
                      },
                    ) */
                  : Align(
                      child: Text("Loading.."),
                      alignment: Alignment.center,
                    );
          }
        });
  }

  Widget placeTile(Place place) {
    return Container(
        color: Colors.lightBlue,
        child: ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.network(
              place.entries[0].img,
              filterQuality: FilterQuality.low,
            ),
          ),
          title: Text(place.entries[0].title),
          subtitle: Text("${place.entries.length} bilder"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => InfoPage(place)),
          ),
        ));
  }

  Future<void> setPlacesFromData(List<String> coords) async {
    print(coords);
    PlaceRepository().getPlacesFromCoords(coords).then((result) {
      result.forEach((element) {
        print(element.entries[0].title);
      });
      print(result.toString);
      setState(() {
        places.addAll(result);
      });
    });
  }
}
