--************************************************
--          Exercices
--************************************************

CREATE DATABASE taxis;

USE taxis;

-- on remplit la BDD

--1. Qui ( prenom) conduit la voiture d'id 503 en requete de jointure ?
SELECT c.prenom
FROM conducteur c 
INNER JOIN association_vehicule_conducteur avc
ON c.id_conducteur = avec.id_conducteur
WHERE avec.id_conducteur = 503;

--2.Qui conduit quel modèle (prénom, modele) ?
SELECT c.prenom, v.modele
FROM conducteur c 
INNER JOIN association_vehicule_conducteur avc
ON c.id_conducteur = avec.id_conducteur
INNER JOIN vehicule v 
ON avec.id_conducteur = v.id_conducteur;


--3. Insérez-vous dans la table conducteur.
INSERT INTO conducteur (prenom,nom) VALUES ('John', 'Doe');
-- Afficher TOUS les conducteurs (prenom), y compris ceux qui n'ont pas de véhicule, ainsi que les modèles de véhicules (modele).
SELECT c.prenom, v.modele
FROM conducteur c 
LEFT JOIN association_vehicule_conducteur avc
ON c.id_conducteur = avec.id_conducteur
LEFT JOIN vehicule v 
ON avec.id_conducteur = v.id_conducteur;

--4.Insérez un nouveau véhicule dans la table corrspondante.
INSERT INTO vehicule (marque, modele, couleur, immatriculation) VALUE ('Renault', 'Clio', 'blanc', 'AZ-123-ER');
-- Afficher TOUS les modèles de véhicules, y compris ceux qui n'ont pas de chauffeur et le prénom des conducteurs.
SELECT v.modele, c.prenom
FROM vehicule v 
LEFT JOIN association_vehicule_conducteur avc
on v.id_conducteur = avc.id_vehicule
LEFT JOIN conducteur c 
ON avec.id_conducteur = c.id_conducteur;

--5. Afficher TOUS les conducteurs (prenom) et (TOUS) les modèles de véhicules (modele).
(SELECT c.prenom, v.modele
FROM conducteur c 
LEFT JOIN association_vehicule_conducteur avc
ON c.id_conducteur = avec.id_conducteur
LEFT JOIN vehicule v 
ON avec.id_conducteur = v.id_conducteur)
UNION
(SELECT v.modele, c.prenom
FROM vehicule v 
RIGHT JOIN association_vehicule_conducteur avc
on v.id_conducteur = avc.id_vehicule
RIGHT JOIN conducteur c 
ON avec.id_conducteur = c.id_conducteur);