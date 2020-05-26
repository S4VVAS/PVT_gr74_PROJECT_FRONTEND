import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> places;

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<String> visitedPlaces = new List<String>();

    for(String str in keys) {
      visitedPlaces.add(str);
    }
    places = visitedPlaces;
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
              //Navigator.pushNamed(context, '/settings');
              Scaffold.of(context).openEndDrawer();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(28.0),
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              _profilePicture(),
              places == null
                  ? Container(
                child: Center(
                  child: Text(
                    'Du har inga besökta platser än, eller så laddas dem!',
                    style: TextStyle(
                        fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                  ),
                ),
              )
                  :
                  Center(
                    child: Text('Besökta platser: '),
                  ),
              ListView.builder(scrollDirection: Axis.vertical,
                  shrinkWrap: true, itemCount: places.length, itemBuilder: (BuildContext ctxt, int index) {return new Button(places[index]);})
            ],
          ),
        ),
      ),
    );
  }
}

