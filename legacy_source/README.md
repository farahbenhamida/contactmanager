# Contact Manager App

Une application mobile de gestion de contacts développée avec Flutter et FastAPI.

## Architecture

Le projet est divisé en deux parties principales :
- `backend/` : API REST développée avec FastAPI et SQLite.
- `mobile/` : Application mobile développée avec Flutter.

### Choix Techniques

- **Backend** : FastAPI pour sa rapidité et sa facilité de création d'APIs REST. SQLAlchemy pour l'ORM et la gestion de la base de données SQLite.
- **Mobile** : Flutter pour le développement cross-platform. Utilisation du package `http` pour la communication avec le backend.
- **Base de données** : SQLite pour la simplicité et la persistance locale (côté serveur).

## Prérequis

- Python 3.9+
- Flutter SDK
- Android Emulator / iOS Simulator

## Instructions d'Installation et d'Exécution

### 1. Backend

1. Naviguez dans le dossier `backend` :
   ```bash
   cd backend
   ```

2. Créez un environnement virtuel (optionnel mais recommandé) :
   ```bash
   python -m venv venv
   # Windows
   .\venv\Scripts\activate
   # Linux/Mac
   source venv/bin/activate
   ```

3. Installez les dépendances :
   ```bash
   pip install -r requirements.txt
   ```

4. Lancez le serveur :
   ```bash
   python main.py
   ```
   Le serveur sera accessible à l'adresse `http://localhost:8000`.
   La documentation de l'API est disponible sur `http://localhost:8000/docs`.

### 2. Application Mobile

1. Naviguez dans le dossier `mobile` :
   ```bash
   cd mobile
   ```

2. Récupérez les dépendances :
   ```bash
   flutter pub get
   ```

3. Lancez l'application (assurez-vous qu'un émulateur est lancé) :
   ```bash
   flutter run
   ```

## Fonctionnalités

- **Lister les contacts** : Affichage de tous les contacts enregistrés.
- **Ajouter un contact** : Formulaire pour ajouter un nom, prénom et téléphone.
- **Supprimer un contact** : Glisser un contact vers la gauche pour le supprimer.
