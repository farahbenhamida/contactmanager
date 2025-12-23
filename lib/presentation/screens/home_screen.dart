import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ContactProvider>(context, listen: false).loadContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.contacts.isEmpty) return const Center(child: Text('No contacts found'));
          
          return ListView.builder(
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
              final contact = provider.contacts[index];
              return ListTile(
                leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.deleteContact(contact.id),
                ),
                onTap: () => _showContactDialog(context, contact: contact),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showContactDialog(BuildContext context, {dynamic contact}) {
    final nameController = TextEditingController(text: contact?.name);
    final phoneController = TextEditingController(text: contact?.phone);
    final emailController = TextEditingController(text: contact?.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ContactProvider>(context, listen: false);
              if (contact == null) {
                provider.addContact(nameController.text, phoneController.text, emailController.text);
              } else {
                provider.updateContact(contact.id, nameController.text, phoneController.text, emailController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
