--************************************************
--          Création de la BDD
--************************************************

CREATE DATABASE bibliotheque;

USE bibliotheque;

SHOW TABLE;


--************************************************
--          Exercices
--************************************************

-- 1; Quel est l'id_abonne de Laura ?
SELECT id_abonne FROM abonne WHERE prenom = Laura;

-- 2; L'abonné d'id_abonne 2 est venu emprunter un livre à quelles dates (date_sortie) ?
SELECT date_sortie FROM emprunt WHERE id_abonne = 2;

-- 3. Combien d'emprunts ont été effectués en tout?
SELECT COUNT(id_emprunt) FROM emprunt;

--4. Combien de livres sont sortis le 2011-12-19 ?
SELECT COUNT(id_livre) FROM emprunt WHERE date_sortie = '2011-12-19';

--5. "Une Vie" est de quel auteur ?
SELECT auteur FROM livre WHERE titre = 'Une Vie';

--6. De combien de livres d'Alexandre Dumas dispose-t-on ?
SELECT COUNT(id_livre) FROM livre WHERE auteur = 'Alexandre Dumas';

--7. Quel id_livre est le plus emprunté ?
SELECT id_livre, COUNT(id_emprunt) AS nombre FROM emprunt;
SELECT id_livre, COUNT(id_emprunt) AS nombre FROM emprunt GROUP BY id_livre;
SELECT id_livre, COUNT(id_emprunt) AS nombre FROM emprunt GROUP BY id_livre ORDER BY nombre DESC;
SELECT id_livre, COUNT(id_emprunt) AS nombre FROM emprunt GROUP BY id_livre ORDER BY nombre DESC 1;

--************************************************
--          Requetes imbriqués
--************************************************

-- Une requete imbriquée permet de réaliser des requetes sur plusieurs tables quand on sélectionne (=affiche) des champs qui
-- proviennent de la MEME table. Afin de réaliser une requete imbriquée il faut obligatoirement un champ en COMMUN entre chaque table par le jeu des clés primaires et étrangères.

-- Un champ NULL se vérifie avec IS NULL :
SELECT id_livre FROM emprunt WHERE date_rendu IS NULL;
-- affiche les id_livre non rendus

--Titre des livres non rendus (dont la date_rendu est NULL) :
SELECT titre FROM livre WHERE id_livre IN (SELECT id_livre FROM emprunt WHERE date_rendu IS NULL);
-- selectionne le titre des livres pour lesquels l'id_livre est dans la liste (IN) des id_livre dont la date_rendu est NULL (vide)

-- On utilise  IN dans le cas ou il y a plusieurs résultats, et = quand on est sur de n'avoir qu'un seul résultat. 
-- ex : afficher les id_livre que Chloe à empruntés :
SELECT id_livre FROM emprunt WHERE id_abonne = (SELECT id_abonne FROM abonne WHERE prenom = 'Chloe');
-- selectionne les id_livre pour lesquels l'id_abonne est égal à l'id_abonne dont le prénom correspond à Chloe.
-- Notez que l'on peut faire plusieurs requetes imbriquées successives quand il y a plus de 2 tables à parcourir.


--************************************************
--          Exercices
--************************************************

-- 1. Afficher le prénom des abbonés ayant emprunté un livre le 2011-12-19.
SELECT prenom FROM abonne WHERE id_abonne  IN(SELECT id_abonne FROM emprunt WHERE date_sortie = '2011-12-19');

-- 2. Afficher le prénom des abonnés ayant emprunté un livre d'Alphonse Daubet.
SELECT prenom, nom FROM abonne WHERE id_abonne IN(SELECT id_abonne FROM emprunt WHERE id_livre  IN (SELECT id_livre FROM livre WHERE auteur = 'Alphonse Daudet'));

-- 3. Afficher le titre des livres que Chloe a  empruntés.
SELECT titre FROM livre WHERE id_livre IN(SELECT id_livre FROM emprunt WHERE id_abonne IN(SELECT id_abonne FROM abonne WHERE prenom = 'chloe'));

