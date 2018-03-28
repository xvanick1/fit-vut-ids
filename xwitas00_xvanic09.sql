DROP TABLE Letadlo;
DROP TABLE Let;
DROP TABLE Gate;
DROP TABLE Terminal;
DROP TABLE Typ_Letadla;
DROP TABLE Misto;
DROP TABLE Trida;
DROP TABLE Letenka;
DROP TABLE Palubni_vstupenka;
DROP TABLE Typ_LetadlaGate;

CREATE TABLE Letadlo (
    id_letadla      INT NOT NULL,
    pocet_posadky   INT,
    datum_vyroby    DATE,
    datum_revize    DATE,
    FOREIGN KEY (id_typu) REFERENCES Typ_Letadla (PK_Typ_Letadla),
    CONSTRAINT PK_Letadlo PRIMARY KEY (id_typu)
);

CREATE TABLE Let (
    id_letu         INT NOT NULL,
    datum_odletu    DATE,
    cas_odletu      TIMESTAMP,
    doba_letu       TIMESTAMP,
    destinace       VARCHAR(200),
    FOREIGN KEY (id_letadla) REFERENCES Letadlo (PK_Letadlo),
    FOREIGN KEY (id_gate) REFERENCES Gate (PK_Gate),
    CONSTRAINT PK_Let PRIMARY KEY (id_letadla)
);

CREATE TABLE Gate (
	id_gate			INT NOT NULL,
	nazev			VARCHAR(200),
	FOREIGN KEY (id_terminalu) REFERENCES Terminal (PK_Terminal),
	CONSTRAINT	PK_Gate PRIMARY KEY (id_gate)
);

CREATE TABLE Terminal (
	id_terminalu	INT NOT NULL,
	nazev			VARCHAR(200),
	CONSTRAINT	PK_Terminal PRIMARY KEY (id_terminalu)
);

CREATE TABLE Typ_Letadla (
    id_typu     	INT NOT NULL,
    vyrobce     	VARCHAR(200),
    nazev       	VARCHAR(200),
    CONSTRAINT PK_Typ_Letadla PRIMARY KEY (id_typu)
);

CREATE TABLE Misto (
	id_mista		INT NOT NULL,
	cislo_mista		INT,
	umistneni		VARCHAR(1),
	FOREIGN KEY (id_letadla) REFERENCES Letadlo (PK_Letadlo),
	FOREIGN KEY (id_tridy) REFERENCES Trida (PK_Trida),
	CONSTRAINT PK_Misto PRIMARY KEY (id_mista)
);

CREATE TABLE Trida (
	id_tridy		INT NOT NULL,
	nazev			VARCHAR(200),
	CONSTRAINT	PK_Trida PRIMARY KEY (id_tridy)
);

CREATE TABLE Letenka (
	id_letenky		INT NOT NULL,
	jmeno			VARCHAR(200),
	prijmeni		VARCHAR(200),
	FOREIGN KEY (id_letu) REFERENCES Let (PK_Let),
	FOREIGN KEY (id_tridy) REFERENCES Trida (PK_Trida),
	CONSTRAINT	PK_Letenka PRIMARY KEY (id_letenky)
);

CREATE TABLE Palubni_vstupenka (
	id_palubni_vstupenky		INT NOT NULL,
	jmeno			VARCHAR(200),
	prijmeni		VARCHAR(200),
	FOREIGN KEY (id_letenky) REFERENCES Let (PK_Letenka),
	CONSTRAINT	PK_Palubni_vstupenka PRIMARY KEY (id_palubni_vstupenky)
);

CREATE TABLE Typ_LetadlaGate (
	id_typu			INT NOT NULL,
	FOREIGN KEY (id_gate) REFERENCES Gate (PK_Gate),
	CONSTRAINT	PK_Typ_LetadlaGate PRIMARY KEY (id_typu)
);