import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:agenda_contatos/utils/imageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  const ContactPage({this.contact, Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

final _nameController = TextEditingController();
final _emailController = TextEditingController();
var _phoneController =  MaskedTextController(mask: '(00) 000.00.00-00');
final _focusName = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.nome ?? "Novo Contato"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: ContactUtil.imageContact(_editedContact)),
                ),
              ),
            ),
            TextField(
              focusNode: _focusName,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (String value) {
                _userEdited = true;
                setState(() {
                  _editedContact.nome = value;
                });
              },
              controller: _nameController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (String value) {
                _userEdited = true;
                _editedContact.email = value;
              },
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (String value) {
                _userEdited = true;
                _editedContact.phone = value;
              },
              keyboardType: TextInputType.phone,
              controller: _phoneController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if( (_editedContact.nome != null &&_editedContact.nome.isNotEmpty) && (_editedContact.phone != null && _editedContact.phone.isNotEmpty) ){
            Navigator.pop(context, _editedContact);
          }else {
            FocusScope.of(context).requestFocus(_focusName);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
        tooltip: "Salvar contato",
      ),
    );
  }
}
