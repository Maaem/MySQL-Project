-- pour faire des commentaires 
-- ouvrir la console sous XAMPP : menu SHell du panel de controle 
    -- cd c:\xampp\mysql\bin
    -- mysql.exe -u root --password

--ouvrir dans la console sous MAMP : Applicztions > Utilitaires > Terminal 
    -- /Applications/MAMP/Library/bin:mysql -uroot -proot

--************************
--Requetes Générales : 1
--************************

-- Créer et utiliser une BDD :
CREATE DATABASE entreprise; -- creer la BDD entreprise
--les requetes ne sont pas sensibles à la casse, mais nous mettons les mots clés en majuscules par convention.

-- CREATE DATABASE entreprise; = mettee ça dans la console

--SHOW DATABASE; -- pour voir la BDD

USE entreprise; --uitiliser une BDD

-- copier / coller le code du fichier source entreprise_employes.sql (dans sql source => entreprise) 

-- voir les tables :
SHOW TABLES; -- pour voir les tables présentes dans la BDD entreprises

DESC employes; --pour observer la structure de la table aves ses champs (DESC pour DESCRIBE)

-- supprimer des éléments :
DROP DATABASE nom_de_la_base; --supprimer une BDD

DROP TABLE nom_de_la_table; --supprimer une table

TRUNCATE nom_de_la_table; -- vider le contenu d'une table sans la supprimer


--************************************************
            --Requetes de selection : 2
--************************************************

--SELECT

SELECT nom,prenom FROM employes; --selectionne (=affiche) le nom et prénom des employes,SELECT = selectionne les champs,
--FROM = précise la table.

SELECT services FROM employes; --selectionnes tous les services

--DISTINCT
-- Pour dédoublonner les services de la requete présédente, on utilise DISTINCT :
SELECT DISTINCT services FROM employes; --selectionner les différents dédoublonners

-- * = pour signifier ALL

SELECT * FROM employes; --selectionne tous les champs de la table employes, Cela affiche toute la table.



--WHERE
SELECT nom,prenom FROM employes WHERE services = 'informatique'; -- selectionne le nom et prénom pour lesquels les services est 
--égal à 'informatique'


--BETWEEN
SELECT nom,prenom, date_embauche FROM employes WHERE date_embauche BETWEEN '2006-01-01' AND '2010-12-31';
-- selectionne le nom, le prénom et la date d'embauche des emmployés recrutés ENTRE '2006-01-01' et 2010-12-31'


--LIKE
SELECT prenom FROM employes WHERE prenom LIKE 's%';
 --selectionne les prenoms qui commencent par la lettre "s", le % remplace nimporte quel caractère
 SELECT prenom FROM employes WHERE prenom LIKE '%-%';
 -- selectionne les prénoms qui contiennent un tiret.
 --LIKE esttrès utile dans les formulaires de recherches de produits pas ex


 
 -- Opérateurs de comparaison :
 SELECT nom,prenom FROM employes WHERE services != 'informatique';
 --selectionne le nom et prénom des employés qui ne sont pas du service informatique

 --        =
 --        <
 --        >
 --       <=          inférieur ou égal
 --       >=          supérieur ou égal
--        != ou <>    différent de

SELECT * FROM employes WHERE salaire > 3000; 
-- selectionn tous les champs des employés pour lesquels le salaire est supérieur à 3000 (sans les quotes car il s'agit d'un nombre
--INT en BDD)


-- ORDER BY = pour ordonner (trier)
SELECT nom, prenom, services, salaire FROM employes ORDER BY salaire;
--selectionne le nom, prenom, services et salaire des employés par salaire croissant ASC (ASCENDENT) (par défaut) 
--Pour un tri par ordre décroissant on doit préciser DESC.
SELECT nom, prenom, services, salaire FROM employes ORDER BY salaire ASC, prenom DESC;
--tri sur plusieurs champs dans le vas ou plusieurs employés ont le meme salairee (salaire croissant puis nom décroissant)
--ORDER BY peut etre utilisé dans une boutique pour trier les produits par ordre de prix.

