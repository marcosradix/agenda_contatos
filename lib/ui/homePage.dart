import 'package:agenda_contatos/callMessageService/callsAndMessagesService.dart';
import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:agenda_contatos/ui/contactPage.dart';
import 'package:agenda_contatos/utils/imageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    setupLocator();
    return _HomePageState();
  } 
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();




  @override
  void initState() {
    super.initState();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showContactPage(),
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          tooltip: "Adicionar contato",
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          },
        ));
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.grey),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ContactUtil.imageContact(contacts[index])),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        HapticFeedback.mediumImpact();
        _service.call(contacts[index].phone);
      } ,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.delete_forever),
                              Text(
                                "Apagar",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          color: Colors.red,
                          padding: EdgeInsets.all(7.0),
                          onPressed: () {
                            helper.deleteContact(contacts[index].id);
                            Navigator.pop(context);
                            contacts.removeAt(index);
                            _loadContacts();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.edit),
                              Text(
                                "Editar",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          color: Colors.blue,
                          padding: EdgeInsets.all(7.0),
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
            ));
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
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
GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}