-- 4. Afficher le titre des livres que Chloe n'as pas encore empruntés.
SELECT titre FROM livre WHERE id_livre NOT IN(SELECT id_livre FROM emprunt WHERE id_abonne IN(SELECT id_abonne FROM abonne WHERE prenom = 'chloe'));

-- 5. Afficher le titre des livres que Chloe n'a pas encore rendus.
SELECT titre FROM livre WHERE id_livre IN(SELECT id_livre FROM emprunt WHERE date_rendu IS NULL AND id_abonne IN(SELECT id_abonne from abonne WHERE prenom = 'chloe'));

-- 6. Combien de livres Benoit a empruntés ?
SELECT COUNT(id_emprunt) FROM emprunt WHERE id_abonne IN(SELECT id_abonne FROM abonne WHERE prenom = 'Benoit');


--************************************************
--          Jointures internes
--************************************************

-- Une jointure est une requete qui permet de faire des relations entre différents tables en selectionnant (= en affichant) des champs qui proviennent de tables DIFFERENTES dans un meme résultat.

--Différences entre jouintures et requete imbriquée :
--Une jouinture est possible dans tous les cas.
--Alors qu'une requete imbriquée est possible seulement si les champs affichés viennent de la meme table (ceux qui suivent le premier SELECT).
--Pour info, si nous avons le choix entre requete imbriquée et jointure, la premiere est plus rapide en terme de performance (non mesurable dans la console).

-- Ex : On affiche les dates de sortie et de rendu de l'abonné Guillaume :
SELECT a.prenom, e.date_sortie, e.date_rendu -- table.champ
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne
WHERE a.prenom = 'Guillaume';
--1e ligne : ce que je souhaite afficher
--2e ligne : la 1ère table d'ou proviennent les informations
--3e ligne : on joint la 2ème table d'ou proviennent les informations
--4e ligne : la jointuré qui lie les deux champs en COMMUN entre les 2 tables
--5e ligne : clauses complémentaires comme le WHERE

-- Notez que lorsque'on a plus de 2 tables, on peut enchainer plusieurs jointures :
-- SELECT ... FROM ... INNER JOIN ... ON ... WHERE ...

--Autre ex : afficher le prénom et les id_livre empruntés :
SELECT a.prenom, e.id_livre
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne;


--************************************************
--          Exercices
--************************************************

--1. Afficher les mouvements des livres (titre, date_sortie, date_rendue) écrits par Alphonse Daudet
SELECT l.titre, e.date_sortie, e.date_rendu
FROM livre l
INNER JOIN emprunt e
ON l.auteur = e.id_livre
WHERE l.auteur = 'ALphonse Daudet';

--2. Qui (prenom) à emprunter "Une Vie" dans l'année 2011 ? (en jointure)
SELECT a.prenom
FROM abonne a
INNER JOIN emprunt e
ON  a.id_abonne = e.id_abonne
INNER JOIN livre l
ON e.id_livre = l.id_livre
WHERE l.titre = 'Une Vie' AND e.date_sortie LIKE '2011%';

--3. Afficher le nombre de livres empruntés par chaque abonnés (prénom).
SELECT a.prenom, COUNT(e.id_livre)
FROM abonne a 
INNER JOIN emprunt e 
ON a.id_abonne = e.id_abonne
GROUP BY a.prenom; -- avec COUNT il faut regrouper le résultat par prénom

SELECT a.prenom, COUNT(e.id_livre)
FROM emprunt e
INNER JOIN abonne a 
ON a.id_abonne = e.id_abonne
GROUP BY a.prenom; 

--4. Qui a emprunté quels livres à quelles dates de sortie ? (prénom, datz_sortie, titre)
SELECT a.prenom, e.date_sortie, l.titre
FROM abonne a 
INNER JOIN emprunt e 
ON a.id_abonne = e.id_abonne
INNER JOIN livre l
ON e.id_livre = l.id_livre;


--************************************************
--          Jointures externes
--************************************************

