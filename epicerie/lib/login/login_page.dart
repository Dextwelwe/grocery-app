import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/grocery_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback clickSignUp;
  const LoginPage({Key? key , required this.clickSignUp}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String messageLogIn = '';
  
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                 color: Colors.teal.shade100,
              ),
              width: constraints.maxWidth * 0.95,
              child: Column(
                children: <Widget>[
                  SizedBox(height: constraints.maxHeight * 0.01,),
                  SizedBox(
                    width: constraints.maxWidth * 0.85,
                    child: TextField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.mail_outlined),
                          iconColor: Colors.teal,
                          enabledBorder: const UnderlineInputBorder(
                           borderSide: BorderSide(
                            color: Colors.teal
                           ),
                          ),
                          focusedBorder:const UnderlineInputBorder(
                           borderSide: BorderSide(
                            color: Colors.teal
                           ),
                          ),       
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black , fontFamily: GoogleFonts.cabin().fontFamily)),
                      controller: emailController,
                      
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  SizedBox(
                     width: constraints.maxWidth * 0.85,
                    child: TextField(
                      cursorColor: Colors.teal,
                       decoration:  InputDecoration(
                          icon: const Icon(Icons.lock_outline_rounded),
                          iconColor: Colors.teal,
                          enabledBorder: const UnderlineInputBorder(
                           borderSide: BorderSide(
                            color: Colors.teal
                           ),
                          ),
                          focusedBorder:const UnderlineInputBorder(
                           borderSide: BorderSide(
                            color: Colors.teal
                           ),
                          ),       
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black , fontFamily: GoogleFonts.cabin().fontFamily)),   
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(
                    child: Text(messageLogIn, style: const TextStyle(color: Colors.red)),
                  ),
                  
                  SizedBox(
                      width: constraints.maxWidth * 0.5,
                      child: ElevatedButton(
                          onPressed: _signIn,
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade300)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_open_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: (constraints.maxWidth * 0.5 * 0.09),
                                    ),
                                  ),
                                )
                              ]))),
                              SizedBox(height: constraints.maxHeight* 0.01,),
                  SizedBox(
                      width: constraints.maxWidth * 0.5,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade300)),
                          onPressed: widget.clickSignUp,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.app_registration_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: (constraints.maxWidth * 0.5 * 0.09),
                                    ),
                                  ),
                                )
                              ]))),
                              SizedBox(height: constraints.maxHeight * 0.01,),
                ],
              ),
            ),
          ),
        )
      ]);
    });
  }

  bool _validateEntrySignIn(){
      if (emailController.text.isEmpty || passwordController.text.isEmpty){
      setState(() {
         messageLogIn = 'Fields are empty'; 
      });
      return false;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())){
      setState(() {
        messageLogIn = 'Email is invalid'; 
     });
      return false;
    }
    return true;
  }

  Future _signIn() async {
    if (_validateEntrySignIn() == false){
      return;
    }
        try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
          widget.clickSignUp;
          // ignore: use_build_context_synchronously
          GroceriesService provider = Provider.of<GroceriesService>(context, listen: false);
          provider.getGroceriesAuthUser();
    } on FirebaseException catch (e)  {
      if (e.code == 'wrong-password'){ 
return _dialog('Incorrect password', 'The password is incorrect. Please try again.');
      }
      if (e.code == 'user-not-found') {
    return 
    _dialog('Email not found', 'This email doesn\'t exist');
  }
  if (e.code == 'too-many-requests') {
 return  _dialog('Too many requests', 'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.');
 }
}
  }

  Future<dynamic> _dialog(String title, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content:  Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}