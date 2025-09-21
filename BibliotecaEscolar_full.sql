-- ===================================================
-- BANCO DE DADOS: Sistema de Biblioteca Escolar (VERSÃO COMPLETA)
-- Criação das tabelas, inserções e scripts de manipulação (SELECT / UPDATE)
-- ===================================================

DROP DATABASE IF EXISTS BibliotecaEscolar;
CREATE DATABASE BibliotecaEscolar;
USE BibliotecaEscolar;

-- TABELA: Pessoa
CREATE TABLE Pessoa (
    CPF CHAR(11) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    DataNascimento DATE NOT NULL
);

-- TABELA: Autor (especialização de Pessoa)
CREATE TABLE Autor (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- TABELA: Aluno (especialização de Pessoa)
CREATE TABLE Aluno (
    Matricula INT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    Entrada DATE NOT NULL,
    Ativo BOOLEAN NOT NULL,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- TABELA: Curso
CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- TABELA: Turma
CREATE TABLE Turma (
    Codigo INT PRIMARY KEY,
    Semestre VARCHAR(20) NOT NULL,
    CursoCodigo INT NOT NULL,
    FOREIGN KEY (CursoCodigo) REFERENCES Curso(Codigo)
);

-- TABELA: Livro
CREATE TABLE Livro (
    ISBN CHAR(13) PRIMARY KEY,
    Titulo VARCHAR(150) NOT NULL,
    Ano YEAR NOT NULL,
    Editora VARCHAR(100) NOT NULL
);

-- TABELA: Autor_Livro (N:N)
CREATE TABLE Autor_Livro (
    AutorID INT,
    LivroISBN CHAR(13),
    PRIMARY KEY (AutorID, LivroISBN),
    FOREIGN KEY (AutorID) REFERENCES Autor(ID),
    FOREIGN KEY (LivroISBN) REFERENCES Livro(ISBN)
);

-- TABELA: Emprestimo
CREATE TABLE Emprestimo (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    AlunoMatricula INT NOT NULL,
    LivroISBN CHAR(13) NOT NULL,
    DataEmprestimo DATE NOT NULL,
    DataDevolucao DATE,
    FOREIGN KEY (AlunoMatricula) REFERENCES Aluno(Matricula),
    FOREIGN KEY (LivroISBN) REFERENCES Livro(ISBN)
);

-- TABELA: Aluno_Curso (N:N)
CREATE TABLE Aluno_Curso (
    AlunoMatricula INT,
    CursoCodigo INT,
    PRIMARY KEY (AlunoMatricula, CursoCodigo),
    FOREIGN KEY (AlunoMatricula) REFERENCES Aluno(Matricula),
    FOREIGN KEY (CursoCodigo) REFERENCES Curso(Codigo)
);

-- ===================================================
-- POPULAÇÃO: INSERTs
-- 5 pessoas (3 autores, 3 alunos entrelaçados) para flexibilidade
-- ===================================================

INSERT INTO Pessoa (CPF, Nome, DataNascimento) VALUES
('11111111111', 'João Silva', '2000-05-10'),
('22222222222', 'Maria Oliveira', '1999-08-20'),
('33333333333', 'Carlos Souza', '1985-02-15'),
('44444444444', 'Ana Costa', '1998-11-25'),
('55555555555', 'Paulo Mendes', '1990-07-30');

INSERT INTO Autor (CPF) VALUES
('33333333333'),
('44444444444'),
('55555555555');

INSERT INTO Aluno (Matricula, CPF, Entrada, Ativo) VALUES
(1001, '11111111111', '2020-02-01', TRUE),
(1002, '22222222222', '2021-03-01', TRUE),
(1003, '44444444444', '2019-01-15', FALSE);

INSERT INTO Curso (Codigo, Nome) VALUES
(1, 'Ciência da Computação'),
(2, 'Engenharia'),
(3, 'Administração');

INSERT INTO Turma (Codigo, Semestre, CursoCodigo) VALUES
(101, '2025-1', 1),
(102, '2025-1', 2),
(103, '2025-1', 3);

INSERT INTO Livro (ISBN, Titulo, Ano, Editora) VALUES
('9781234567890', 'Algoritmos em C', 2018, 'Pearson'),
('9789876543210', 'Banco de Dados Relacionais', 2019, 'Elsevier'),
('9781111111111', 'Estruturas de Dados', 2020, 'Saraiva');

INSERT INTO Autor_Livro (AutorID, LivroISBN) VALUES
(1, '9781234567890'),
(2, '9789876543210'),
(3, '9781111111111');

INSERT INTO Emprestimo (AlunoMatricula, LivroISBN, DataEmprestimo, DataDevolucao) VALUES
(1001, '9781234567890', '2025-01-10', '2025-01-20'),
(1002, '9789876543210', '2025-02-05', NULL),
(1003, '9781111111111', '2025-03-01', '2025-03-15');

INSERT INTO Aluno_Curso (AlunoMatricula, CursoCodigo) VALUES
(1001, 1),
(1002, 2),
(1003, 3);

-- ===================================================
-- SCRIPTS DE CONSULTA (SELECT) - exemplos solicitados no trabalho
-- ===================================================

-- 1) Listar todos os livros emprestados com dados do aluno e datas
SELECT e.ID AS EmprestimoID, l.ISBN, l.Titulo, a.Matricula, p.Nome AS NomeAluno,
       e.DataEmprestimo, e.DataDevolucao
FROM Emprestimo e
JOIN Livro l ON e.LivroISBN = l.ISBN
JOIN Aluno a ON e.AlunoMatricula = a.Matricula
JOIN Pessoa p ON a.CPF = p.CPF;

-- 2) Obter lista de autores e livros que escreveram
SELECT au.ID AS AutorID, p.Nome AS NomeAutor, l.ISBN, l.Titulo
FROM Autor au
JOIN Pessoa p ON au.CPF = p.CPF
JOIN Autor_Livro al ON au.ID = al.AutorID
JOIN Livro l ON al.LivroISBN = l.ISBN
ORDER BY NomeAutor;

