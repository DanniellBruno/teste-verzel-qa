Feature: Arredondar desconto para duas casas decimais
    Eu Como cliente da Verzel Store
    Quero que os valores monetários sejam calculados e apresentados com duas casas decimais
    Para entender o desconto, o frete e o total correto da minha compra.

Scenario: Arredondar desconto para duas casas decimais
    Given que o subtotal é R$ 239,70
    And aplico o cupom "BEMVINDO10"
    When o carrinho é calculado
    Then o desconto deve ser exatamente R$ 23,97

Scenario: Exibir frete com duas casas decimais
    Given que o subtotal é inferior a R$ 200,00
    When o carrinho é calculado
    Then o frete deve ser exibido como R$ 19,90

Scenario: Exibir total com duas casas decimais
    Given que o subtotal é R$ 189,80
    And aplico o cupom "BEMVINDO10"
    When o carrinho é calculado
    Then o desconto deve ser R$ 18,98
    And o frete deve ser R$ 19,90
    And o total deve ser R$ 190,72