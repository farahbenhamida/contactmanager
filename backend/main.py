from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from database import engine, get_db
from models import Base, Person
from models import PersonCreate, PersonResponse

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Contact API")

# CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/personnes", response_model=PersonResponse)
def create_person(person: PersonCreate, db: Session = Depends(get_db)):
    # Check if phone already exists
    db_person = db.query(Person).filter(Person.telephone == person.telephone).first()
    if db_person:
        raise HTTPException(status_code=400, detail="Ce numéro de téléphone existe déjà")
    
    db_person = Person(
        nom=person.nom,
        prenom=person.prenom,
        telephone=person.telephone
    )
    db.add(db_person)
    db.commit()
    db.refresh(db_person)
    return db_person

@app.get("/personnes", response_model=List[PersonResponse])
def get_persons(db: Session = Depends(get_db)):
    persons = db.query(Person).all()
    return persons

@app.get("/personnes/{person_id}", response_model=PersonResponse)
def get_person(person_id: int, db: Session = Depends(get_db)):
    person = db.query(Person).filter(Person.id == person_id).first()
    if person is None:
        raise HTTPException(status_code=404, detail="Personne non trouvée")
    return person

@app.delete("/personnes/{person_id}")
def delete_person(person_id: int, db: Session = Depends(get_db)):
    person = db.query(Person).filter(Person.id == person_id).first()
    if person is None:
        raise HTTPException(status_code=404, detail="Personne non trouvée")
    
    db.delete(person)
    db.commit()
    return {"message": "Personne supprimée avec succès"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
