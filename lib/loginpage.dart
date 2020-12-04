import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colorcheme.dart';
import 'calander.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {


  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  String _email = "aw@gmail.com";
  String _password = "123";

  Future checkLogin()async{
    if (emailCon.text == _email && passCon.text == _password) {

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', emailCon.text);

      Navigator.push(context, MaterialPageRoute(builder: (context)=>calendarPage(),),);
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
          msg: "Username & Password Invalid!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  final GlobalKey<FormState> _loginkey = GlobalKey<FormState>();
  bool passwordVisible = false;

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        controller: emailCon,
        keyboardType: TextInputType.emailAddress,
        validator: (input) {
          if (input.isEmpty) {
            return 'Please enter an email';
          }
        },
        onSaved: (input) => _email = input,
        onChanged: (value) {
          setState(() {
            _email = value;
          });
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: mainColor,
            ),
            labelText: 'E-mail'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        controller: passCon,
        keyboardType: TextInputType.text,
        obscureText: !passwordVisible,
        validator: (input) {
          if (input.length < 6) {
            return 'Please enter an password having at least 6 characters';
          }
        },
        onSaved: (input) => _password = input,
        onChanged: (value) {
          setState(() {
            _password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: mainColor,
          ),
          hintText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).textTheme.bodyText2.color,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }
            // Update the state i.e. toogle the state of passwordVisible variable

          ),
        ),
      ),
    );
  }

  // Widget _buildForgetPasswordButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.only(left: 10),
  //         child: FlatButton(
  //           onPressed: () {},
  //           child: Text("Forgot Password ?"),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 10, top: 10),
          child: RaisedButton(
            elevation: 4.0,
            color: logincolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: (){
              checkLogin();
            },
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildEmailRow(),
                _buildPasswordRow(),
                //_buildForgetPasswordButton(),
                _buildLoginButton(),

              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Manager'),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          key: _loginkey,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildContainer(),
                //_buildSignUpBtn(),
              ],
            )
          ],
        ),
      ),
    );
  }



  // Future<String> login() async {
  //   final formstate = _loginkey.currentState;
  //   try {
  //     UserCredential user = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: _email, password: _password);
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => calendarPage()));
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }
}