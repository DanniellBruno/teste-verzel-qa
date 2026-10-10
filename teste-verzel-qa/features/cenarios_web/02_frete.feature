Feature: Regra de frete grátis
  Eu Como cliente da Verzel Store
  Quero saber quando tenho direito ao frete grátis
  Para entender o valor final da minha compra

Scenario: Obter frete grátis com subtotal superior a R$ 200,00
  Given que o subtotal do carrinho é R$ 239,70
  When visualizo o resumo da compra
  Then o frete deve ser "Gratis"

Scenario: Obter frete grátis com subtotal exatamente igual a R$ 200,00
  Given que o subtotal do carrinho é R$ 200,00
  When visualizo o resumo da compra
  Then o frete deve ser R$ "Gratis"

Scenario: Cobrar frete abaixo de R$ 200,00
  Given que o subtotal do carrinho é R$ 199,80
  When visualizo o resumo da compra
  Then o frete deve ser R$ 19,90
  And o total do carrinho é  "R$ 219,70"

Scenario: Informar valor restante para frete grátis
  Given que o subtotal do carrinho é R$ 199,80
  When visualizo o resumo da compra
  Then devo visualizar que faltam R$ 0,20 para o frete grátis

Scenario: Calcular frete grátis com cupom aplicado
  Given que o subtotal dos produtos é R$ 239,70
  And aplico o cupom "BEMVINDO10"
  Then o desconto deve ser R$ 23,97
  And o frete deve ser "Gratis"
  And o total deve ser R$ 215,73

Scenario: Calcular frete considerando o subtotal antes do desconto
  Given que o subtotal dos produtos é R$ 239,70
  And aplico o cupom "BEMVINDO10"
  When visualizo o resumo da compra
  Then o subtotal utilizado para a regra do frete deve ser R$ 239,70
  And o frete deve ser "Gratis"

Scenario: Cobrar frete quando o subtotal é inferior a R$ 200 mesmo com desconto
  Given que o subtotal dos produtos é R$ 189,90
  And aplico o cupom "BEMVINDO10"
  When visualizo o resumo da compra
  Then o desconto deve ser R$ 18,99
  And  frete deve ser R$ 19,90
  And o total deve ser R$ 190,81

