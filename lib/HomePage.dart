import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UploadTask.dart';
import 'AddTask.dart';
import 'MyTask.dart';
import 'profile.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';



class HomePage extends StatefulWidget {
  

  HomePage({
    this.user,
    this.auth,
    this.onSignedOut,


});
  final FirebaseUser user;

final AuthImplementation auth;
final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() {

    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  
  List<Posts> postList = [];





  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
    DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Tasks");
    postRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postList.clear();

      for(var individualKey in KEYS)
        {
          Posts posts = new Posts(
            DATA[individualKey]['description'],
            DATA[individualKey]['shareDate'],
            DATA[individualKey]['shareTime'],
            DATA[individualKey]['task'],
            DATA[individualKey]['taskDate'],

          );
          postList.add(posts);
        }

        setState(() {
          print('Length : $postList.length');
        });

    });
    
    
    
    
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }


  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget addTask() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn1",
        onPressed:(){ Navigator.push(context,
            MaterialPageRoute(
                builder: (context)=> new AddTask(),
                fullscreenDialog: true));
        },
        tooltip: 'AddTask',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget profile() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn2",
        onPressed:() {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => profile(),
                  fullscreenDialog: true));
        },
        tooltip: 'profile',
        child: Icon(Icons.person),
      ),
    );
  }

  Widget logout() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn3",
        onPressed: _logoutUser,
        tooltip: 'Logout',
        child: Icon(Icons.exit_to_app),
      ),

    );

  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }


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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Container(


        child: postList.length == 0
            ? new Text("no posts available")
            : new ListView.builder(

            itemCount: postList.length
            , itemBuilder: (_, index) {
          // String description ,String shareDate , String shareTime , String task ,String taskDate
          return postUI(postList[index].description, postList[index].shareDate,
              postList[index].shareTime, postList[index].task,
              postList[index].taskDate);
        }

        ),

      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 3.0,
                  0.0,
                ),
                child: addTask()),

            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 2.0,
                0.0,
              ),
              child: profile(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value,
                0.0,
              ),
              child: logout(),
            ),
            toggle(),
          ]
      ),
    );
  }











  Widget postUI(String description ,String shareDate , String shareTime , String task ,String taskDate)

  {

    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(
          vertical: 16.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("assets/users.png"),
        height: 80.0,
        width: 80.0,
      ),
    );


    final planetCard = new Container(

      height: 124.0,
      margin: new EdgeInsets.only(left: 30.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),

          ),
        ],

      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  shareDate,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),

                new Text(
                  shareTime,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )


              ],
            ),
            SizedBox(height: 10.0,),

            Padding(
              padding: const EdgeInsets.only(left:35.0),
              child: new Text(
                task,
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left:40.0),
              child: new Text(
                description,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center,
              ),
            ),


               Padding(
                 padding: const EdgeInsets.only(left:45.0),
                 child: new Text(
                  taskDate,
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,

            ),
               ),


          ],

        ),
      ),
    );


    return new Container(

        height: 150.0,
            margin: const EdgeInsets.symmetric(
           vertical: 5.0,
                horizontal: 24.0,
              ),
        child: new Stack(
            children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
          )
      );




  }

}
