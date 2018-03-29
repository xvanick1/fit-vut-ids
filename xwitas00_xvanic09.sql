DROP TABLE Typ_LetadlaGate;
DROP TABLE Palubni_vstupenka;
DROP TABLE Letenka;
DROP TABLE Misto;
DROP TABLE Let;
DROP TABLE Gate;
DROP TABLE Trida;
DROP TABLE Letadlo;
DROP TABLE Typ_Letadla;
DROP TABLE Terminal;

CREATE TABLE Terminal (
	id_terminalu	INT NOT NULL,
	nazev			VARCHAR(200) NOT NULL,
	CONSTRAINT PK_Terminal PRIMARY KEY (id_terminalu),
    CONSTRAINT UQ_TerminalNazev UNIQUE (nazev)
);

CREATE TABLE Typ_Letadla (
    id_typu     	INT NOT NULL,
    vyrobce     	VARCHAR(200),
    nazev       	VARCHAR(200) NOT NULL,
    CONSTRAINT PK_Typ_Letadla PRIMARY KEY (id_typu)
    -- nazev neni unique, protoze 2 vyrobci mohou mit stejny nazev typu letadla
);

CREATE TABLE Letadlo (
    id_letadla      INT NOT NULL,
    pocet_posadky   INT NOT NULL,
    datum_vyroby    DATE NOT NULL,
    datum_revize    DATE NOT NULL,
    id_typu			INT NOT NULL,
    CONSTRAINT FK_LetadloTyp_Letadla FOREIGN KEY (id_typu) REFERENCES Typ_Letadla (id_typu),
    CONSTRAINT PK_Letadlo PRIMARY KEY (id_letadla)
);

CREATE TABLE Trida (
	id_tridy		INT NOT NULL,
	nazev			VARCHAR(200) NOT NULL,
	CONSTRAINT	PK_Trida PRIMARY KEY (id_tridy)
    -- UNIQUE nazev??
);

CREATE TABLE Gate (
	id_gate			INT NOT NULL,
	nazev			VARCHAR(200) NOT NULL,
	id_terminalu	INT NOT NULL,
	CONSTRAINT FK_GateTerminal FOREIGN KEY (id_terminalu) REFERENCES Terminal (id_terminalu),
	CONSTRAINT PK_Gate PRIMARY KEY (id_gate),
    CONSTRAINT UQ_GateNazevTerminal UNIQUE (nazev, id_terminalu)
);

CREATE TABLE Let (
    id_letu         INT NOT NULL,
    datum_odletu    DATE NOT NULL,
    cas_odletu      TIMESTAMP NOT NULL,
    doba_letu       TIMESTAMP NOT NULL,
    destinace       VARCHAR(200) NOT NULL,
    id_letadla		INT NOT NULL,
    id_gate			INT NOT NULL,
    CONSTRAINT FK_LetLetadlo FOREIGN KEY (id_letadla) REFERENCES Letadlo (id_letadla),
    CONSTRAINT FK_LetGate FOREIGN KEY(id_gate) REFERENCES Gate (id_gate),
    CONSTRAINT PK_Let PRIMARY KEY (id_letu)
);

CREATE TABLE Misto (
	id_mista		INT NOT NULL,
	cislo_mista		INT NOT NULL,
	umisteni		VARCHAR(1) NOT NULL,
	id_letadla		INT NOT NULL,
	id_tridy		INT NOT NULL,
	CONSTRAINT FK_MistoLetadlo FOREIGN KEY (id_letadla) REFERENCES Letadlo (id_letadla),
	CONSTRAINT FK_MistoTrida FOREIGN KEY (id_tridy) REFERENCES Trida (id_tridy),
	CONSTRAINT PK_Misto PRIMARY KEY (id_mista),
    CONSTRAINT CH_MistoUmisteni CHECK (umisteni IN ('Okno', 'Ulicka', 'Stred')),
    CONSTRAINT UQ_LetadloTridaMisto UNIQUE (cislo_mista, id_letadla, id_tridy)
);

CREATE TABLE Letenka (
	id_letenky		INT NOT NULL,
	jmeno			VARCHAR(200) NOT NULL,
	prijmeni		VARCHAR(200) NOT NULL,
	id_letu			INT NOT NULL,
	id_tridy		INT NOT NULL,
	CONSTRAINT FK_LetenkaLet FOREIGN KEY (id_letu) REFERENCES Let (id_letu),
	CONSTRAINT FK_LetenkaTrida FOREIGN KEY (id_tridy) REFERENCES Trida (id_tridy),
	CONSTRAINT PK_Letenka PRIMARY KEY (id_letenky)
);

CREATE TABLE Palubni_vstupenka (
	id_palubni_vstupenky		INT NOT NULL,
	jmeno			VARCHAR(200) NOT NULL,
	prijmeni		VARCHAR(200) NOT NULL,
	id_mista		INT,
	id_letenky		INT NOT NULL,
	CONSTRAINT FK_Palubni_vstupenkaMisto FOREIGN KEY (id_mista) REFERENCES Misto (id_mista),
	CONSTRAINT FK_Palubni_VstupenkaLetenka FOREIGN KEY (id_letenky) REFERENCES Letenka (id_letenky),
	CONSTRAINT PK_Palubni_vstupenka PRIMARY KEY (id_palubni_vstupenky)
);

CREATE TABLE Typ_LetadlaGate (
	id_typu			INT NOT NULL,
	id_gate			INT NOT NULL,
    CONSTRAINT FK_Typ_LetadlaGateGate FOREIGN KEY(id_gate) REFERENCES Gate (id_gate),
    CONSTRAINT FK_Typ_LetadlaGateTyp FOREIGN KEY(id_typu) REFERENCES Typ_letadla (id_typu),
	CONSTRAINT PK_Typ_LetadlaGate PRIMARY KEY (id_typu, id_gate)
);


-- VLOZENI UKAZKOVYCH DAT
INSERT INTO Terminal (id_terminalu, nazev) VALUES (1, 'Terminal Pepa');
INSERT INTO Terminal (id_terminalu, nazev) VALUES (2, 'Terminal Franta');

INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (1, '1A', 1);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (2, '1B', 1);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (3, '1C', 1);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (4, '2A', 1);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (5, '2B', 1);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (6, '1A', 2);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (7, '1B', 2);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (8, '1C', 2);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (9, '1D', 2);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (10, '2A', 2);
INSERT INTO Gate (id_gate, nazev, id_terminalu) VALUES (11, '2B', 2);

INSERT INTO Typ_letadla (id_typu, nazev, vyrobce) VALUES (1, '747', 'Boeing');
INSERT INTO Typ_letadla (id_typu, nazev, vyrobce) VALUES (2, 'A320', 'Airbus');

INSERT INTO Trida (id_tridy, nazev) VALUES (1, 'Economy');
INSERT INTO Trida (id_tridy, nazev) VALUES (2, 'Business');
INSERT INTO Trida (id_tridy, nazev) VALUES (3, 'Premium');

INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (1,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (4,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (6,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (9,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (10,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (2,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (5,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (7,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (11,2);
