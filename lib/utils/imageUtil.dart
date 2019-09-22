import 'dart:io';

import 'package:agenda_contatos/helpers/contactHelper.dart';
import 'package:flutter/material.dart';

class ContactUtil {

 static ImageProvider imageContact(Contact contact) {
    return contact.img != null
        ? FileImage(File(contact.img))
        : AssetImage("imagens/person.png");
  }
}
