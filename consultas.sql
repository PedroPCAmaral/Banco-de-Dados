
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
SELECT supRG AS RG FROM Empregado WHERE dnum = 5;

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
