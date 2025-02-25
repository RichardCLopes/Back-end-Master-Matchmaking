import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:fys/builders.dart';
import 'package:fys/http.dart';
import 'package:fys/main.dart';
import 'package:fys/pages/Comunities.dart';
import 'package:fys/pages/ShootNPick.dart';
import 'package:fys/pages/DirectChat.dart';
import 'package:fys/pages/SideMenu.dart';
import 'package:fys/pages/EditProfile.dart';

import 'dart:typed_data';

double buttonWidth = 135;
double buttonHeigth = 50;
double fontsize = 17;

class Member {
  final String id;
  final String name;
  final String picture;

  const Member(
      {required this.id,
      required this.name,
      this.picture = "assets/images/placeholder.png"});
}

List<Widget> MemberWidgetList(BuildContext context, List<Member> MemberList) {
  var widgetList = <Widget>[];
  int j = 0;
  var rowList = <Widget>[];
  Widget userfoto = Image.asset(
    "assets/images/placeholder.png",
    fit: BoxFit.scaleDown,
  );
  for (int I = 0; I < MemberList.length; I++) {
    if (MemberList[I].picture.isNotEmpty) {
      Uint8List bytesImage;
      String imgString = MemberList[I].picture;
      bytesImage = Base64Decoder().convert(imgString.substring(22));
      userfoto = Image.memory(
        bytesImage,
        fit: BoxFit.scaleDown,
      );
    } else {
      userfoto = Image.asset(
        "assets/images/placeholder.png",
        fit: BoxFit.scaleDown,
      );
    }

    rowList.add(
      Container(
        height: 160,
        width: 100,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
        child: ElevatedButton(
          onPressed: () => PushScreen(
              context, chatPage(MemberList[I].id, MemberList[I].name)),
          style: ElevatedButton.styleFrom(primary: Color(0x00000000)),
          child: Stack(
            children: [
              userfoto,
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  MemberList[I].name,
                  style: TextStyle(
                    fontFamily: 'alagard',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    j++;
    if (j >= 3 || I == MemberList.length - 1) {
      widgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowList,
      ));
      j = 0;
      rowList = <Widget>[];
    }
  }
  return widgetList;
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Widget _mainpart = CircularProgressIndicator();

  @override
  void initState() {
    LoadMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideMenu(),
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        centerTitle: true,
        title: Text('Messages'),
        actions: <Widget>[
          IconButton(
              onPressed: (() => PushScreen(context, EditProfilePage())),
              icon: Icon(Icons.account_circle_outlined)),
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 550,
            child: _mainpart,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: buttonWidth,
                height: buttonHeigth,
                // ignore: unnecessary_new
                child: SizedBox.expand(
                  child: ElevatedButton(
                    child: Text(
                      "Mensagens",
                      style: TextStyle(
                          fontFamily: 'alagard',
                          color: Color.fromARGB(255, 224, 224, 224),
                          fontSize: fontsize),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 40, 6, 49),
                      side: BorderSide(
                          color: Color.fromARGB(255, 51, 225, 255), width: 1),
                      // ignore: unnecessary_new
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: buttonWidth,
                height: buttonHeigth,

                // ignore: unnecessary_new
                child: SizedBox.expand(
                  child: ElevatedButton(
                    child: Text(
                      "Shoot n Pick",
                      style: TextStyle(
                          fontFamily: 'alagard',
                          color: Color.fromARGB(255, 224, 224, 224),
                          fontSize: fontsize),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () => SwitchScreen(context, ShootnPickPage()),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 40, 6, 49),
                      side: BorderSide(
                          color: Color.fromARGB(255, 51, 225, 255), width: 1),
                      // ignore: unnecessary_new
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: buttonWidth,
                height: buttonHeigth,
                // ignore: unnecessary_new
                child: SizedBox.expand(
                  child: ElevatedButton(
                    child: Text(
                      "Comunidades",
                      style: TextStyle(
                          fontFamily: 'alagard',
                          color: Color.fromARGB(255, 224, 224, 224),
                          fontSize: fontsize),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () => SwitchScreen(context, ComunitiesPage()),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 40, 6, 49),
                      side: BorderSide(
                          color: Color.fromARGB(255, 51, 225, 255), width: 1),
                      // ignore: unnecessary_new
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }

  void LoadMembers() {
    print("carregando membros");
    List<Member> memberList = [];

    getMatches().then((value) {
      String foto = '';

      print("membros carregados");
      setState(() {
        for (var member in value) {
          if (member[7] != null && member[7].isNotEmpty) {
            foto = member[7];
          }
          memberList.add(Member(id: member[0], name: member[1], picture: foto));
        }
        if (memberList.isNotEmpty)
          _mainpart = ListView(children: MemberWidgetList(context, memberList));
        else
          _mainpart = Text(
            "não tem nenhum match!",
            style: TextStyle(
                fontFamily: 'alagard',
                color: Color.fromARGB(255, 224, 224, 224),
                fontSize: fontsize),
          );
      });
    });
  }
}
