import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import 'add_edit_contact_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Contacts'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          if (contactProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contactProvider.contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contacts, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun contact trouvé',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Appuyez sur le bouton + pour ajouter un contact',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: contactProvider.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactProvider.contacts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      contact.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📞 ${contact.phone}'),
                      if (contact.email != null && contact.email!.isNotEmpty)
                        Text('📧 ${contact.email!}'),
                      if (contact.address != null && contact.address!.isNotEmpty)
                        Text('🏠 ${contact.address!}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _showDeleteDialog(context, contact),
                  ),
                  onTap: () => _showContactDetails(context, contact),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditContactScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le contact'),
        content: Text('Voulez-vous vraiment supprimer ${contact.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ContactProvider>(context, listen: false)
                  .deleteContact(contact.id!);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${contact.name} a été supprimé'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📞 ${contact.phone}'),
            if (contact.email != null && contact.email!.isNotEmpty)
              Text('📧 ${contact.email!}'),
            if (contact.address != null && contact.address!.isNotEmpty)
              Text('🏠 ${contact.address!}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}