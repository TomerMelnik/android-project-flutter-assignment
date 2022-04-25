
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'SavedSuggestion.dart';
import 'login.dart';
import 'login_screen.dart';
import 'package:hello_me/WordPairUtils.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';




class UserDisplaySheet extends StatefulWidget{
  const UserDisplaySheet({Key? key}) : super(key: key);

  @override
  _UserDisplaySheetState createState() => _UserDisplaySheetState();


}

class _UserDisplaySheetState extends State<UserDisplaySheet>{
  var uid = "";
  String userEmail = "";
  String _avatarRefPath = "";
  String _avatarURL = "";
  var avatarImage = null;
  final _fireStore =  FirebaseFirestore.instance;
  final _imageStorage = FirebaseStorage.instance;
  final defaultImage = const NetworkImage('https://www.looper.com/img/gallery/why-aangs-power-in-avatar-the-last-airbender-is-more-terrifying-than-you-think/intro-1616420787.jpg');



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Row(

            children: [
              // Container(
              //     height: 40,
              //     width: 40,
              //     decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         image: avatarImage == null ?const DecorationImage(image: AssetImage('assets/Aang'))
              //         : DecorationImage(image: avatarImage))),
               Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(backgroundColor: Colors.transparent,
                  radius: 40 ,backgroundImage: avatarImage ?? defaultImage
                  ,
                ),
              ),
                Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        ),
                        onPressed: () => _changeAvatar(),
                        child: const Text(
                          "Change avatar",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    uid = Provider.of<AuthRepository>(context, listen: false).user!.uid.toString();
    userEmail = Provider.of<AuthRepository>(context, listen: false).user!.email!;
    _loadAvatar();
  }

  void _loadAvatar() async{
    //
    //  _fireStore.collection("hw3").doc("data").collection("users").doc(uid).get().then((value)
    //  {
    //    final data = value.data();
    //    var avatar_ref = data == null? null :data["avatar_ref"];
    //    _avatarRefPath = avatar_ref == null? "Aang" : uid;
    //  });
    //
    // Reference avatarRef = _imageStorage.ref().child('$_avatarRefPath.jpeg');
    //  print(avatarRef);
    // print(_avatarRefPath);
    // String url = await avatarRef.getDownloadURL();
    //
    // setState(() {
    //   _avatarURL = url;
    //   avtarImage =  Image.network(_avatarURL,height: 40, width: 40)
    //   ;
    // });

    _avatarURL = await _imageStorage
        .ref('/users/$uid')
        .getDownloadURL();
    print("download url is: $_avatarURL");
    avatarImage = Image.network(_avatarURL,height: 40, width: 40);

  }


  void _changeAvatar() async{

    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null){
        print("image path not found");
        return;
    }


    _imageStorage
        .ref('users/').child(uid)
        .putFile(File(image.path))
        .then(
            (value) async {
          _avatarURL = await _imageStorage
              .ref('users/').child(uid)
              .getDownloadURL();
          setState(() {});
          avatarImage =  Image.network(_avatarURL,height: 40, width: 40);
          setState(() {});

  });
    }
}