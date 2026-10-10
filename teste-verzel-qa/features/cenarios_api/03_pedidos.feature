Feature: Confirmação de pedidos (POST /api/pedidos)
    Eu Como cliente da Verzel Store
    Quero confirmar meu pedido com cupom e frete corretos
    Para finalizar minha compra com pagamento na entrega

Scenario: Confirmar pedido com cupom válido (exemplo da documentação)
    Given um pedido com os itens "P005:1"
    And o cupom "BEMVINDO10"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "numero" segue o formato "VZ-" seguido de 6 dígitos
    And "subtotal" é 100.00
    And "desconto" é 10.00
    And "frete" é 19.90
    And "freteGratis" é false
    And "valorFaltanteFreteGratis" é 100.00
    And "total" é 109.90
    And "cupom.aplicado" é true

Scenario: Confirmar pedido sem cupom
    Given um pedido com os itens "P005:1"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "desconto" é 0.00
    And "frete" é 19.90
    And "total" é 119.90

Scenario: Confirmar pedido com frete grátis e cupom
    Given um pedido com os itens "P002:1;P004:2"
    And o cupom "BEMVINDO10"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "subtotal" é 239.70
    And "desconto" é 23.97
    And "frete" é 0.00
    And "freteGratis" é true
    And "total" é 215.73

Scenario: A resposta do pedido traz criado Em, cliente normalizado e itens
    Given um pedido com os itens "P005:1"
    When envio POST para "/pedidos"
    Then "criadoEm" é uma data e hora válida no formato ISO 8601
    And "cliente.nome" é "Maria Silva"
    And "cliente.email" é "maria@exemplo.com"
    And "cliente.cep" é "01310100"
    And "itens" possui 1 item com produtoId "P005"

Scenario: Os valores do pedido são idênticos aos do cálculo do carrinho
    Given um pedido com os itens "P003:1"
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    And POST para "/pedidos" com os mesmos itens e cupom
    Then "subtotal", "desconto", "frete", "freteGratis", "valorFaltanteFreteGratis" e "total" são iguais nas duas respostas
    And "total" é 190.81

Scenario: Pedido exatamente no limite do frete grátis
    Given um pedido com os itens "P005:2"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "frete" é 0.00
    And "total" é 200.00

Scenario: Cupom informado em letras minúsculas é aceito no pedido (CA02)
    Given um pedido com os itens "P005:1"
    And o cupom "bemvindo10"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "desconto" é 10.00

Scenario: Pedidos não são armazenados e podem ser repetidos
    Given um pedido com os itens "P005:1"
    When envio POST para "/pedidos" duas vezes seguidas
    Then as duas respostas possuem status 201
    And ambas possuem "numero" no formato "VZ-000000"

Scenario: Pedido com cupom inexistente é rejeitado (CA03)
    Given um pedido com os itens "P005:1"
    And o cupom "INVALIDO"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "CUPOM_INVALIDO"
    And nenhum número de pedido é retornado

Scenario: Pedido com cupom expirado é rejeitado (CA04)
    Given um pedido com os itens "P005:1"
    And o cupom "VERAO2026"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "CUPOM_EXPIRADO"
    And nenhum número de pedido é retornado

Scenario: Pedido com quantidade acima de 5 unidades é rejeitado (CA10)
    Given um pedido com os itens "P001:6"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[0].quantidade"

Scenario: Pedido com exatamente 5 unidades de um produto é aceito (CA10)
    Given um pedido com os itens "P001:5"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "subtotal" é 299.50

Scenario: Pedido com quantidade inválida é rejeitado
    Given um pedido cujo item "P001" tem quantidade 0
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_INVALIDA"

Scenario: Pedido sem itens é rejeitado
    Given um pedido sem itens
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "ITENS_OBRIGATORIOS"

Scenario: Dados de cliente válidos são aceitos
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "cliente.cep" é "01310100"

Scenario: Nome sem sobrenome é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria", e-mail "maria@exemplo.com" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "nome"

Scenario: E-mail com formato inválido é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "email"

Scenario: E-mail sem domínio de topo
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@exemplo" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then registro o status e o corpo retornados para análise

Scenario: CEP fora do padrão de 8 dígitos é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "0131010"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "cep"

Scenario: Vários dados de cliente inválidos são reportados juntos
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria", e-mail "maria" e CEP "123"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa os campos "nome", "email" e "cep"
