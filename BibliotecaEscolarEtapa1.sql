-- ===================================================
-- BANCO DE DADOS: Sistema de Biblioteca Escolar
-- 
-- ===================================================

-- Criação do Banco de Dados
DROP DATABASE IF EXISTS BibliotecaEscolar;
CREATE DATABASE BibliotecaEscolar;
USE BibliotecaEscolar;

-- ===================================================
-- TABELA: Pessoa
-- ===================================================
CREATE TABLE Pessoa (
    CPF CHAR(11) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    DataNascimento DATE NOT NULL
);

-- ===================================================
-- TABELA: Autor (especialização de Pessoa)
-- ===================================================
CREATE TABLE Autor (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- ===================================================
-- TABELA: Aluno (especialização de Pessoa)
-- ===================================================
CREATE TABLE Aluno (
    Matricula INT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    Entrada DATE NOT NULL,
    Ativo BOOLEAN NOT NULL,
    FOREIGN KEY (CPF) REFERENCES Pessoa(CPF)
);

-- ===================================================
-- TABELA: Curso
-- ===================================================
CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

-- ===================================================
-- TABELA: Turma
-- ===================================================
CREATE TABLE Turma (
    Codigo INT PRIMARY KEY,
    Semestre VARCHAR(20) NOT NULL,
    CursoCodigo INT NOT NULL,
    FOREIGN KEY (CursoCodigo) REFERENCES Curso(Codigo)
);

-- ===================================================
-- TABELA: Livro
-- ===================================================
CREATE TABLE Livro (
    ISBN CHAR(13) PRIMARY KEY,
    Titulo VARCHAR(150) NOT NULL,
    Ano YEAR NOT NULL,
    Editora VARCHAR(100) NOT NULL
);

-- ===================================================
-- TABELA: Relacionamento Autor - Livro (tem)
-- ===================================================
CREATE TABLE Autor_Livro (
    AutorID INT,
    LivroISBN CHAR(13),
    PRIMARY KEY (AutorID, LivroISBN),
    FOREIGN KEY (AutorID) REFERENCES Autor(ID),
    FOREIGN KEY (LivroISBN) REFERENCES Livro(ISBN)
);

-- ===================================================
-- TABELA: Empréstimo (Aluno registra Livro)
-- ===================================================
CREATE TABLE Emprestimo (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    AlunoMatricula INT NOT NULL,
    LivroISBN CHAR(13) NOT NULL,
    DataEmprestimo DATE NOT NULL,
    DataDevolucao DATE,
    FOREIGN KEY (AlunoMatricula) REFERENCES Aluno(Matricula),
    FOREIGN KEY (LivroISBN) REFERENCES Livro(ISBN)
);

-- ===================================================
-- TABELA: Relacionamento Aluno - Curso (cursa)
-- ===================================================
CREATE TABLE Aluno_Curso (
    AlunoMatricula INT,
    CursoCodigo INT,
    PRIMARY KEY (AlunoMatricula, CursoCodigo),
    FOREIGN KEY (AlunoMatricula) REFERENCES Aluno(Matricula),
    FOREIGN KEY (CursoCodigo) REFERENCES Curso(Codigo)
);

-- ===================================================
-- INSERINDO DADOS
-- ===================================================

-- Pessoas
INSERT INTO Pessoa (CPF, Nome, DataNascimento) VALUES
('11111111111', 'João Silva', '2000-05-10'),
('22222222222', 'Maria Oliveira', '1999-08-20'),
('33333333333', 'Carlos Souza', '1985-02-15'),
('44444444444', 'Ana Costa', '1998-11-25'),
('55555555555', 'Paulo Mendes', '1990-07-30');

-- Autores
INSERT INTO Autor (CPF) VALUES
('33333333333'),
('44444444444'),
('55555555555');

-- Alunos
INSERT INTO Aluno (Matricula, CPF, Entrada, Ativo) VALUES
(1001, '11111111111', '2020-02-01', TRUE),
(1002, '22222222222', '2021-03-01', TRUE),
(1003, '44444444444', '2019-01-15', FALSE);

-- Cursos
INSERT INTO Curso (Codigo, Nome) VALUES
(1, 'Ciência da Computação'),
(2, 'Engenharia'),
(3, 'Administração');

-- Turmas
INSERT INTO Turma (Codigo, Semestre, CursoCodigo) VALUES
(101, '2025-1', 1),
(102, '2025-1', 2),
(103, '2025-1', 3);

-- Livros
INSERT INTO Livro (ISBN, Titulo, Ano, Editora) VALUES
('9781234567890', 'Algoritmos em C', 2018, 'Pearson'),
('9789876543210', 'Banco de Dados Relacionais', 2019, 'Elsevier'),
('9781111111111', 'Estruturas de Dados', 2020, 'Saraiva');

-- Relacionamento Autor - Livro
INSERT INTO Autor_Livro (AutorID, LivroISBN) VALUES
(1, '9781234567890'),
(2, '9789876543210'),
(3, '9781111111111');

-- Empréstimos
INSERT INTO Emprestimo (AlunoMatricula, LivroISBN, DataEmprestimo, DataDevolucao) VALUES
(1001, '9781234567890', '2025-01-10', '2025-01-20'),
(1002, '9789876543210', '2025-02-05', NULL),
(1003, '9781111111111', '2025-03-01', '2025-03-15');

-- Relacionamento Aluno - Curso
INSERT INTO Aluno_Curso (AlunoMatricula, CursoCodigo) VALUES
(1001, 1),
(1002, 2),
(1003, 3);

-- BY Pedro Amaral