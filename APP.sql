CREATE TABLE Professeur (
    num_prof INT PRIMARY KEY,
    nom_prof VARCHAR(50),
    prenom_prof VARCHAR(50),
    telephone VARCHAR(20),
    adresse VARCHAR(100),
    type ENUM('permanent', 'vacataire') NOT NULL
);

CREATE TABLE Classe (
    num_classe INT PRIMARY KEY,
    nom_classe VARCHAR(50),
    nombre_modules INT DEFAULT 0,
    motdepasse VARCHAR(50)
);

CREATE TABLE Module (
    num_module INT PRIMARY KEY,
    nom_module VARCHAR(50),
    masse_horaire_prevue INT CHECK (masse_horaire_prevue >= 10),
    num_prof_enseignant INT,
    num_prof_responsable INT,
    num_classe INT,
    FOREIGN KEY (num_prof_enseignant) REFERENCES Professeur(num_prof),
    FOREIGN KEY (num_prof_responsable) REFERENCES Professeur(num_prof),
    FOREIGN KEY (num_classe) REFERENCES Classe(num_classe)
);

CREATE TABLE Precision (
    num_precision INT PRIMARY KEY,
    nom_precision VARCHAR(50),
    num_module INT,
    FOREIGN KEY (num_module) REFERENCES Module(num_module)
);

CREATE TABLE Groupe (
    num_groupe INT PRIMARY KEY,
    nom_groupe VARCHAR(50),
    num_classe INT,
    FOREIGN KEY (num_classe) REFERENCES Classe(num_classe)
);

CREATE TABLE Forme (
    num_forme INT PRIMARY KEY,
    nom_forme VARCHAR(50),
    num_groupe INT,
    FOREIGN KEY (num_groupe) REFERENCES Groupe(num_groupe)
);


// NOMBRE MODULE ENSEIGNES 
DELIMITER $$
CREATE PROCEDURE GetModuleStats(
    IN prof_id INT,
    OUT taught_count INT,
    OUT supervised_count INT
)
BEGIN
    SELECT COUNT(*) INTO taught_count
    FROM Module
    WHERE num_prof_enseignant = prof_id;

    SELECT COUNT(*) INTO supervised_count
    FROM Module
    WHERE num_prof_responsable = prof_id;
END$$
DELIMITER ;


//CALCUL HEURES TOTALS
DELIMITER $$
CREATE FUNCTION TotalHoursForClass(class_id INT) RETURNS INT
BEGIN
    DECLARE total_hours INT;
    SELECT SUM(masse_horaire_prevue) INTO total_hours
    FROM Module
    WHERE num_classe = class_id;
    RETURN total_hours;
END$$
DELIMITER ;


//TRIGER MISE A JOUR 
DELIMITER $$
CREATE TRIGGER UpdateModuleCount
AFTER INSERT OR DELETE ON Module
FOR EACH ROW
BEGIN
    DECLARE module_count INT;
    SELECT COUNT(*) INTO module_count FROM Module WHERE num_classe = NEW.num_classe;
    UPDATE Classe SET nombre_modules = module_count WHERE num_classe = NEW.num_classe;
END$$
DELIMITER ;
