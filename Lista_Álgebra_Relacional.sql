-- BY PEDRO AMARAL

DROP TABLE IF EXISTS TrabalhaEm;
DROP TABLE IF EXISTS Dependente;
DROP TABLE IF EXISTS Projeto;
DROP TABLE IF EXISTS Localizacao;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Empregado;

CREATE TABLE Empregado (
  RG INT PRIMARY KEY,
  sexo CHAR(1),
  dt_nasc DATE,
  pnome VARCHAR(50),
  unome VARCHAR(50),
  rua VARCHAR(100),
  cidade VARCHAR(50),
  estado CHAR(2),
  salario DECIMAL(10,2),
  dnum INT,
  supRG INT,
  FOREIGN KEY (dnum) REFERENCES Departamento(dnum),
  FOREIGN KEY (supRG) REFERENCES Empregado(RG)
);

CREATE TABLE Departamento (
  dnum INT PRIMARY KEY,
  dnome VARCHAR(50),
  gerRG INT,
  dt_inicio DATE,
  FOREIGN KEY (gerRG) REFERENCES Empregado(RG)
);

CREATE TABLE Projeto (
  pnum INT PRIMARY KEY,
  pnome VARCHAR(50),
  localizacao VARCHAR(50),
  dnum INT,
  FOREIGN KEY (dnum) REFERENCES Departamento(dnum)
);

CREATE TABLE Dependente (
  dep_nome VARCHAR(50),
  dep_sexo CHAR(1),
  dep_dt_nasc DATE,
  empRG INT,
  FOREIGN KEY (empRG) REFERENCES Empregado(RG)
);

CREATE TABLE TrabalhaEm (
  RG INT,
  pnum INT,
  horas INT,
  FOREIGN KEY (RG) REFERENCES Empregado(RG),
  FOREIGN KEY (pnum) REFERENCES Projeto(pnum)
);

CREATE TABLE Localizacao (
  localizacao VARCHAR(50),
  dnum INT,
  FOREIGN KEY (dnum) REFERENCES Departamento(dnum)
);

-- Inserts de exemplo
INSERT INTO Empregado VALUES (1,'M','1980-01-01','Joao','Silva','Rua A','Londrina','PR',4000,5,NULL);
INSERT INTO Empregado VALUES (2,'F','1985-02-02','Maria','Souza','Rua B','Curitiba','PR',2500,4,1);
INSERT INTO Empregado VALUES (3,'M','1990-03-03','Carlos','Oliveira','Rua C','Londrina','PR',3500,5,1);

INSERT INTO Departamento VALUES (5,'Pesquisa',1,'2010-01-01');
INSERT INTO Departamento VALUES (4,'Administrativo',2,'2012-01-01');

INSERT INTO Projeto VALUES (10,'ProjetoX','Londrina',5);
INSERT INTO Projeto VALUES (20,'ProjetoY','Curitiba',4);

INSERT INTO Dependente VALUES ('Maria','F','2010-05-05',1);
INSERT INTO Dependente VALUES ('Carlos','M','2012-06-06',2);

INSERT INTO TrabalhaEm VALUES (1,10,20);
INSERT INTO TrabalhaEm VALUES (2,20,30);
INSERT INTO TrabalhaEm VALUES (3,10,15);

INSERT INTO Localizacao VALUES ('Londrina',5);
INSERT INTO Localizacao VALUES ('Curitiba',4);


-- 1
SELECT * FROM Empregado WHERE dnum = 5;

-- 2
SELECT * FROM Empregado WHERE salario > 3000;

-- 3
SELECT * FROM Empregado WHERE dnum = 5 AND salario > 3000;

-- 4
SELECT * FROM Empregado
WHERE (dnum = 5 AND salario > 3000)
   OR (dnum = 4 AND salario > 2000);

-- 5
SELECT pnome, salario FROM Empregado;

-- 6
SELECT pnome, salario FROM Empregado WHERE dnum = 5;

-- 7 
SELECT RG FROM Empregado WHERE dnum = 5
UNION
SELECT supRG AS RG FROM Empregado WHERE dnum = 5 AND supRG IS NOT NULL;

-- 8
SELECT DISTINCT e.pnome
FROM Empregado e
JOIN Dependente d ON e.pnome = d.dep_nome;

-- 9
SELECT e.pnome, d.dep_nome
FROM Empregado e CROSS JOIN Dependente d;

-- 10
SELECT e.pnome, d.dep_nome
FROM Empregado e
JOIN Dependente d ON e.RG = d.empRG;

-- 11
SELECT d.dnum, e.pnome AS gerente_pnome, e.unome AS gerente_unome
FROM Departamento d
JOIN Empregado e ON d.gerRG = e.RG;

-- 12
SELECT d.*, l.localizacao
FROM Departamento d
JOIN Localizacao l ON d.dnum = l.dnum;

-- 13
SELECT e.pnome, p.pnome AS projeto_nome
FROM Empregado e
JOIN TrabalhaEm t ON e.RG = t.RG
JOIN Projeto p ON t.pnum = p.pnum;

-- 14
SELECT DISTINCT e.pnome
FROM Empregado e
JOIN TrabalhaEm t ON e.RG = t.RG
JOIN Projeto p ON t.pnum = p.pnum
WHERE p.dnum = 5;

-- 15
SELECT COUNT(*) AS num_empregados FROM Empregado;

-- 16
SELECT dnum, COUNT(*) AS num_empregados
FROM Empregado
GROUP BY dnum;

-- 17
SELECT dnum, AVG(salario) AS media_salario
FROM Empregado
GROUP BY dnum;

-- 18
SELECT e.pnome, e.rua, e.cidade, e.estado
FROM Empregado e
JOIN Departamento d ON e.dnum = d.dnum
WHERE d.dnome = 'Pesquisa';

-- 19
SELECT p.pnum, p.dnum, e.pnome AS gerente_pnome, e.sexo AS gerente_sexo
FROM Projeto p
JOIN Departamento d ON p.dnum = d.dnum
JOIN Empregado e ON d.gerRG = e.RG
WHERE p.localizacao = 'Londrina';
