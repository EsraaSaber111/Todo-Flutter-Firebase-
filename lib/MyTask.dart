import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';
import 'Authentication.dart';
import 'AddTask.dart';




class MyTask extends StatefulWidget{

  MyTask({this.user,
    this.auth,
    this.onSignedOut,});

  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final FirebaseUser user;

  @override
  State<StatefulWidget> createState() {

    return new _MyTaskState();
  }

}

class _MyTaskState extends State<MyTask> {




  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch (e) {
      print(e.toString());
    }
  }




  @override
  Widget build(BuildContext context) {
    return  new Scaffold(

      appBar: new AppBar(
        title: new Text("Upload Task"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed:(){ Navigator.push(context,
            MaterialPageRoute(
            builder: (context)=> new AddTask(),
          fullscreenDialog: true));
        },
        child: Icon (Icons.add),
        backgroundColor: Colors.deepPurpleAccent,

      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: new BottomAppBar(
      elevation: 20.0,
      color: Colors.deepPurpleAccent,
      child: ButtonBar(
        children: <Widget>[],
      ),
    ),


      body: Container(
        height: 170.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          boxShadow: [
            new BoxShadow(
                color: Colors.deepPurple,
                blurRadius: 8.0
            )
          ],

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0, height: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: new AssetImage('assets/logo.png'),
                            fit: BoxFit.cover
                        )
                    ),
                  ),


                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("Welcome", style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                new IconButton(icon: Icon(Icons.exit_to_app , color: Colors.white, size: 30.0,),
                    onPressed: _logoutUser)
                ],
              ),
            ),
            new Text("My Task" , style: new TextStyle(
                color: Colors.white,
            fontSize:  30.0,
            letterSpacing: 2.0,

            ),)
          ],
        ),
      ),
    );
  }
}