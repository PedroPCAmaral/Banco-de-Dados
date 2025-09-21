# BibliotecaEscolar - Repositório do Projeto

## Estrutura do Repositório
- /sql
  - BibliotecaEscolar_full.sql     -- Script completo (criação + inserts + consultas + updates)
- /doc
  - DER_conceitual.png             -- Diagrama Entidade-Relacionamento conceitual (insira imagem)
  - Diagrama_Logico.png            -- Diagrama lógico (opcional: exporte do MySQL Workbench)
  - Diagrama_Fisico.png            -- Diagrama físico (opcional)
  - Relatorio_Final.pdf            -- Relatório final (PDF) - entregue pelo grupo
- README.md                        -- Este arquivo

## Como usar
1. Abra o MySQL Workbench ou outro cliente MySQL.
2. Execute o arquivo `sql/BibliotecaEscolar_full.sql`. Ele criará o banco `BibliotecaEscolar`, tabelas, e popul
ará as tabelas com dados de exemplo.
3. Para ver resultados execute as consultas SELECT já presentes no final do arquivo.
4. Faça capturas de tela (prints) dos resultados e inclua em `/doc/Relatorio_Final.pdf` como evidência.

## Conteúdo entregue
- Script SQL completo e testado logicamente.
- Scripts de exemplo para SELECT, UPDATE, INSERT e DELETE.
- Orientações para montar o relatório e organizar o repositório.

## Sugestões para o relatório (Relatorio_Final.pdf)
O relatório deve conter:
- Capa com nome do grupo, integrantes, disciplina e data.
- Tema escolhido e descrição detalhada.
- DER conceitual (imagem enviada anteriormente).
- Diagrama lógico (tabelas, PK, FK, tipos).
- Diagrama físico (tabelas com tipos e restrições para MySQL).
- Lista dos scripts SQL e instruções de execução.
- Prints de evidência (prints das consultas SELECT e logs de INSERT/UPDATE).
- Link do repositório (GitHub) e instruções de execução.
