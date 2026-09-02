# 🛒 Banco de Dados de E-commerce (DIO)

Este projeto implementa um **banco de dados relacional completo** para um sistema de **E-commerce**, modelado em **MySQL**, com tabelas integradas para clientes, produtos, pedidos, pagamentos, entregas e estoque.  
O objetivo é demonstrar o uso de **modelagem lógica**, **chaves estrangeiras**, **restrições de integridade** e **consultas SQL** aplicadas a um cenário de comércio eletrônico.

---

## 🧱 Estrutura do Projeto

O arquivo [`ecommerce.sql`](./ecommerce.sql) contém **toda a criação e povoamento do banco**, incluindo as tabelas, relacionamentos e consultas SQL de análise.

### 🗂️ Tabelas Criadas

| Tabela | Descrição |
|--------|------------|
| **clientes** | Armazena informações de pessoas físicas (PF) e jurídicas (PJ), com validação via `CHECK` para garantir consistência entre CPF e CNPJ. |
| **fornecedores** | Contém os dados das empresas fornecedoras de produtos. |
| **produtos** | Armazena os produtos disponíveis, com referência ao fornecedor. |
| **estoque** | Controla a quantidade e localização dos produtos. |
| **vendedores** | Registra os vendedores cadastrados na plataforma. |
| **pedidos** | Armazena as informações de cada pedido realizado, relacionando clientes e vendedores. |
| **pagamentos** | Controla as formas e status de pagamento dos pedidos. |
| **entregas** | Gerencia o status e o rastreamento das entregas. |
| **itens_pedido** | Faz a ligação entre pedidos e produtos (relação N:N). |

---

## 🧩 Principais Relacionamentos

- `clientes` 🔗 `pedidos` → (1:N)  
- `pedidos` 🔗 `itens_pedido` → (1:N)  
- `produtos` 🔗 `itens_pedido` → (1:N)  
- `fornecedores` 🔗 `produtos` → (1:N)  
- `pedidos` 🔗 `pagamentos` → (1:1)  
- `pedidos` 🔗 `entregas` → (1:1)  
- `vendedores` 🔗 `pedidos` → (1:N)

---

## ⚙️ Funcionalidades Implementadas

### ✅ Criação Completa do Banco
- Definição de **chaves primárias e estrangeiras**.  
- Uso de **ENUMs** e **CHECK constraints** para validar tipos e estados.  
- Controle de integridade referencial entre todas as entidades.

### ✅ Inserção de Dados de Exemplo
- Clientes PF e PJ com CPF/CNPJ válidos.  
- Produtos com fornecedores vinculados.  
- Estoque inicial com quantidades e localizações.  
- Vendedores, pedidos, pagamentos e entregas com dados simulados.

### ✅ Consultas SQL (Queries)

Algumas consultas prontas incluídas no script:

```sql
-- Pedidos e respectivos clientes
SELECT p.pedido_id, c.nome AS cliente, p.status, p.valor_total
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id;

-- Total de pedidos por cliente
SELECT c.nome AS cliente, COUNT(p.pedido_id) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
ORDER BY total_pedidos DESC;

-- Relação de produtos e fornecedores
SELECT pr.nome AS produto, f.nome AS fornecedor, e.quantidade
FROM produtos pr
JOIN fornecedores f ON pr.fornecedor_id = f.fornecedor_id
JOIN estoque e ON pr.produto_id = e.produto_id;

-- Valor médio de pedidos entregues
SELECT ROUND(AVG(valor_total), 2) AS media_valor_pedidos
FROM pedidos
WHERE status = 'Entregue';
