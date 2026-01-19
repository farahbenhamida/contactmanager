# Contact Manager Application

Une application de gestion de contacts avec backend FastAPI et frontend Flutter mobile.

## Structure du Projet

```
contact_manager1/
├── backend/              # Backend FastAPI
│   ├── main.py          # Point d'entrée API
│   ├── models.py        # Modèles SQLAlchemy et Pydantic
│   ├── database.py      # Configuration base de données
│   ├── requirements.txt # Dépendances Python
│   └── contacts.db      # Base de données SQLite
├── mobile/              # Application Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   │   └── person.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   └── screens/
│   │       ├── home_screen.dart
│   │       └── add_person_screen.dart
│   └── pubspec.yaml
└── legacy_source/       # Code legacy préservé
```

## Fonctionnalités

### Backend (FastAPI)
- ✅ **POST /personnes** - Ajouter un contact
- ✅ **GET /personnes** - Lister tous les contacts
- ✅ **GET /personnes/{id}** - Récupérer un contact par ID
- ✅ **DELETE /personnes/{id}** - Supprimer un contact
- ✅ Validation des données (unicité du téléphone)
- ✅ CORS configuré pour Flutter
- ✅ Base de données SQLite

### Mobile (Flutter)
- ✅ Liste des contacts avec swipe-to-delete
- ✅ Ajout de contacts avec validation
- ✅ **Fonctionnalité WhatsApp** - Bouton pour envoyer un message WhatsApp
- ✅ Gestion des erreurs
- ✅ Interface Material Design

## Installation et Exécution

### Backend

```bash
cd backend
pip install -r requirements.txt
python main.py
```

Le serveur démarre sur `http://0.0.0.0:8000`
Documentation API disponible sur `http://localhost:8000/docs`

### Mobile

```bash
cd mobile
flutter pub get
flutter run
```

**Note**: L'application utilise `http://10.0.2.2:8000` pour l'émulateur Android.

## Vérification

### Backend
```bash
# Test de compilation Python
python -m py_compile backend/main.py backend/models.py backend/database.py
```

### Mobile
```bash
cd mobile
flutter analyze  # Aucune erreur trouvée ✓
```

## Fonctionnalité WhatsApp

Chaque contact dans la liste possède un bouton de message (icône verte) qui ouvre WhatsApp avec le numéro de téléphone pré-rempli. Cette fonctionnalité utilise le package `url_launcher`.

## Technologies Utilisées

- **Backend**: FastAPI, SQLAlchemy, Pydantic, Uvicorn
- **Mobile**: Flutter, Dart, http, url_launcher
- **Base de données**: SQLite
