import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/title_logo.dart';
import 'package:history_go/src/firestore/firestore_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  final String title = 'Registration';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode focus;

  bool _success;
  String _message = '';

  @override
  void initState() {
    super.initState();

    focus = FocusNode();
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Har redan ett konto?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              'Logga in',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focus);
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Vänligen ange en email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Lösenord'),
            focusNode: focus,
            obscureText: true,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Vänligen ange ett lösenord';
              }
              return null;
            },
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Text(
              _message,
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _register() async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
        });
        await FirestoreService.createUser(user);
      } else {
        _success = false;
      }
    } on PlatformException catch (e) {
      print(e);
      _setErrorMessage(e.message);
    } catch (e) {
      print(e);
      _setErrorMessage('Något gick fel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                TitleLogo(),
                SizedBox(
                  height: 50,
                ),
                _emailPasswordForm(),
                SizedBox(
                  height: 20,
                ),
                WelcomeButton(
                    text: 'Registrera nu',
                    color: Colors.grey.shade300,
                    onTap: () async {
                      _resetErrorMessage();
                      if (_formKey.currentState.validate()) {
                        _register().then((value) {
                          if (_success != null && _success) {
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    filled: true,
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _loginAccountLabel(),
          ),
          Positioned(
              top: 40,
              left: 0,
              child: CustomBackButton(
                onPressed: () => Navigator.pop(context),
              )),
        ],
      ),
    )));
  }

  void _setErrorMessage(String message) {
    if (message != null) {
      setState(() {
        _message = message;
      });
    }
  }

  void _resetErrorMessage() {
    _setErrorMessage(' ');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    focus.dispose();
    super.dispose();
  }
}

class Validator {
  static final RegExp regExpPassword =
      new RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  static final RegExp regExpEmail = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static bool validatePassword(String password) {
    if (password == null) return false;
    return regExpPassword.hasMatch(password);
  }

  static bool validateEmail(String email) {
    if (email == null) return false;
    return regExpEmail.hasMatch(email);
  }
}
