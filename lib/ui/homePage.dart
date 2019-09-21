import 'dart:io';

import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
 /*    Contact c = Contact();
    c.nome = "Marcos Ferreira severino";
    c.email = "marcosradix@gmail.com";
    c.phone = "999575446";
    c.img = "imgTeste";
    helper.saveContact(c); */
    helper.getAllContacts().then((list) {
      print(list);
      setState(() {
        this.contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de contatos",
            style: new TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: (){},
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        },
        )
    );
  }

Widget _contactCard(BuildContext context, int index){
  return GestureDetector(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
              image: _imageContact(index)
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(contacts[index].nome ?? "",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),),
                Text(contacts[index].email ?? "",
                style: TextStyle(fontSize: 18.0),),
                Text(contacts[index].phone ?? "",
                style: TextStyle(fontSize: 18.0),),
              ],
            ),
          )
        ],
        ),
      ),
    ),
  );
}

ImageProvider _imageContact(int index){
return contacts[index].img != null ? FileImage(File(contacts[index].img)) : AssetImage("imagens/person.png");
//return AssetImage("imagens/person.png");
}

}