-- 3) Alunos ativos por curso
SELECT c.Codigo, c.Nome AS Curso, COUNT(a.Matricula) AS QtdAlunosAtivos
FROM Curso c
LEFT JOIN Aluno_Curso ac ON c.Codigo = ac.CursoCodigo
LEFT JOIN Aluno a ON ac.AlunoMatricula = a.Matricula
WHERE a.Ativo = TRUE
GROUP BY c.Codigo, c.Nome;

-- 4) Livros sem empréstimo (disponíveis)
SELECT l.ISBN, l.Titulo FROM Livro l
LEFT JOIN Emprestimo e ON l.ISBN = e.LivroISBN
WHERE e.ID IS NULL OR e.DataDevolucao IS NOT NULL;

-- 5) Histórico de empréstimos de um aluno (exemplo matrícula = 1001)
SELECT e.ID, l.Titulo, e.DataEmprestimo, e.DataDevolucao
FROM Emprestimo e JOIN Livro l ON e.LivroISBN = l.ISBN
WHERE e.AlunoMatricula = 1001
ORDER BY e.DataEmprestimo DESC;

-- ===================================================
-- SCRIPTS DE ATUALIZAÇÃO (UPDATE) - exemplos solicitados no trabalho
-- ===================================================

-- 1) Registrar devolução: atualizar DataDevolucao do empréstimo ID = 2
UPDATE Emprestimo
SET DataDevolucao = CURDATE()
WHERE ID = 2;

-- 2) Marcar aluno inativo/ativo
UPDATE Aluno SET Ativo = FALSE WHERE Matricula = 1002;
UPDATE Aluno SET Ativo = TRUE WHERE Matricula = 1003;

-- 3) Corrigir título de um livro
UPDATE Livro SET Titulo = 'Algoritmos em Linguagem C' WHERE ISBN = '9781234567890';

-- ===================================================
-- SCRIPTS ADICIONAIS DE MANIPULAÇÃO (INSERT / DELETE) - exemplos
-- ===================================================

-- Inserir novo livro + relacionamento com autor
INSERT INTO Livro (ISBN, Titulo, Ano, Editora) VALUES ('9782222222222', 'Introdução a SQL', 2021, 'Novatec');
INSERT INTO Autor_Livro (AutorID, LivroISBN) VALUES (1, '9782222222222');

-- Registrar novo empréstimo
INSERT INTO Emprestimo (AlunoMatricula, LivroISBN, DataEmprestimo) VALUES (1001, '9782222222222', '2025-04-01');

-- Excluir um empréstimo cancelado (exemplo)
DELETE FROM Emprestimo WHERE ID = 9999; -- não existente, exemplo de sintaxe

-- ===================================================
-- FIM DO SCRIPT
-- ============================BY PEDRO AMARAL
