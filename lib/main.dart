// Import des packages nécessaires
import 'package:flutter/material.dart';
// Fonction principale - point d'entrée de l'application
void main() {
runApp(MyApp());
}
// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {

// MaterialApp est le widget racine qui configure l'application
return MaterialApp(
title: 'Mon App d\'Authentification',
theme: ThemeData(
primarySwatch: Colors.blue, // Couleur principale
),
home: LoginScreen(), // Premier écran affiché
);
}
}
// Écran de connexion - StatefulWidget car il gère un état (les champs de texte)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

@override
_LoginScreenState createState() => _LoginScreenState();
}
// État de l'écran de connexion
class _LoginScreenState extends State<LoginScreen> {
// Contrôleurs pour récupérer les valeurs des champs de texte
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController =
TextEditingController();
// Variable pour gérer le chargement
bool _isLoading = false;
// Méthode appelée quand on appuie sur le bouton de connexion
void _handleLogin() {
// Récupération des valeurs
String email = _emailController.text;
String password = _passwordController.text;
// Validation basique
if (email.isEmpty || password.isEmpty) {
_showErrorDialog('Veuillez remplir tous les champs');
return;
}
if (!email.contains('@')) {
_showErrorDialog('Veuillez entrer un email valide');
return;
}
// Simulation de connexion
setState(() {
_isLoading = true;
});
// Simulation d'un appel réseau (2 secondes)
Future.delayed(Duration(seconds: 2), () {
setState(() {
_isLoading = false;
});
// Afficher un message de succès
_showSuccessDialog();
});
}

// Méthode pour afficher une erreur
void _showErrorDialog(String message) {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text('Erreur'),
content: Text(message),
actions: [
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: Text('OK'),
),
],
);
},
);
}
// Méthode pour afficher un succès
void _showSuccessDialog() {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text('Succès'),
content: Text('Connexion réussie ! Bienvenue ${_emailController.text}'),
actions: [
TextButton(
onPressed: () {
Navigator.of(context).pop();
// Réinitialiser les champs
_emailController.clear();
_passwordController.clear();
},
child: Text('OK'),
),
],
);
},
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
// Scaffold fournit la structure de base de l'écran
backgroundColor: Colors.grey[100],
body: SafeArea(
// SafeArea évite les zones non sécurisées (encoche, etc.)
child: Padding(
padding: EdgeInsets.all(24.0), // Marge intérieure
child: Column(
mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
children: [
// Titre
Text(

'Connexion',
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),
SizedBox(height: 40), // Espacement
// Champ Email
TextField(
controller: _emailController,
decoration: InputDecoration(
labelText: 'Email',
hintText: 'entrez@votre.email',
prefixIcon: Icon(Icons.email), // Icône avant le texte
border: OutlineInputBorder(), // Bordure
filled: true,
fillColor: Colors.white,
),
keyboardType: TextInputType.emailAddress, // Clavier adapté
),
SizedBox(height: 20), // Espacement
// Champ Mot de passe
TextField(
controller: _passwordController,
decoration: InputDecoration(
labelText: 'Mot de passe',
hintText: 'Entrez votre mot de passe',
prefixIcon: Icon(Icons.lock),
border: OutlineInputBorder(),
filled: true,
fillColor: Colors.white,
),
obscureText: true, // Cache le texte (pour les mots de passe)
),
SizedBox(height: 30),
// Bouton de connexion
_isLoading
? CircularProgressIndicator() // Affiche un indicateur de chargement
: ElevatedButton(
onPressed: _handleLogin,
child: Padding(
padding: EdgeInsets.symmetric(horizontal: 40,
vertical: 15),
child: Text(
'Se connecter',
style: TextStyle(fontSize: 18),
),
),
),
SizedBox(height: 20),
// Lien d'inscription
TextButton(
onPressed: () {

// Pour l'instant, juste un message
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Fonctionnalité d\'inscription à venir !'),
),
);
},
child: Text(
'Créer un compte',
style: TextStyle(color: Colors.blue),
),
),
],
),
),
),
);
}
// Méthode appelée quand le widget est détruit
@override
void dispose() {
// Nettoyer les contrôleurs pour éviter les fuites de mémoire
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}
}