import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key key}) : super(key: key);

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
                SwitchButton('Aviseringar'),
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
