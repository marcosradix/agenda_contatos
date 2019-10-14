import 'package:agenda_contatos/ui/homePage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'callMessageService/callsAndMessagesService.dart';
import 'notifier/focusNotifier.dart';

final CallsAndMessagesService service = locator<CallsAndMessagesService>();

void main() {
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(builder: (context) => FocusNotifier(false)),
    ],
    child: MaterialApp(
      color: Colors.red,
      title: "Agenda de contatos",
      home: HomePage(service),
    ),
  ));
}

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
