import 'package:flutter/material.dart';
import 'package:history_go/src/components/custom_app_bar.dart';
import 'package:history_go/src/components/buttons.dart';


class ProfilePage extends StatelessWidget {

  Widget _profilePicture() {
    return Hero(
      tag: 'profilBild',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 120.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/kaknas.jpg'),
        ),
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
              Button('Mina vänner'),
              Button('Mina badges'),
              Button('Mina bidrag'),
            ],
          ),
        ),
      ),
    );
  }
}
