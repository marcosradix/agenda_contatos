
import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:agenda_contatos/ui/contactPage.dart';
import 'package:agenda_contatos/utils/imageUtil.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
 /*  Contact c = Contact();
    c.nome = "João Marcos Feitosa";
    c.email = "joao.feitosa@gmail.com";
    c.phone = "987178890";
    c.img = null;
    helper.saveContact(c);  */
/* helper.getContactById(2).then((c) {
c.img = null;
c.nome = "Gustavo Farias";
helper.updateContact(c);
}); */

_loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Agenda de contatos",
            style: new TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(onPressed: () => _showContactPage(),
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      tooltip: "Adicionar contato",
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
              image: ContactUtil.imageContact(contacts[index])
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
    onTap: ()=> _showContactPage(contact: contacts[index]),
  );
}

void _showContactPage({Contact contact}) async {
  final recContact = await  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

  if(recContact != null){
    if(contact != null){
      await helper.updateContact(recContact);
    }else{
      await helper.saveContact(recContact);
    }
       _loadContacts();
  } 
}

  void _loadContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        this.contacts = list;
      });
    });
}

}
