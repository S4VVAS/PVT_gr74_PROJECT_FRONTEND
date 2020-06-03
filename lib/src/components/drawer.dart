import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:app_settings/app_settings.dart';
import 'package:history_go/src/components/title_logo.dart';

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                WhiteTitleLogo()
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
                Button.pushRoute('Profil', '/profile'),
                //Button.pushRoute('Uppdrag', '/missions'),
/*                Button('Konto'),
                Button('Sekretess'),
                Button('Säkerhet'),*/
                Button('Aviseringar', onPressed: (){AppSettings.openNotificationSettings();},),
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
