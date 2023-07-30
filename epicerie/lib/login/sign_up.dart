import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epicerie/services/grocery_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function() clickSignIn;
  const SignUp({
    super.key, required this.clickSignIn
  });

 @override
  State<SignUp> createState() =>  _SignUp();
}
  @override
 class _SignUp extends State<SignUp>{
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String messageSignUp = '';

   @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
 
    return  
        LayoutBuilder(
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
                    child:  TextField(
                       decoration: InputDecoration(
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
                          labelText: 'First name',
                          labelStyle: TextStyle(color: Colors.black , fontFamily: GoogleFonts.cabin().fontFamily)),
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                    )
                  ),
                   SizedBox(
                    width: constraints.maxWidth * 0.85,
                    child:  TextField(
                       decoration: InputDecoration(
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
                          labelText: 'Last name',
                          labelStyle: TextStyle(color: Colors.black , fontFamily: GoogleFonts.cabin().fontFamily)),
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                    )
                  ),
                   SizedBox(
                    width: constraints.maxWidth * 0.85,
                    child:  TextField(
                       decoration: InputDecoration(
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
                    )
                  ),
                   SizedBox(
                    width: constraints.maxWidth * 0.85,
                    child:  TextField(
                       decoration: InputDecoration(
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
                  child: Text(messageSignUp, style: const TextStyle(color: Colors.red),),
                  ),
                  SizedBox(
                      width: constraints.maxWidth * 0.5,
                      child: ElevatedButton(
                          onPressed: signUp,
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade300)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.create_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sing up",
                                    style: TextStyle(
                                      fontSize: (constraints.maxWidth * 0.5 * 0.09),
                                    ),
                                  ),
                                )
                              ]))),
                              SizedBox(height: constraints.maxHeight * 0.01,),
                               SizedBox(
                      width: constraints.maxWidth * 0.5,
                      child: ElevatedButton(
                          onPressed: widget.clickSignIn,
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade300)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.keyboard_return_outlined),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                      fontSize: (constraints.maxWidth * 0.5 * 0.09),
                                    ),
                                  ),
                                ),
                              ])),
                              
                              ),
                              SizedBox(height: constraints.maxHeight * 0.01,),

                ]
              )
            )
          )
        )
      ]
      );
     }
    );
  }
  bool validationInput(){
   if (lastNameController.text.isEmpty || firstNameController.text.isEmpty || passwordController.text.isEmpty || emailController.text.isEmpty){
      setState(() {
      messageSignUp = 'Field(s) are empty'; });
      return false;
   }
   if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())){
      setState(() {
         messageSignUp = 'Email is invalid'; 
      });
       return false;
    }
     if (passwordController.text.length < 6) {
                 setState(() {
      messageSignUp = 'Password must be at least 6 characters'; });
      return false;
   }
    return true;
  }


  
  Future<void> signUp() async {
    if (validationInput() == false){
      return;
    }
   GroceriesService provider = Provider.of<GroceriesService>(context, listen: false);
   provider.listGroceries = [];
    List<String> signInMethods = [] ;
try {
    var auth = FirebaseAuth.instance;
   signInMethods = await auth.fetchSignInMethodsForEmail(emailController.text.trim());
  } catch (e) {
    return;
  }
    CollectionReference collectionReference =
     FirebaseFirestore.instance.collection('users');
    if (validationInput()){
      if (signInMethods.isEmpty){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      await collectionReference.add({"email_address": emailController.text.trim(), "first_name" : firstNameController.text.trim(), "last_name" : lastNameController.text.trim(), "grocery_lists" : []});
      widget.clickSignIn;
    } else {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('The email address is already in use.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
       }
    );
       }
    }

    }
  }
  
 
 