-- Une jointure externe est une requete sans correspondance exigée entre les valeurs dans les différentes tables.
-- Par ex, si vous vous insérez ds la table "abonne" et que vous n'avez rien emprunté, zvec une jointure INTERNE (INNER JOIN) entre les tables
--"abonne" et "emprunt" vous n'apparaissez pas. En revanche, avec une jointure EXTERNE, vous apparaitrez comme tous les abonnés zvec la mention 
-- NULL pour les emprunts que n'avez pas encore effectués.

-- On s'ajoute dans la table "abonne" : 
INSERT INTO abonne (prenom) VALUES ('moi');

-- .... Quand on affiche le prénom et les id_livre empruntés dans la requete suivante, l'abonné "moi" n'apparait pas. En effet, vous n'etes pas dans le résultat
--car vous n'avez rien emprunté donc vous n'etes pas présent  dans la table "emprunt" :
SELECT a.prenom, e.id_livre
FROM abonne a
INNER JOIN emprunt e
ON a.id_abonne = e.id_abonne

-- Pour y remedier  et afficher "moi", on utilise une requete de jointure EXTERNE :
SELECT a.prenom, e.id_livre
FROM abonne a LEFT JOIN emprunt e
INNER JOIN abonne a 
ON a.id_abonne = e.id_abonne; -- La classe  LEFT JOIN permet de récupérer TOUTES les données de la table considérée comme étant à GAUCHE
-- de l'instruction "LEFT JOIN" sans correspondance exigée dans l'autre table.

SELECT a.prenom, e.id_livre
FROM abonne a RIGHT JOIN emprunt e
INNER JOIN abonne a 
ON a.id_abonne = e.id_abonne; -- La classe  RIGHT JOIN permet de récupérer TOUTES les données de la table considérée comme étant à DROITE
-- de l'instruction "LEFT JOIN" sans correspondance exigée dans l'autre table.

--************************************************
--          Exercices
--************************************************

-- On supprime le livre " Une Vie" :
DELETE FROM livre WHERE id_livre = 100;

--1. Afficher la liste des emprunts (id_emprunt) avex le titre des livres qui existent encore.
SELECT e.id_emprunt, l.titre
FROM emprunt e 
INNER JOIN livre l
ON e.id_livre = l.id_livre;
-- On voit que les emprunts correspondants au titre "Une Vie" supprimé ne sortent pas dans cette jointure interne (il y a strict correspondance entre les 2 tables).

--2. Afficher la liste de TOUS les emprunts avec le titre des livres, y compris ceux qui n'existent plus.
SELECT e.id_emprunt, l.titre
FROM emprunt e 
.... JOIN livre l 
ON e.id_livre = l.id_livre;
-- Ici, tous les titre id_emprunts sortent, y compris ceux pour lesquels le livre "Une Vie" n'existe plus (nous avons la mention NULL à la place).


--************************************************
--          Union
--************************************************

--Union permet de fusionner 2 requetes dans un meme jeu de résultat. Pour cela, il est nécessaire que les 2 requetes aient les memes champs et dans le meme ordre.

-- Ex : si on  désinscrit Guillaume, on peut afficher à la fois TOUS les livres empruntés, y compris par des lecteurs désinscrits (NULL apparait à la place de Guillaume),
-- et TOUS les abonnés, y compris ceux qui n'ont rien emprunté (NULL apparait dans id_livre pout "moi").

--Suppression du profil de Guillaume :
DELETE FROM abonne WHERE prenom = 'Guillaume';

-- Requete sur tous les livres empruntés et tous les abonnés :
(SELECT a.prenom, e.id_livre FROM abonne a LEFT JOIN emprunt e ON a.id_abonne = e.id_abonne) -- LEFT JOIN : table de gauche (abonne) complète, y compris ceux qui n'ont rien emprunté (moi)
Union
(SELECT a.prenom, e.id_livre FROM abonne a RIGHT JOIN emprunt e ON a.id_abonne = e.id_abonne); -- RIGHT JOIN : table de droite (emprunt) complète, y compris les livres qui n'ont plus d'abonné (100 et 104)

