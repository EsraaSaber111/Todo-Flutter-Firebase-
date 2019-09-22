import 'package:flutter/material.dart';
import 'loginRegisterPage.dart';
import 'Authentication.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage(
  {
    this.auth,
}
      );




  @override
  State<StatefulWidget> createState() {

    return _MappingPageState();
  }

}

enum AuthState
{
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {

AuthState authState = AuthState.notSignedIn;


@override
  void initState() {

    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authState = firebaseUserId == null ? AuthState.notSignedIn : AuthState.signedIn;
      });
    });
    }


void _signedIn() {
  setState(() {
    authState = AuthState.signedIn;
  });

}



void _signedOut() {
  setState(() {
    authState = AuthState.notSignedIn;
  });

}



@override
Widget build(BuildContext context)
{

  switch(authState)
  {
    case AuthState.notSignedIn:
    return new LoginRegisterPage(
      auth: widget.auth,
      onSignedIn: _signedIn,
    );

    case AuthState.signedIn:
      return new HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
  }



return null;
}




}