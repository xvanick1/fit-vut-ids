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
	cislo_mista		INT, --ak je NULL tak SITTING FREE
	umisteni		VARCHAR(6) NOT NULL,
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

INSERT INTO Trida (id_tridy, nazev) VALUES (3, 'Economy');
INSERT INTO Trida (id_tridy, nazev) VALUES (2, 'Business');
INSERT INTO Trida (id_tridy, nazev) VALUES (1, 'Premium');

INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (1,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (4,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (6,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (9,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (10,1);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (2,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (5,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (7,2);
INSERT INTO TYP_LETADLAGATE (id_gate, id_typu) VALUES (11,2);

INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (1,5,(TO_DATE('2003/05/03', 'yyyy/mm/dd')),(TO_DATE('2018/02/20', 'yyyy/mm/dd')),1);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (5,6,(TO_DATE('2006/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/03/03', 'yyyy/mm/dd')),2);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (2,5,(TO_DATE('2004/05/03', 'yyyy/mm/dd')),(TO_DATE('2018/02/03', 'yyyy/mm/dd')),1);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (4,6,(TO_DATE('2012/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/02/10', 'yyyy/mm/dd')),2);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (6,6,(TO_DATE('2012/05/03', 'yyyy/mm/dd')),(TO_DATE('2018/02/04', 'yyyy/mm/dd')),2);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (3,5,(TO_DATE('2003/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/03/06', 'yyyy/mm/dd')),1);

INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (1,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('08:00', 'HH24:MI'),TO_TIMESTAMP('01:00', 'HH24:MI'),'BRNO',3,4);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (2,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('03:00', 'HH24:MI'),TO_TIMESTAMP('03:30', 'HH24:MI'),'VARSAVA',3,1);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (3,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('12:00', 'HH24:MI'),TO_TIMESTAMP('00:50', 'HH24:MI'),'BRATISLAVA',4,4);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (4,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('07:00', 'HH24:MI'),TO_TIMESTAMP('12:00', 'HH24:MI'),'PRAGUE',3,2);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (5,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('23:00', 'HH24:MI'),TO_TIMESTAMP('02:00', 'HH24:MI'),'BUDAPEST',3,5);

INSERT INTO Misto (id_mista, cislo_mista, umisteni, id_letadla, id_tridy) VALUES (1,3,'Okno',5,1);
INSERT INTO Misto (id_mista, cislo_mista, umisteni, id_letadla, id_tridy) VALUES (6,3,'Okno',1,1);
INSERT INTO Misto (id_mista, cislo_mista, umisteni, id_letadla, id_tridy) VALUES (11,3,'Stred',4,2);
INSERT INTO Misto (id_mista, cislo_mista, umisteni, id_letadla, id_tridy) VALUES (16,3,'Ulicka',6,2);
INSERT INTO Misto (id_mista, cislo_mista, umisteni, id_letadla, id_tridy) VALUES (22,3,'Stred',6,3);

INSERT INTO Letenka (id_letenky, jmeno, prijmeni, id_letu, id_tridy) VALUES (1,'Pavel','Matousek',1,3);
INSERT INTO Letenka (id_letenky, jmeno, prijmeni, id_letu, id_tridy) VALUES (2,'Jan','Hornak',2,2);
INSERT INTO Letenka (id_letenky, jmeno, prijmeni, id_letu, id_tridy) VALUES (3,'Frantisek','Ondrasek',1,2);

INSERT INTO Palubni_vstupenka (id_palubni_vstupenky, jmeno, prijmeni, id_mista, id_letenky) VALUES (1,'Pavel','Matousek',1,1);
INSERT INTO Palubni_vstupenka (id_palubni_vstupenky, jmeno, prijmeni, id_mista, id_letenky) VALUES (2,'Jan','Hornak',11,2);
INSERT INTO Palubni_vstupenka (id_palubni_vstupenky, jmeno, prijmeni, id_mista, id_letenky) VALUES (3,'Frantisek','Ondrasek',22,3);