-- LIMIT 
SELECT nom, prenom, services, salaire FROM employes ORDER BY salaire DESC LIMIT 0,1;
-- selectionne l'émployé ayant le salaire le plus élévé. Ds LIMIT 0,1, le premier chiffre correspond à l'offset
--(on compte à partir de 0), c'esr à dire la position à partir de laquelle on part et le second chiffre correspond au nombre de
-- résultats que l'on prend.
-- ici 1. LIMIT 0,1 permet donc de prendre le 1er enregistrement selectionner. Notez que l'on peut écrire LIMIT 1

-- ATTENTION à l'ordre : SELECT ... FROM ... WHERE ... ORDER BY ... LIMIT ...


-- ALIAS avec AS
SELECT nom, prenom, salaire * 12 AS salaire_annuel FROM employes;
-- affiche le salaire annuel avec un alias salaire_annuel comme nom de champ.


-- SUM
SELECT SUM(salaire *12) AS somme_salaire_annuel FROM employes;
--affiche la somme des salaires anuels. Notes : les () des fonctions sont toujours collées au nom de la fonction en SQL.


--MIN - MAX
SELECT MIN(salaire) FROM employes; --selectionne le salaire les plus petits
SELECT MAX(salaire) FROM employes; --selectionne le salaire les plus grands

SELECT prenom, MIN(salaire) FROM employes; 
-- on ne peut pas combiner MIN ou MAX avec d'autres champs directement, Ici la requete sort le plus petit salaire mais le 
--prénom du 1er enregistrement de la table. Pour réaliser cette requete, voir l'exemple avec LIMIT.


--AVG (average = moyenne)
SELECT AVG(salaire) FROM employes; --selectionne le salaire moyen des employés


--ROUND
SELECT ROUND(AVG(salaire), 0) FROM employes; 
--affiche le salaire moyen arrondi à 0 chiffre après la virgule


-- COUNT
SELECT COUNT(id_employes) FROM employes WHERE sexe = 'f'; -- affiche le nombre d'employés de sexe 'f'


-- IN
SELECT prenom, services FROM employes WHERE services IN ('comptabilite', 'informtique');
-- selectionne le prénom des employés travaillant dans le service 'comptabilité' ou 'informatique'


-- NOT IN
SELECT prenom, services FROM employes WHERE services NOT IN ('comptabilite', 'informatique');
-- à l'inverse, on selectionne le prénom des employes qui ne font pas partie des services 'comptabilité' ou 'informatique'


-- AND, OR
SELECT prenom, nom, salaire, services FROM employes WHERE services = 'commercial' AND salaire <= 2000;
-- selectionne le prénom et nom des emplyés travaillant dans le service ET avec un salaire inférieur ou égal à 2OOO

SELECT prenom, nom, salaire, services FROM employes WHERE services = 'production' AND salaire = 1900 OR salaire = 2300;
--cette ligne revient à écrire :
SELECT prenom, nom, salaire, services FROM employes WHERE (services = 'production' AND salaire = 1900) OR salaire = 2300;
--on affiche les employés du service production dont le salaire est de 1900 ou dans tous les services ceux qui ont un salaire de 2300
--Il est recommandé de mettre des () pour bien prioriser les AND et les OR succecifs.


-- GROUP BY
SELECT services, COUNT(id_employes) AS nombre FROM employes GROUP BY services;
-- Affiche le nombre d'emplyés par services, GROUP BY va regrouper les nombres de services. GROUP BY va regrouper les nombres par service.
--GROUP BY s'utilise obligatoirement avec toutes les fonctions qui retournent un agregat quand on les croise avec d'autres champs:
-- MIN, MAX, SUM, AVG, CONST.


-- GROUP BY ... HAVING
SELECT services, COUNT(id_employes) AS nombre FROM employes GROUP BY services HAVING nombre > 1;
--affiche les services ayant plus de 1 employés. HAVING remplace un WHERE dans un GROUP BY.

--Attention à l'ordre des mots clés :
-- SELECT ... FROM ... WHERE ... GROUP BY ... LIMIT ...




--************************************************
--          Requetes d'insertion : 3
--************************************************

INSERT INTO employes (prenom, nom, sexe, services, date_embauche, salaire) VALUES ('Alexis', 'Ricky', ' m', 'informatique', '2011-12-28', 1800);
--insertion d'un employé dans la table employé, l'ordre des champs énoncés entre les 2 paires de () doit etre le meme, 
--Ici, on ne spécifie pas l'id_employes car il s'agit de la clé principale qui esr auto incrémmente (automatiquement renseignée à +1) dans la BDD.


