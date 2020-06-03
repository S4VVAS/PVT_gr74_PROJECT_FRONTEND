import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/title_logo.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/pages/pages.dart';
import 'package:history_go/src/services/globals.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    _populateCurrentUser();
  }

  Widget _welcomePage() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.purple[400],
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WhiteTitleLogo(),
              SizedBox(
                height: 100,
              ),
              WelcomeButton(
                text: 'Logga in',
                color: Colors.orange,
                textColor: Colors.orange,
                filled: true,
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              SizedBox(
                height: 20,
              ),
              WelcomeButton(
                  text: 'Registrera nytt konto',
                  color: Colors.orange,
                  filled: false,
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            FirebaseUser user = snapshot.data;
            if (user == null) {
              return _welcomePage();
            } else if (_isPopulated) {
              return HomePage();
            } else {
              _populateCurrentUser().then((value) {
                return HomePage();
              });
            }
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Future<void> _populateCurrentUser() async {
    final FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    if (fbUser != null) {
      if (!_isPopulated) {
        FirestoreService.getUser(fbUser.uid).then((_user) {
          if (_user == null) {
            print(
                'User ${fbUser.uid} did not have a firestore space! Creating new space!');
            FirestoreService.createUser(fbUser).then((m) {
              FirestoreService.getUser(fbUser.uid)
                  .then((_newUser) => _user = _newUser);
            });
            assert(_user != null);
          }

          Globals.instance.user = _user;
          print("Populated user ${_user?.id}");
          if (this.mounted) {
            setState(() {
              _isPopulated = true;
            });
          }
        });
      }
    } else {
      print('Firebase user was null, Could not populate user.');
    }
  }
}
