import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
 LoginRegisterPage({
   this.auth,
   this.onSignedIn,
});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }

}

enum FormType
{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegisterPage> {

  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email="";
  String _password="";



  //methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate())
      {
        form.save();
        return true;
      }
    else
      {
        return false;
      }

  }
  void validateAndSubmit() async{
    if(validateAndSave())
      {
        try
            {
             if(_formType == FormType.login)
               {
                 String userId = await widget.auth.SignIn(_email,_password);
                 dialogBox.information(context, "congratulations", "you are logged in successfullyf.");

                 print("login userId = " + userId);
               }
               else{
               String userId = await widget.auth.SignUp(_email,_password);
              // dialogBox.information(context, "congratulations", "your account has been created successfully.");

               print("Register userId = " + userId);
             }

             widget.onSignedIn();
            }
            catch(e)
            {
              //dialogBox.information(context, "error", e.toString());
              print("Error =" + e.toString());

            }
      }

  }


  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });

  }


  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });

  }




  //design
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Blog"),
      ),
      body: new Container(

        child: new Form(
          key: formKey,
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: createInputs() + createButton(),
        )),
      ),
    );
  }

  List<Widget> createInputs() {
    return [

       SizedBox(height: 10.0,),
         logo(),

       SizedBox(height: 20.0,),


       Padding(
         padding: const EdgeInsets.all(8.0),
         child: new TextFormField(
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecoration(
             hintText: "Enter Your Email",
           ),
           validator: (value)
             {
               return value.isEmpty ? 'Email is required.' : null;
             },
           onSaved: (value)
           {
             return _email = value;
           },

      ),
       ),

       SizedBox(height: 20.0,),


       Padding(
         padding: const EdgeInsets.all(8.0),
         child: new TextFormField(
           obscureText: true,
           decoration: InputDecoration(
             hintText: "password",
           ),
           validator: (value)
           {
             return value.isEmpty ? 'Password is required.' : null;
           },
           onSaved: (value)
           {
             return _password = value;
           },

         ),
       ),

       SizedBox(height: 20.0,),
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0,
        child: Image.asset('assets/check.png'),
      ),
    );
  }

  List<Widget> createButton() {
    if(_formType == FormType.login){
      return [
        RaisedButton(
            color: Color(0xFFFA7397),
            onPressed: validateAndSubmit,
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.orangeAccent),
            )),


         new Text("Not Have Account??creat An Account",
              style: new TextStyle(fontSize: 10.0)),

        RaisedButton(
            color: Color(0xFFFA7397),
            onPressed: moveToRegister,
            child: const Text(
              "SignUp",
              style: TextStyle(color: Colors.orangeAccent),
            )),

      ];


    }


    else{
      return [
        new RaisedButton(
          child: new Text("create Acount", style: new TextStyle(fontSize: 10.0)),
          textColor: Colors.orangeAccent,
          color:Color(0xFFFA7397),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text("Already Have An Account ? login",
              style: new TextStyle(fontSize: 10.0)),
          textColor: Colors.orangeAccent,
          onPressed: moveToLogin,
        )
      ];

    }
  }


}
