# Resoluções - Lista de Álgebra Relacional (Laboratório de Banco de Dados)

**Esquema (resumo):**
- Empregado(RG, sexo, dt_nasc, pnome, unome, rua, cidade, estado, salario, dnum, supRG)
- Departamento(dnum, dnome, gerRG, dt_inicio)
- Projeto(pnum, pnome, localizacao, dnum)
- Dependente(dep_nome, dep_sexo, dep_dt_nasc, empRG)
- TrabalhaEm(RG, pnum, horas)
- Localizacao(localizacao, dnum)

> Notação usada:
- σ: seleção (where)
- π: projeção (select columns)
- ⋈: junção natural (natural join) ou explicitada com condição
- ×: produto cartesiano
- ∪, ∩, − : união, interseção, diferença
- ρ: renomeação
- γ: agregação (group by) — explicada quando usada

---

## Questões (1 a 19)

1. **Retorne os empregados que trabalham no departamento 5**

Álgebra relacional:
```
σ_{dnum = 5}(Empregado)
```

SQL equivalente:
```sql
SELECT * FROM Empregado WHERE dnum = 5;
```

2. **Retorne os empregados com salário maior que 3000,00**

Álgebra relacional:
```
σ_{salario > 3000}(Empregado)
```

SQL:
```sql
SELECT * FROM Empregado WHERE salario > 3000;
```

3. **Retorne os empregados que trabalham no departamento 5 e têm salário maior que 3000,00**

Álgebra relacional:
```
σ_{dnum = 5 ∧ salario > 3000}(Empregado)
```

SQL:
```sql
SELECT * FROM Empregado WHERE dnum = 5 AND salario > 3000;
```

4. **Retorne os empregados que trabalham no departamento 5 e têm salário maior que 3000,00 ou que trabalham no departamento 4 e têm salário maior que 2000,00**

Álgebra relacional:
```
σ_{(dnum=5 ∧ salario>3000) ∨ (dnum=4 ∧ salario>2000)}(Empregado)
```

SQL:
```sql
SELECT * FROM Empregado
WHERE (dnum = 5 AND salario > 3000)
   OR (dnum = 4 AND salario > 2000);
```

5. **Retorne o primeiro nome e o salário de cada empregado**

Álgebra relacional:
```
π_{pnome, salario}(Empregado)
```

SQL:
```sql
SELECT pnome, salario FROM Empregado;
```

6. **Retorne o primeiro nome e o salário dos empregados que trabalham no departamento 5**

Álgebra relacional:
```
π_{pnome, salario}(σ_{dnum = 5}(Empregado))
```

SQL:
```sql
SELECT pnome, salario FROM Empregado WHERE dnum = 5;
```

7. **Retorne o RG de todos os empregados que trabalham no departamento 5 ou supervisionam diretamente um empregado que trabalha no departamento 5**

Álgebra relacional (1ª forma — usando junção com supervisão):
```
A = σ_{dnum = 5}(Empregado)             -- empregados que trabalham no depto 5
B = π_{supRG}(A)                        -- coletar supRG dos empregados do depto 5
Result = π_{RG}(σ_{RG ∈ B}(Empregado))  -- empregados cujo RG está em B (supervisores)
Final = π_{RG}(A) ∪ Result
```
Mais direta:
```
π_{RG}(σ_{dnum = 5}(Empregado)) ∪ π_{supRG}(σ_{dnum = 5}(Empregado))
```

SQL:
```sql
-- RG de empregados que trabalham no departamento 5
SELECT RG FROM Empregado WHERE dnum = 5
UNION
-- RG de supervisores (supRG) de empregados que trabalham no departamento 5
SELECT supRG AS RG FROM Empregado WHERE dnum = 5;
```

8. **Retorne os primeiros nomes de empregados que são iguais a nomes de dependentes**

Álgebra relacional:
```
π_{pnome}(Empregado) ∩ π_{dep_nome}(Dependente)
```
ou usando junção:
```
π_{pnome}(Empregado ⋈_{pnome = dep_nome} Dependente)
```

SQL:
```sql
SELECT DISTINCT e.pnome
FROM Empregado e
JOIN Dependente d ON e.pnome = d.dep_nome;
```

9. **Retorne todas as combinações de primeiro nome de empregados e nome de dependentes**

Álgebra relacional:
```
π_{pnome, dep_nome}(Empregado × Dependente)
```

SQL:
```sql
SELECT e.pnome, d.dep_nome
FROM Empregado e CROSS JOIN Dependente d;
```

10. **Retorne os nomes dos empregados e de seus respectivos dependentes**

Álgebra relacional:
```
π_{pnome, dep_nome}(Empregado ⋈_{RG = empRG} Dependente)
```

SQL:
```sql
SELECT e.pnome, d.dep_nome
FROM Empregado e
JOIN Dependente d ON e.RG = d.empRG;
```

11. **Retorne o nome do gerente de cada departamento**

