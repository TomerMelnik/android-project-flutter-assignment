
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'SignupUI.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'login.dart';



class UserLogin extends StatelessWidget{
  UserLogin({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  get pass => passwordController.text;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              const SizedBox(height: 15),
              const Text(
                  "Welcome to Startup Name Generator, please log in below"),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Email'
                ),
                controller: emailController,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Password'
                ),
                obscureText: true,
                controller: passwordController,
              ),
              Consumer<AuthRepository>(
                builder: (context, authRep, child){
                  return ElevatedButton(
                    onPressed:  () async{
                      if (authRep.status == Status.Authenticating) {}
                      else {
                        var res = await authRep.signIn(emailController.text, passwordController.text);
                        if (res == true){
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('There was an error logging into the app')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: authRep.status == Status.Authenticating?Colors.grey:Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Log in"),
                  );
                },
              ),
              SignUpButton(userEmailController:emailController, userPasswordController:passwordController).build(context)
            ],
          )
      ),
    );
  }
}