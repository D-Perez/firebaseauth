import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter login demo"),
      ),
      body: Container(
        child: Text("Hello World"),
      ),
    );
  }
}