import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  bool notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Inställningar',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Aviseringar", style: Theme.of(context).textTheme.button),
                    Container(
                      child:
                    Align(
                      child:
                    Switch(
                      value: notificationsOn,
                      onChanged: (value){
                        setState((){
                          notificationsOn = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    ),
                    ),
                  ],
                ),
                ),
                Button('Konto'),
                Button('Sekretess'),
                Button('Säkerhet'),
                Button.pushRoute('Visa behörigheter', '/permissions')
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.zero,
            child: SignOutButton(text: 'Logga ut'),
          )
        ],
      ),
    );
  }
}
