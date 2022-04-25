
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:hello_me/SavedSuggestion.dart';
import 'package:hello_me/login.dart';
import 'package:hello_me/login_screen.dart';
import 'package:hello_me/user_display.dart';
import 'package:hello_me/WordPairUtils.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'dart:ui';
import 'dart:io';



class MainSnapSheet extends StatefulWidget {
  const MainSnapSheet({Key? key}) : super(key: key);


  @override
  _MainSnapSheet createState() => _MainSnapSheet();
}

class _MainSnapSheet extends State<MainSnapSheet>{
  final ScrollController listController = ScrollController();
  final sheetController = SnappingSheetController();

  bool isSheetEnabled = false;

  @override
  Widget build(BuildContext context) {

     return SnappingSheet(
       controller: sheetController ,
       child: Provider.of<RandomWordsNotifier>(context, listen: true).buildSuggestions(),
       lockOverflowDrag: true,
       snappingPositions: getSnappingPositions(),
       grabbing: _UserGrabbingWidget(switchSheetState),
       grabbingHeight: 45,
       sheetAbove: isSheetEnabled ?
       SnappingSheetContent(child: const BlurredBackgroundMask(),
           draggable: false
       ) : null,
       sheetBelow:  SnappingSheetContent(child:UserDisplaySheet(),
       draggable: true) ,
     );


      }


      void switchSheetState(){
        setState(() {
          isSheetEnabled = !isSheetEnabled;
          sheetController.setSnappingSheetFactor( isSheetEnabled ? 0.20 : 0.03);
        });

      }


      List<SnappingPosition> getSnappingPositions(){
       if(isSheetEnabled){
         return const [SnappingPosition.factor(
           grabbingContentOffset: GrabbingContentOffset.bottom,
           snappingCurve: Curves.easeInExpo,
           snappingDuration: Duration(seconds: 1),
           positionFactor: 0.03,
         ),
           SnappingPosition.factor(
             grabbingContentOffset: GrabbingContentOffset.bottom,
             snappingCurve: Curves.easeInExpo,
             snappingDuration: Duration(seconds: 1),
             positionFactor: 1,
           )];

       }
       else{
         return const [SnappingPosition.factor(
           grabbingContentOffset: GrabbingContentOffset.bottom,
           snappingCurve: Curves.easeInExpo,
           snappingDuration: Duration(seconds: 1),
           positionFactor: 0.08,
         )];
       }


      }

  }







class _UserGrabbingWidget extends StatelessWidget{
  Function() switchSheetStateFunc;
  String userEmail = "";
  _UserGrabbingWidget(this.switchSheetStateFunc);

  @override
  Widget build(BuildContext context,) {
  userEmail = Provider.of<AuthRepository>(context, listen: false).user!.email!;

    return GestureDetector(
       onTap: ()=>switchSheetStateFunc(),
        child: Container(
        alignment: Alignment.centerLeft,
          color:  Color(0xFFCFD8DC),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20,), child:
             Text(
                "Welcome back, $userEmail",
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black,
            fontSize: 16,
          )
            )
         )
      ,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(Icons.keyboard_arrow_up_sharp),
      ),



          ],
        ),
      )
    );

  }

}






class BlurredBackgroundMask extends StatelessWidget {
  const BlurredBackgroundMask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.5,
          sigmaY: 2.5,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
