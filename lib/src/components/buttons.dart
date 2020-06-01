import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(this.text, {this.onPressed, this.route, this.color});

  Button.pushRoute(String text, String route, {Color color})
      : this(text, onPressed: () {}, route: route, color: color);

  final String text;
  final GestureTapCallback onPressed;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: RawMaterialButton(
        elevation: 4.0,
        fillColor: color ?? Theme.of(context).buttonColor,
        splashColor: Theme.of(context).splashColor,
        onPressed: () {
          if (route != null) {
            Navigator.of(context).pushNamed(route);
          } else if (onPressed != null) return onPressed.call();
          return;
        },
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          minWidth: 260.0,
          minHeight: 50.0,
        ),
        textStyle: Theme.of(context).textTheme.button,
        child: Text(text),
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {
  SwitchButton(this.text);
  final String text;

  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  _SwitchButtonState();

  bool toggleValue = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: RawMaterialButton(
        elevation: 4.0,
        fillColor: Theme.of(context).buttonColor,
        splashColor: Theme.of(context).buttonColor,
        onPressed: () {},
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(
          minWidth: 260.0,
          minHeight: 50.0,
        ),
        textStyle: Theme.of(context).textTheme.button,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width: 40.0, height: 0),
            Text(widget.text),
            Switch(
              value: toggleValue,
              onChanged: (value) => toggleSwitch(value),
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.lightGreenAccent,
            ),
          ],
        ),
      ),
    );
  }

  toggleSwitch(value) {
    setState(() {
      toggleValue = value;
    });
  }
}

class SignOutButton extends StatelessWidget {
  SignOutButton({this.text});
  final String text;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Button(
      text,
      onPressed: () {
        try {
          _auth.signOut().whenComplete(() {
            print('Signed out Successfully');
            Navigator.pushNamedAndRemoveUntil(
                context, '/welcome', ModalRoute.withName('/'));
          });
        } catch (e) {
          print('Could not sign out\n' + e);
        }
      },
      color: Colors.redAccent,
    );
  }
}

class CustomBackButton extends StatelessWidget {
  CustomBackButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}

class MapSettingsButton extends StatelessWidget {
  MapSettingsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 2),
            blurRadius: 2,
            spreadRadius: 1,
          )
        ],
      ),
      child: IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.settings,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}

class WelcomeButton extends StatelessWidget {
  WelcomeButton(
      {this.text,
      this.filled,
      this.onTap,
      this.color,
      this.textColor,
      this.gradient})
      : _filledBox = new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: color.withAlpha(255),
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          gradient: gradient ?? null,
        ),
        _unfilledBox = new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        );

  final String text;
  final bool filled;
  final GestureTapCallback onTap;
  final Color color;
  final Color textColor;
  final Gradient gradient;
  final BoxDecoration _filledBox;
  final BoxDecoration _unfilledBox;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: filled ? _filledBox : _unfilledBox,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(fontSize: 20, color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
