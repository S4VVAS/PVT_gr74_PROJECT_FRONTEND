import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:history_go/src/components/buttons.dart';
import 'package:history_go/src/components/title_logo.dart';
import 'package:history_go/src/firestore/firestore_service.dart';
import 'package:history_go/src/models/place.dart';
import 'package:history_go/src/models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirestoreService _firestoreService = FirestoreService();

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
  String _userEmail;

  @override
  void initState() {
    super.initState();

    focus = FocusNode();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account?',
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
              'Login',
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
                return 'Please enter some text';
              } /*else if (!Validator.validateEmail(value)) {
                return 'Please enter a valid email';
              }*/
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            focusNode: focus,
            obscureText: true,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              } /*else if (!Validator.validatePassword(value)) {
                return 'Password must contain minimum 8 characters \n'+
                      'At least one uppercase letter, '+ 
                      'one lowercase letter\nand one digit\n'+
                      'Can not contain special characters';
              }*/
              return null;
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(_success == null
                ? ''
                : (_success
                    ? 'Successfully registered ' + _userEmail
                    : 'Registration failed')),
          )
        ],
      ),
    );
  }

  void _register() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
      try {
        await _firestoreService.createUser(
            User(
                name: user.email,
                id: user.uid,
                email: user.email,
                imgUrl: '',
                level: 1,
                visited: new List<Place>()
            )
        );
      } catch (e) {
        return e.message;
      }
    } else {
      _success = false;
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
                _submitButton(),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    focus.dispose();
    super.dispose();
  }
}

class Validator {
  static final RegExp regExpPassword = new RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  static final RegExp regExpEmail = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static bool validatePassword(String password) {
    if (password == null) return false;
    return regExpPassword.hasMatch(password);
  }

  static bool validateEmail(String email) {
    if (email == null) return false;
    return regExpEmail.hasMatch(email);
  }
}
