SELECT nome_autor
FROM Autor;

SELECT titulo
FROM Livro;

SELECT nome
FROM Pessoa
WHERE saldo = 0;

SELECT nome
FROM Pessoa
WHERE idade < 18;

SELECT a.nome_autor, l.titulo
FROM Autor a
JOIN Livro l ON a.id_autor = l.id_autor;

SELECT a.nome_autor
FROM Autor a
LEFT JOIN Livro l ON a.id_autor = l.id_autor
WHERE l.id_livro IS NULL;

SELECT p.nome, l.titulo
FROM Pessoa p
JOIN Aluguel al ON p.id_pessoa = al.id_pessoa
JOIN Livro l ON al.id_livro = l.id_livro;

SELECT a.nome_autor, COUNT(l.id_livro) AS total_livros
FROM Autor a
LEFT JOIN Livro l ON a.id_autor = l.id_autor
GROUP BY a.nome_autor;

SELECT a.nome_autor, COUNT(l.id_livro) AS total_livros
FROM Autor a
JOIN Livro l ON a.id_autor = l.id_autor
GROUP BY a.nome_autor
ORDER BY total_livros DESC;

SELECT p.nome, COUNT(al.id_livro) AS total_alugados
FROM Pessoa p
JOIN Aluguel al ON p.id_pessoa = al.id_pessoa
WHERE YEAR(al.data_aluguel) IN (2024, 2025)
GROUP BY p.nome
ORDER BY total_alugados DESC;

