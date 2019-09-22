import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:agenda_contatos/utils/imageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  const ContactPage({this.contact, Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 000.00.00-00');
  final _focusName = FocusNode();
  final _focusPhone = FocusNode();

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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
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
                      border: Border.all(width: 2.0, color: Colors.grey),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: ContactUtil.imageContact(_editedContact)),
                    ),
                  ),
                  onTap: () {
                    _showOptions(context);
                  } ,
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
                  focusNode: _focusPhone,
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (String value) {
                    _userEdited = true;
                    _editedContact.phone = value;
                  },
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: true,
            child: showFloatingActionButton(_focusPhone.hasFocus),
          )),
    );
  }

  Future<void> _getImageCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image == null) {
        return;
      } else {
        setState(() {
          _editedContact.img = image.path;
        });
      }
    });
  }
    Future<void> _getImageGalery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image == null) {
        return;
      } else {
        setState(() {
          _editedContact.img = image.path;
        });
      }
    });
  }
  void _showOptions(BuildContext context) {
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
                              Icon(Icons.photo_album),
                              Text(
                                "Galeria",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          color: Colors.red,
                          padding: EdgeInsets.all(7.0),
                          onPressed: () {
                            _getImageGalery();
                            Navigator.pop(context);
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
                              Icon(Icons.photo_camera),
                              Text(
                                "Camera",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          color: Colors.blue,
                          padding: EdgeInsets.all(7.0),
                          onPressed: () {
                            _getImageCamera();
                            Navigator.pop(context);

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
  Future<bool> _requestPop() async {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return await Future.value(false);
    } else {
      return await Future.value(true);
    }
  }

  Widget showFloatingActionButton(bool onFocus) {
    return onFocus == true
        ? showFloatingActionButtonHideKeyBoard()
        : showFloatingActionButtonSave();
  }

  Widget showFloatingActionButtonHideKeyBoard() {
    return FloatingActionButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Icon(
        Icons.close,
        size: 20.0,
      ),
      backgroundColor: Colors.pink,
      tooltip: "Fechar teclado",
    );
  }

  Widget showFloatingActionButtonSave() {
    return FloatingActionButton(
      onPressed: () {
        if ((_editedContact.nome != null && _editedContact.nome.isNotEmpty) &&
            (_editedContact.phone != null && _editedContact.phone.isNotEmpty)) {
          Navigator.pop(context, _editedContact);
        } else {
          FocusScope.of(context).requestFocus(_focusName);
        }
      },
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
      tooltip: "Salvar contato",
    );
  }
}
