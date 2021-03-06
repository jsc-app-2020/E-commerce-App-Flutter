import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shop_app/Screens/Login/login_screen.dart';
import 'package:shop_app/Screens/Signup/components/background.dart';
import 'package:shop_app/Screens/Signup/components/or_divider.dart';
import 'package:shop_app/Screens/Signup/components/social_icon.dart';
import 'package:shop_app/components/already_have_an_account_acheck.dart';
import 'package:shop_app/components/rounded_button.dart';
import 'package:shop_app/components/rounded_input_field.dart';
import 'package:shop_app/components/rounded_password_field.dart';
import 'package:shop_app/models/SignUp.dart';
import 'package:shop_app/network/SignUpData.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email, password;

  // File _image;

  Future<SignUp> _futureSignUp;

  //
  // Future<void> getImage() async {
  //   var image = await ImagePicker().getImage(source: ImageSource.gallery);
  //   final File file = File(image.path);
  //   setState(() {
  //     _image = file;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (_futureSignUp == null)
        ? Background(
            child: ModalProgressHUD(
              inAsyncCall: false,
              child: buildSingleChildScrollView(size, context),
            ),
          )
        : buildFutureBuilder(size);
  }

  FutureBuilder<SignUp> buildFutureBuilder(Size size) {
    return FutureBuilder<SignUp>(
      future: _futureSignUp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (int.parse(snapshot.data.code) == 200) {
            Fluttertoast.showToast(
                msg: "Sign Up Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            return LoginScreen();
          } else {
            Fluttertoast.showToast(
                msg: "Register Failed!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return Background(
              child: ModalProgressHUD(
                inAsyncCall: false,
                child: buildSingleChildScrollView(size, context),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return throw Exception(snapshot.error);
        }

        return ModalProgressHUD(
          inAsyncCall: true,
          child: buildSingleChildScrollView(size, context),
        );
      },
    );
  }

  SingleChildScrollView buildSingleChildScrollView(
      Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              email = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              password = value;
            },
          ),
          RoundedButton(
            text: "SIGNUP",
            press: () {
              setState(() {
                if (email == null || password == null) {
                  Fluttertoast.showToast(
                      msg: "Field Cannot be null!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  _futureSignUp = createSignUp(email, password);
                }
              });
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          OrDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SocalIcon(
                iconSrc: "assets/icons/facebook.svg",
                press: () {},
              ),
              SocalIcon(
                iconSrc: "assets/icons/twitter.svg",
                press: () {},
              ),
              SocalIcon(
                iconSrc: "assets/icons/google-plus.svg",
                press: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
