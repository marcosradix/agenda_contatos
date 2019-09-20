import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

ContactHelper helper = ContactHelper();

@override
  void initState() {
    super.initState();
/*     Contact c = Contact();
    c.nome = "Marcos Ferreira severino";
    c.email = "marcosradix@gmail.com";
    c.phone = "999575446";
    c.img = "imgTeste";
    helper.saveContact(c); */
helper.getAllContacts().then((list){
print(list);
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de contatos",
        style: new TextStyle(color: Colors.white)),
      ),
      body: Container(),
    );
  }
}