import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'login.dart';


class SignUpButton extends StatelessWidget {
  final userEmailController;
  final userPasswordController;

  SignUpButton({Key? key, required this.userEmailController, required this.userPasswordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return PasswordConfirmSheet(
                userEmailController: userEmailController,
                userPasswordController: userPasswordController,
              );
            });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        primary: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text("New user? Click here to sign up"),
    );
  }


}


class PasswordConfirmSheet extends StatefulWidget {
  final userEmailController;
  final userPasswordController;


  PasswordConfirmSheet(
      {Key? key, required this.userEmailController, required this.userPasswordController})
      : super(key: key);

  @override
  _PasswordConfirmSheetState createState() =>
      _PasswordConfirmSheetState(userEmailController, userPasswordController);


}

class _PasswordConfirmSheetState extends State<PasswordConfirmSheet> {
  final userEmailController;
  final userPasswordController;
  bool _validate = true;
  final _passwordConfirmController = TextEditingController();


  _PasswordConfirmSheetState(this.userEmailController, this.userPasswordController);

  @override
  Widget build(BuildContext context,) {
    return Consumer<AuthRepository>(builder: (context, authRep, child){
      return Padding(
        padding: MediaQuery
            .of(context)
            .viewInsets,
        child: Container(
          height: 260,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const ListTile(
                      title: Text("Please confirm your password below:",
                        textAlign: TextAlign.center,
                        //style: TextStyle(color: Colors.black)
                      ))),
              const Divider(),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _validate ? null : "Passwords must Match"
                    ),
                    obscureText: true,
                    controller: _passwordConfirmController,

                  )),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  if (_passwordConfirmController.text == userPasswordController.text) {
                    authRep.signUp(userEmailController.text, userPasswordController.text).then((value) {
                      if (value != null) {
                        FirebaseFirestore.instance.collection('hw3').doc(
                            "data").collection("users")
                            .doc(authRep.user!.uid)
                            .update(
                            {"avatar_ref": ""})
                            .then((value) {});
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          _validate = true;
                        });
                      }
                    },
                    );
                  } else {
                    setState(() {
                      _validate = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  //minimumSize: const Size.fromHeight(20),
                  primary: Colors.lightBlue,
                ),
                child: const Text("Confirm")
              )
            ],
          ),
        ),
      );
  });
  }


}
