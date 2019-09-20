import 'contactHelper.dart';

abstract class IContactHelper {
  Future<Contact> saveContact(Contact contact);
  Future<Contact> getContactById(int id);
  Future<int> deleteContact(int id);
  Future<int> updateContact(Contact contact);
  Future<List<Contact>> getAllContacts();
  Future<int> getNumber();
}
