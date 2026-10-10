# language: pt
Feature: Catalogo de produtos e comportamento geral da API
    Eu Como consumidor da API da Verzel Store
    Quero consultar o catálogo e receber respostas padronizadas
    Para integrar com segurança

Scenario: Listar todos os produtos
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos"
    Then o status da resposta é 200
    And o corpo é uma lista com 8 produtos
    And cada produto possui os campos "id", "nome", "descricao", "categoria" e "preco"
    And o campo "preco" de cada produto é numérico

Scenario: Consultar a Camiseta Essencial pelo id
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/P001"
    Then o status da resposta é 200
    And o campo "id" é "P001"
    And o campo "nome" é "Camiseta Essencial"
    And o campo "preco" é 59.9


Scenario: Consultar produto com id P999 inexistente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/P999"
    Then o status da resposta é 404
    And o campo "erro.codigo" é "PRODUTO_NAO_ENCONTRADO"
    And o campo "erro.mensagem" não está vazio


Scenario: Consultar produto com id em minúsculas
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/p001"
    Then registro o status e o corpo retornados para análise


Scenario: Acessar rota inexistente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/inexistente"
    Then o status da resposta é 404
    And o campo "erro.codigo" é "ROTA_NAO_ENCONTRADA"


Scenario: Usar método HTTP não permitido em rota existente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio POST para "/produtos"
    Then o status da resposta é 405
    And o campo "erro.codigo" é "METODO_NAO_PERMITIDO"


Scenario: Enviar corpo que não é um objeto JSON válido
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio POST para "/carrinho/calcular" com o corpo bruto '{itens: ['
    Then o status da resposta é 400
    And o campo "erro.codigo" é "JSON_INVALIDO"

Scenario: Toda resposta de erro segue o formato padrão
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/P999"
    Then o corpo possui o objeto "erro"
    And "erro" possui os campos "codigo" e "mensagem"