--Insertion sans préciser les champset en auto-incrémentant l'id_employes:
INSERT INTO employes VALUES (NULL, 'John', 'Doe', 'm', 'communication', '2019-12-15', 2000);
-- on peeut insérer une emplyé sans préciser la liste des champs si les valeurs données respectent l'ordre de TOUS les champs de la table, y compris
--l'id_employes auquel on met la valeur NULL pour l'auto-incrémenter.


--************************************************
--          Requetes de modifications : 4
--************************************************

-- UPDATE
UPDATE employes SET salaire = 1870 WHERE id_employes = 699;
--on modifie le salaire de l'employé dont l'id_emplyes est 699 (Cottet)

--UPDATE employes SET salaire = 1870 WHERE id_employes = (SELECT id_employes FROM employes ORDER BY salaire LIMIT 1);

UPDATE employes SET salaire = 1872, services = 'autre' WHERE id_employes =699;
--on modifie le salaire et le service de l'employé 699

-- A NE PAS FAIRE : un UPDATE sans clause WHERE 
UPDATE employes SET salaire = 0; -- ici, on met tous les salaire à 0 !


-- REPLACE
REPLACE INTO employes (id_employes, prenom, nom, sexe, services, date_embauche, salaire)
    VALUES (2000, 'test', 'test', 'm', 'marketing', '2010-07-05', 2600);
-- se comporte comme un INSERT car l'id_employes 2000 n'existe pas

REPLACE INTO employes (id_employes, prenom, nom, sexe, services, date_embauche, salaire)
    VALUES (2000, 'test2', 'test2', 'm', 'marketing', '2010-07-05', 2600);
-- se comporte comme un UPDATE car l'id_employes fourni existe déjà en BDD.


--************************************************
--          Requetes de supressions : 5
--************************************************

--DELETE
DELETE FROM employes WHERE id_employes = 900; 
-- suppression de l'employé d'id 900

DELETE FROM employes WHERE id_employes = 338 OR id_employes = 990;
-- pour supprimer 2 employes on met un OR et non pas un AND car un employé ne peut pas avoir 2 id en meme temps (ce que signifierait AND)

-- A NE PAS FAIRE : un DELETE sans clause WHERE
DELETE FROM employes; -- revient à faire un truncate qui vide la table



--************************************************
--          Exercices
--************************************************

--1. Afficher le service de l'employé 547
SELECT services FROM employes WHERE id_employes = 547;

--2. Afficher la date d'embauche d'Amandine
SELECT date_embauche FROM employes WHERE prenom = Amandine;

--3. Afficher le nombre de commerciaux
SELECT COUNT(id_employes) FROM employes WHERE services = 'commercial';

--4. Afficher le cout des commerciaux sur 1 an
SELECT SUM(salaire * 12) FROM employes WHERE services = 'commercial';

--5. Afficher le salaire moyen par service
SELECT services, AVG(salaire) FROM employes GROUP BY services;

--6. Afficher le nombre de recrutement sur l'année 2010
SELECT COUNT(id_employes) FROM employes WHERE date_embauche BETWEEN '2010-01-01' AND '2010-12-31';

SELECT COUNT(id_employes) FROM employes WHERE date_embauche >= '2010-01-01' AND date_embauche <= '2010-12-31';

SELECT COUNT(id_employes) FROM employes WHERE date_embauche LIKE '2010%';

--7. Augmenter le salaire de tous les employés de +100
UPDATE employes SET salaire = salaire + 100;

--8. Afficher le nombre de services différents
SELECT COUNT(DISTINCT services) FROM employes;

--9. Afficher le nombre d'employés par service
SELECT services, COUNT(id_employes) AS nombre_employes GROUP BY services;

SELECT services, COUNT(id_employes) AS nombre FROM employes GROUP BY services;

--10. Afficher les infos commercial gagnant le salaire le plus élevé
SELECT * FROM employes WHERE services = 'commercial' ORDER BY salaire DESC LIMIT 1;

--11. Afficher l'employé ayant été embauché en dernier
SELECT prenom, nom, FROM employes ORDER BY date_embauche DESC LIMIT 0,1 ;