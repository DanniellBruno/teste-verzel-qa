# language: pt
Feature: Cálculo do carrinho com cupom e frete grátis (POST /api/carrinho/calcular)
    Eu Como cliente da Verzel Store
    Quero calcular meu carrinho com cupom e frete
    Para saber quanto vou pagar

Scenario: Calcular carrinho com cupom válido e frete grátis (exemplo da documentação)
    Given um carrinho com os itens "P002:1;P004:2"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 239.70
    And "desconto" é 23.97
    And "frete" é 0.00
    And "freteGratis" é true
    And "valorFaltanteFreteGratis" é 0.00
    And "total" é 215.73
    And "cupom.aplicado" é true
    And "cupom.mensagem" é "Cupom aplicado: 10% de desconto nos produtos."

Scenario: Cada item da resposta traz preço unitário, quantidade e total da linha
    Given um carrinho com os itens "P002:1;P004:2"
    When envio POST para "/carrinho/calcular"
    Then o item "P002" possui nome "Calça Jeans Slim", precoUnitario 139.9, quantidade 1 e total 139.9
    And o item "P004" possui nome "Boné Aba Curva", precoUnitario 49.9, quantidade 2 e total 99.8

Scenario: Calcular subtotal, desconto, frete e total sem cupom
    Given um carrinho com os itens "P005:1"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 100.00
    And "desconto" é 0.00
    And "frete" é 19.90
    And "freteGratis" é false
    And "valorFaltanteFreteGratis" é 100.00
    And "total" é 119.90

Scenario: Calcular valores no limite do frete grátis sem cupom
    Given um carrinho com os itens "P005:2"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 200.00
    And "desconto" é 0.00
    And "frete" é 0.00
    And "freteGratis" é true
    And "valorFaltanteFreteGratis" é 0.00
    And "total" é 200.00

Scenario: Calcular valores com cupom BEMVINDO10
    Given um carrinho com os itens "P005:1"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 100.00
    And "desconto" é 10.00
    And "frete" é 19.90
    And "freteGratis" é false
    And "valorFaltanteFreteGratis" é 100.00
    And "total" é 109.90

Scenario: Calcular valores com arredondamento de duas casas decimais (CA11)
    Given um carrinho com os itens "P001:3"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 179.70
    And "desconto" é 17.97
    And "frete" é 19.90
    And "freteGratis" é false
    And "valorFaltanteFreteGratis" é 20.30
    And "total" é 181.63

Scenario: A regra do frete grátis usa o subtotal antes do desconto (CA08)
    Given um carrinho com os itens "P005:2"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then "freteGratis" é true
    And "frete" é 0.00
    And "total" é 180.00

Scenario: O desconto do cupom não incide sobre o frete (CA09)
    Given um carrinho com os itens "P005:1"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then "desconto" é 10.00
    And "frete" é 19.90

Scenario: O valor faltante para o frete grátis nunca é negativo
    Given um carrinho com os itens "P007:5"
    When envio POST para "/carrinho/calcular"
    Then "valorFaltanteFreteGratis" é 0.00

Scenario: O cálculo não grava nada e é repetível
    Given um carrinho com os itens "P005:1"
    When envio POST para "/carrinho/calcular" duas vezes seguidas
    Then as duas respostas possuem exatamente os mesmos valores

Scenario: Código do cupom ignora maiúsculas, minúsculas e espaços nas pontas (CA02)
    Given um carrinho com os itens "P005:1"
    And o cupom "  bemvindo10 "
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é true
    And "desconto" é 10.00
    And "total" é 109.90

Scenario: Cupom inexistente não aplica desconto (CA03)
    Given um carrinho com os itens "P005:1"
    And o cupom "INVALIDO"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é false
    And "cupom.mensagem" é "Cupom inválido."
    And "desconto" é 0.00
    And "total" é 119.90

Scenario: Cupom expirado não aplica desconto (CA04)
    Given um carrinho com os itens "P005:1"
    And o cupom "VERAO2026"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é false
    And "cupom.mensagem" é "Cupom expirado."
    And "desconto" é 0.00
    And "total" é 119.90

Scenario: Cupom ausente é tratado como sem cupom
    Given um carrinho com os itens "P005:1"
    And o campo cupom está ausente
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "desconto" é 0.00
    And "total" é 119.90

Scenario: Cupom com tipo de dado inesperado (apenas um cupom por vez, CA05)
    Given um carrinho com os itens "P005:1"
    And o campo cupom é ["BEMVINDO10", "VERAO2026"]
    When envio POST para "/carrinho/calcular"
    Then o desconto retornado não é superior a 10.00
    And registro o status e o corpo retornados para análise

Scenario: Quantidade válida por produto no limite de 5 unidades (CA10)
    Given um carrinho com os itens "P005:5"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é 500.00

Scenario: Quantidade acima do máximo permitido é rejeitada
    Given um carrinho com os itens "P005:6"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[0].quantidade"

Scenario: Quantidade que não é inteiro maior ou igual a 1 é rejeitada
    Given um carrinho cujo item "P005" tem quantidade 0
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_INVALIDA"
    And "erro.campo" é "itens[0].quantidade"

Scenario: O erro de quantidade aponta o índice do item problemático
    Given um carrinho com os itens "P001:1;P002:6"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[1].quantidade"

Scenario: Lista de itens vazia é rejeitada
    Given um corpo de requisição com "itens" igual a []
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITENS_OBRIGATORIOS"

Scenario: Item que não é um objeto com produtoId e quantidade é rejeitado
    Given um corpo de requisição com "itens" igual a ["P001"]
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITEM_INVALIDO"

Scenario: Item referencia produto inexistente
    Given um carrinho com os itens "P999:1"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "PRODUTO_NAO_ENCONTRADO"

Scenario: Mesmo produto repetido na lista de itens
    Given um carrinho com os itens "P001:1;P001:2"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITEM_DUPLICADO"

Scenario: Produto repetido cuja soma ultrapassa 5 unidades
    Given um carrinho com os itens "P001:3;P001:3"
    When envio POST para "/carrinho/calcular"
    Then registro o código de erro retornado para análise

Scenario: Combinações de erros na mesma requisição
    Given um corpo de requisição com cupom inválido e quantidade 6
    When envio POST para "/carrinho/calcular"
    Then registro o status e o código de erro retornados para análise
