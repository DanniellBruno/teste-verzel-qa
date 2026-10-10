Feature: Finalização do pedido
    Eu Como cliente da Verzel Store
    Quero confirmar um pedido informando meus dados e os produtos escolhidos
    Para concluir minha compra com os valores calculados corretamente.

Scenario: Finalizar pedido com dados válidos
    Given que possuo produtos no carrinho
    And clico em "Finalizar Compra"
    And informo o nome "Maria Silva"
    And informo o e-mail "maria@exemplo.com"
    And informo o CEP "01310-100"
    When confirmo o pedido
    Then o pedido deve ser criado com sucesso
    And o número do pedido deve seguir o formato "VZ-000000"

Scenario: Aceitar CEP sem hífen
    Given que informo o CEP "01310100"
    When finalizo o pedido
    Then o CEP deve ser considerado válido

Scenario: Rejeitar nome sem sobrenome
    Given que informo o nome "Maria"
    And informo o e-mail "maria@exemplo.com"
    And informo o CEP "01310-100"
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe nome e sobrenome."

Scenario: Rejeitar e-mail inválido
    Given que informo o nome "Maria Silva"
    And informo o e-mail "maria@"
    And informo o CEP "01310-100"
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe um e-mail válido."

Scenario: Rejeitar CEP com quantidade incorreta de dígitos
    Given que informo o nome "Maria Silva"
    And informo o e-mail "maria@exemplo.com"
    And informo o CEP "0131010"
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe um CEP com 8 dígitos."

Scenario: Rejeitar Confirmar pedido sem nenhum dado preenchido
    Given que não informo o nome
    And não informo o e-mail
    And não informo o CEP
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe o nome completo."
    And deve aparecer a mensagem na tela "Informe o e-mail."
    And deve aparecer a mensagem na tela "Informe o CEP."

Scenario: Rejeitar Confirmar pedido somente com nome preenchido
    Given que informo o nome "Maria Silva"
    And não informo o e-mail
    And não informo o CEP
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe o e-mail."
    And deve aparecer a mensagem na tela "Informe o CEP."

Scenario: Rejeitar Confirmar pedido somente com email preenchido
    Given não que informo o nome
    And informo o e-mail "maria@exemplo.com"
    And não informo o CEP
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe o nome completo."
    And deve aparecer a mensagem na tela "Informe o CEP."

Scenario: Rejeitar Confirmar pedido somente com cep preenchido
    Given não que informo o nome
    And não informo o e-mail 
    And informo o CEP "01310-100"
    When confirmo o pedido
    Then o pedido não deve ser criado
    And deve aparecer a mensagem na tela "Informe o nome completo."
    And deve aparecer a mensagem na tela "Informe o e-mail."

