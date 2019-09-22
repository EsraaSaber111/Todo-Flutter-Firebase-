import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'MyTask.dart';



class UploadTask extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UploadTaskState ();
  }

}

class _UploadTaskState extends State<UploadTask> {



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Task"),
        centerTitle: true,
      ),
      body: Container(
        height: 170.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black38,
          boxShadow: [
            new BoxShadow(
                color: Colors.black,
                blurRadius: 8.0
            )
          ],

        ),
        child: Padding(
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
              ]
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFA7397),
        child: Icon(
          FontAwesomeIcons.listUl,
          color: Color(0xFFDDE42),

        ),
        onPressed: ()
        {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context)=> MyTask(),
                fullscreenDialog: true),
          );
        },
      ),
    );
  }


  Widget enablwUpload()
  {

  }




}