Álgebra relacional:
```
π_{dnum, gerente_pnome, gerente_unome}(
  Departamento ⋈_{gerRG = RG} (ρ_{RG, pnome AS gerente_pnome, unome AS gerente_unome}(Empregado))
)
```
ou mais simples:
```
π_{dnum, pnome, unome}(Departamento ⋈_{gerRG = RG} Empregado)
```

SQL:
```sql
SELECT d.dnum, e.pnome AS gerente_pnome, e.unome AS gerente_unome
FROM Departamento d
JOIN Empregado e ON d.gerRG = e.RG;
```

12. **Retorne todas as localizações de cada departamento usando junção natural**

Álgebra relacional:
```
Departamento ⋈ Localizacao
```
(Se atributos compartilham o nome `dnum`, junção natural usa isso.)

SQL:
```sql
SELECT d.*, l.localizacao
FROM Departamento d
JOIN Localizacao l ON d.dnum = l.dnum;
```

13. **Retorne o nome do empregado e o nome de cada projeto que ele trabalha**

Álgebra relacional:
```
π_{pnome, pnome_projeto}(
  (Empregado ⋈_{RG = RG} TrabalhaEm) ⋈_{pnum = pnum} Projeto
)
```
Renomeando para clareza:
```
π_{Empregado.pnome, Projeto.pnome}(
  (Empregado ⋈_{Empregado.RG = TrabalhaEm.RG} TrabalhaEm)
    ⋈_{TrabalhaEm.pnum = Projeto.pnum} Projeto
)
```

SQL:
```sql
SELECT e.pnome, p.pnome AS projeto_nome
FROM Empregado e
JOIN TrabalhaEm t ON e.RG = t.RG
JOIN Projeto p ON t.pnum = p.pnum;
```

14. **Retorne o nome dos empregados que trabalham em algum projeto controlado pelo departamento 5**

Álgebra relacional:
```
ProjDept5 = σ_{dnum = 5}(Projeto)
Resultado = π_{pnome}(
  Empregado ⋈ TrabalhaEm ⋈_{TrabalhaEm.pnum = Projeto.pnum} ProjDept5
)
```

SQL:
```sql
SELECT DISTINCT e.pnome
FROM Empregado e
JOIN TrabalhaEm t ON e.RG = t.RG
JOIN Projeto p ON t.pnum = p.pnum
WHERE p.dnum = 5;
```

15. **Retorne o número de empregados da empresa**

Álgebra relacional (usando agregação):
```
γ_{COUNT(RG) -> num_empregados}(Empregado)
```

SQL:
```sql
SELECT COUNT(*) AS num_empregados FROM Empregado;
```

16. **Retorne o número do departamento e o número de empregados de CADA departamento da empresa**

Álgebra relacional:
```
γ_{dnum; COUNT(RG) -> num_empregados}(Empregado)
```

SQL:
```sql
SELECT dnum, COUNT(*) AS num_empregados
FROM Empregado
GROUP BY dnum;
```

17. **Retorne o número do departamento e a média do salário dos empregados de CADA departamento da empresa**

Álgebra relacional:
```
γ_{dnum; AVG(salario) -> media_salario}(Empregado)
```

SQL:
```sql
SELECT dnum, AVG(salario) AS media_salario
FROM Empregado
GROUP BY dnum;
```

18. **Retorne o nome e o endereço de todos os empregados que trabalham no departamento 'Pesquisa'**

Álgebra relacional:
```
DeptPesquisa = σ_{dnome = 'Pesquisa'}(Departamento)
Resultado = π_{pnome, rua, cidade, estado}(
  Empregado ⋈_{Empregado.dnum = DeptPesquisa.dnum} DeptPesquisa
)
```

SQL:
```sql
SELECT e.pnome, e.rua, e.cidade, e.estado
FROM Empregado e
JOIN Departamento d ON e.dnum = d.dnum
WHERE d.dnome = 'Pesquisa';
```

19. **Para cada projeto localizado em 'Londrina', retorne o número do projeto, o número do departamento que o controla, e o nome e sexo do gerente do departamento**

Álgebra relacional:
```
ProjLondrina = σ_{localizacao = 'Londrina'}(Projeto)
Resultado = π_{pnum, Projeto.dnum, e.pnome, e.sexo}(
  (ProjLondrina ⋈ Departamento) ⋈_{gerRG = RG} Empregado AS e
)
```

SQL:
```sql
SELECT p.pnum, p.dnum, e.pnome AS gerente_pnome, e.sexo AS gerente_sexo
FROM Projeto p
JOIN Departamento d ON p.dnum = d.dnum
JOIN Empregado e ON d.gerRG = e.RG
WHERE p.localizacao = 'Londrina';
```

---

## Observações finais
- As expressões de álgebra relacional foram escritas em forma textual para facilitar leitura e conversão direta para SQL.
- Em alguns exercícios usei renomeações implícitas para clareza (por exemplo, distinguir `pnome` do empregado e `pnome` do projeto).
- Se você quiser o mesmo conteúdo em PDF formatado (com tabela de conteúdos, numeração e estilos), eu também posso gerar — mas por ora incluí em Markdown para facilitar edição.
