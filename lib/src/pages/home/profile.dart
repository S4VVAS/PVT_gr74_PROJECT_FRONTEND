import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/pages/pages.dart';
import 'package:history_go/src/services/globals.dart';
import 'package:history_go/src/services/place_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';

User user = Globals.instance.user;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _circularPercentIndicator() {
    return new CircularPercentIndicator(
      radius: 180.0,
      lineWidth: 10.0,
      percent: user.exp / (User.getExpRequiredToLvlUp(user.level)),
      center: _profilePicture(),
      backgroundColor: Colors.grey,
      progressColor: Colors.blue,
    );
  }

  Widget _profilePicture() {
    return CircleAvatar(
      radius: 90.0,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage('assets/profil.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Profil",
        backButton: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _circularPercentIndicator(),
              Center(
                child: Text('Level: ' + user.level.toString()),
              ),
              Center(
                child: user.level != 10
                    ? Text(user.exp.toString() +
                        ' / ' +
                        User.getExpRequiredToLvlUp(user.level).toString() +
                        ' XP')
                    : Text(user.exp.toString() + ' /∞'),
              ),
              Center(
                child: Text('Besökta platser: ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              user.visited.length == 0
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 48.0),
                      child: Text(
                        "Du har inte besökt några platser\n"
                        "Upptäck nya genom att trycka på platser i närheten på kartan, "
                        "de visas i en annan färg när du är tillräckligt nära!",
                        textAlign: TextAlign.center,
                      ))
                  : Expanded(
                      child: VisitedList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class VisitedList extends StatefulWidget {
  final List<String> coords = user.visited;

  @override
  _VisitedListState createState() => _VisitedListState();
}

class _VisitedListState extends State<VisitedList> {
  Completer<Set<Place>> _completer = new Completer();
  HashSet<Place> _places;

  @override
  void initState() {
    super.initState();
    setPlacesFromData(widget.coords);
  }

  @override
  Widget build(BuildContext context) {
    return _completer.isCompleted
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            primary: true,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _places.length,
            itemBuilder: (BuildContext context, int index) {
              return placeTile(_places.elementAt(index));
            })
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                  'laddar besökta platser',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
                Container(
                  child: CircularProgressIndicator(),
                )
              ]);
  }

  Widget placeTile(Place place) {
    return Container(
        margin: EdgeInsets.all(4.0),
        child: RawMaterialButton(
            onPressed: () {},
            elevation: 4.0,
            fillColor: Theme.of(context).buttonColor,
            splashColor: Theme.of(context).splashColor,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(place.entries[0].img),
                backgroundColor: Colors.transparent,
              ),
              title: Text(place.entries[0].title,
                  style: Theme.of(context).textTheme.button),
              subtitle: Text("${place.entries.length} bilder",
                  style: Theme.of(context).textTheme.caption),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InfoPage(place)),
              ),
            )));
  }

  Future<void> setPlacesFromData(List<String> coords) async {
    print(coords);
    PlaceRepository().getPlacesFromCoords(coords).then((result) {
      result.forEach((element) {
        print(element.entries[0].title);
      });
      print(result.toString);
      setState(() {
        _completer.complete(result);
        _places = new HashSet<Place>.from(result);
      });
    });
  }
}
