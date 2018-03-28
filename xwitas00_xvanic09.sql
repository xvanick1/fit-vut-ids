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
	nazev			VARCHAR(200),
	CONSTRAINT	PK_Terminal PRIMARY KEY (id_terminalu)
);

CREATE TABLE Typ_Letadla (
    id_typu     	INT NOT NULL,
    vyrobce     	VARCHAR(200),
    nazev       	VARCHAR(200),
    CONSTRAINT PK_Typ_Letadla PRIMARY KEY (id_typu)
);

CREATE TABLE Letadlo (
    id_letadla      INT NOT NULL,
    pocet_posadky   INT NOT NULL,
    datum_vyroby    DATE,
    datum_revize    DATE,
    id_typu			INT NOT NULL,
    CONSTRAINT FK_LetadloTyp_Letadla FOREIGN KEY (id_typu) REFERENCES Typ_Letadla (id_typu),
    CONSTRAINT PK_Letadlo PRIMARY KEY (id_letadla)
);

CREATE TABLE Trida (
	id_tridy		INT NOT NULL,
	nazev			VARCHAR(200),
	CONSTRAINT	PK_Trida PRIMARY KEY (id_tridy)
);

CREATE TABLE Gate (
	id_gate			INT NOT NULL,
	nazev			VARCHAR(200),
	id_terminalu	INT NOT NULL,
	CONSTRAINT FK_GateTerminal FOREIGN KEY (id_terminalu) REFERENCES Terminal (id_terminalu),
	CONSTRAINT PK_Gate PRIMARY KEY (id_gate)
);

CREATE TABLE Let (
    id_letu         INT NOT NULL,
    datum_odletu    DATE,
    cas_odletu      TIMESTAMP,
    doba_letu       TIMESTAMP,
    destinace       VARCHAR(200),
    id_letadla		INT NOT NULL,
    id_gate			INT NOT NULL,
    CONSTRAINT FK_LetLetadlo FOREIGN KEY (id_letadla) REFERENCES Letadlo (id_letadla),
    CONSTRAINT FK_LetGate FOREIGN KEY(id_gate) REFERENCES Gate (id_gate),
    CONSTRAINT PK_Let PRIMARY KEY (id_letu)
);

CREATE TABLE Misto (
	id_mista		INT NOT NULL,
	cislo_mista		INT,
	umistneni		VARCHAR(1),
	id_letadla		INT NOT NULL,
	id_tridy		INT NOT NULL,
	CONSTRAINT FK_MistoLetadlo FOREIGN KEY (id_letadla) REFERENCES Letadlo (id_letadla),
	CONSTRAINT FK_MistoTrida FOREIGN KEY (id_tridy) REFERENCES Trida (id_tridy),
	CONSTRAINT PK_Misto PRIMARY KEY (id_mista)
);

CREATE TABLE Letenka (
	id_letenky		INT NOT NULL,
	jmeno			VARCHAR(200),
	prijmeni		VARCHAR(200),
	id_letu			INT NOT NULL,
	id_tridy		INT NOT NULL,
	CONSTRAINT FK_LetenkaLet FOREIGN KEY (id_letu) REFERENCES Let (id_letu),
	CONSTRAINT FK_LetenkaTrida FOREIGN KEY (id_tridy) REFERENCES Trida (id_tridy),
	CONSTRAINT PK_Letenka PRIMARY KEY (id_letenky)
);

CREATE TABLE Palubni_vstupenka (
	id_palubni_vstupenky		INT NOT NULL,
	jmeno			VARCHAR(200),
	prijmeni		VARCHAR(200),
	id_mista		INT NOT NULL,
	id_letenky		INT NOT NULL,
	CONSTRAINT FK_Palubni_vstupenkaMisto FOREIGN KEY (id_mista) REFERENCES Misto (id_mista),
	CONSTRAINT FK_Palubni_VstupenkaLetenka FOREIGN KEY (id_letenky) REFERENCES Letenka (id_letenky),
	CONSTRAINT PK_Palubni_vstupenka PRIMARY KEY (id_palubni_vstupenky)
);

CREATE TABLE Typ_LetadlaGate (
	id_typu			INT NOT NULL,
	id_gate			INT NOT NULL,
    CONSTRAINT FK_Typ_LetadlaGateGate FOREIGN KEY(id_gate) REFERENCES Gate (id_gate),
	CONSTRAINT PK_Typ_LetadlaGate PRIMARY KEY (id_typu)
);