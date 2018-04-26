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


-- Triggery pro skript c. 4
-- Osetreni ze Letadlo muze letet z daneho Gate v tabulce Let
CREATE OR REPLACE TRIGGER let_LetadloGate
BEFORE INSERT OR UPDATE
	ON let FOR EACH ROW
DECLARE
	gate_exc EXCEPTION;
	n_count	 NUMBER (1);
BEGIN
	SELECT count(*) INTO n_count FROM Letadlo NATURAL JOIN TYP_LETADLAGATE WHERE id_letadla = :NEW.id_letadla AND id_gate = :NEW.id_gate;
	IF n_count < 1 THEN
		RAISE gate_exc;
	END IF;
END;
/

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
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (2,7,(TO_DATE('2004/05/03', 'yyyy/mm/dd')),(TO_DATE('2018/02/03', 'yyyy/mm/dd')),1);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (3,5,(TO_DATE('2003/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/03/06', 'yyyy/mm/dd')),1);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (4,6,(TO_DATE('2012/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/02/10', 'yyyy/mm/dd')),2);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (5,8,(TO_DATE('2006/06/09', 'yyyy/mm/dd')),(TO_DATE('2018/03/03', 'yyyy/mm/dd')),2);
INSERT INTO Letadlo (id_letadla,pocet_posadky, datum_vyroby, datum_revize, id_typu) VALUES (6,6,(TO_DATE('2012/05/03', 'yyyy/mm/dd')),(TO_DATE('2018/02/04', 'yyyy/mm/dd')),2);

INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (1,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('08:00', 'HH24:MI'),TO_TIMESTAMP('01:00', 'HH24:MI'),'BRNO',3,4);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (2,(TO_DATE('2018/01/06', 'yyyy/mm/dd')),TO_TIMESTAMP('03:00', 'HH24:MI'),TO_TIMESTAMP('03:30', 'HH24:MI'),'VARSAVA',3,1);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (3,(TO_DATE('2018/01/07', 'yyyy/mm/dd')),TO_TIMESTAMP('12:00', 'HH24:MI'),TO_TIMESTAMP('00:50', 'HH24:MI'),'BRATISLAVA',4,5);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (4,(TO_DATE('2018/01/08', 'yyyy/mm/dd')),TO_TIMESTAMP('07:00', 'HH24:MI'),TO_TIMESTAMP('12:00', 'HH24:MI'),'PRAGUE',3,10);
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (5,(TO_DATE('2018/01/09', 'yyyy/mm/dd')),TO_TIMESTAMP('23:00', 'HH24:MI'),TO_TIMESTAMP('02:00', 'HH24:MI'),'BUDAPEST',6,5);

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

-- Vypise cestujici, kteri se neodbavili
SELECT DISTINCT jmeno, prijmeni, id_letu FROM Letenka L NATURAL LEFT JOIN Palubni_vstupenka WHERE id_letenky=null;

-- Vypise cestujici vcetne letu a mista
SELECT l.jmeno, l.prijmeni, l.id_letu, l.id_letenky, pv.id_mista, pv.id_palubni_vstupenky FROM Letenka l INNER JOIN Palubni_vstupenka pv ON l.id_letenky = pv.id_letenky;

-- Vypise seznam odletu vcetne data, casu, terminalu a gate (spojeni 3 tabulek)
SELECT id_letu, destinace, to_char(datum_odletu, 'DD.MM.YYYY') as datum, to_char(cas_odletu, 'HH24:MI') as cas, terminal.nazev as terminal, gate.nazev FROM Let, Gate, Terminal WHERE let.id_gate=gate.id_gate AND gate.id_terminalu=terminal.id_terminalu ORDER BY datum_odletu,cas_odletu;

-- Vypise pocet cestujicich na jednotlivych letech
SELECT id_letu, COUNT(*) as pocet_cestujicich FROM Let NATURAL JOIN Letenka GROUP BY id_letu;

-- Vypise pocet cestujicih v jednotlivych dnech
SELECT datum_odletu, COUNT(id_letenky) as pocet FROM Let NATURAL LEFT JOIN Letenka GROUP BY datum_odletu ORDER BY datum_odletu;

-- Vypise pro konkretni letadlo sezname gate z kterych muze letet
SELECT nazev FROM GATE G WHERE EXISTS (SELECT id_gate FROM TYP_LETADLAGATE T NATURAL JOIN Letadlo L WHERE T.id_gate=G.id_gate and L.id_letadla=1);

-- Vypise pro konkretni gate sezname letadel ktere z neho muzou letet
SELECT L.id_letadla FROM Letadlo L WHERE id_typu IN (SELECT T.id_typu FROM TYP_LETADLAGATE T WHERE T.id_gate=1);

-- Skript c. 4
-- Pokus o vlozeni neplatneho zaznamu do Letu, dane letadlo nemuze letet ze zadaneho gate
INSERT INTO Let (id_letu, datum_odletu, cas_odletu, doba_letu, destinace, id_letadla, id_gate) VALUES (6,(TO_DATE('2018/01/09', 'yyyy/mm/dd')),TO_TIMESTAMP('23:00', 'HH24:MI'),TO_TIMESTAMP('02:00', 'HH24:MI'),'BUDAPEST',6,1);

CREATE OR REPLACE PROCEDURE aktualizuj_destinaci (destinace_nova LET.DESTINACE%TYPE, destinace_stara LET.DESTINACE%TYPE) IS
    CURSOR c_lety IS 
        SELECT id_letu, destinace FROM LET WHERE destinace_stara = LET.DESTINACE;
    c_id LET.ID_LETU%TYPE;
    c_des LET.DESTINACE%TYPE;
BEGIN
    OPEN c_lety;
    LOOP
        FETCH c_lety INTO c_id, c_des;
        EXIT WHEN c_lety%NOTFOUND;
        UPDATE LET SET LET.DESTINACE = destinace_nova WHERE LET.ID_LETU = c_id;
        dbms_output.put_line(c_id || ': ' || c_des || ' -> ' || destinace_nova); 
    END LOOP;
    CLOSE c_lety;
END;
/

-- Vypis nezmenenych destinaci
BEGIN
    aktualizuj_destinaci('PRAHA', 'PRAGUE');
END;
/

-- Vypis upravenych destinaci
SELECT DISTINCT destinace FROM let ORDER BY destinace ASC;;
