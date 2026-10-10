Feature: Aplicação de cupom de desconto
  Eu Como cliente da Verzel Store
  Quero aplicar um cupom de desconto
  Para reduzir o valor dos produtos da minha compra

Scenario: Aplicar o cupom BEMVINDO10
  Given que o carrinho contém 1 "Calça Jeans Slim" e 2 "Boné Aba Curva"
  When aplico o cupom "BEMVINDO10"
  Then o carrinho indica que o cupom foi aplicado
  And o subtotal exibido é "R$ 239,70"
  And  o desconto exibido é "R$ 23,97"
  And o frete exibido é "Gratis"
  And o total exibido é "R$ 215,73"

Scenario: Aplicar cupom utilizando letras minúsculas
  Given que o subtotal do carrinho é R$ 239,70
  When aplico o cupom "bemvindo10"
  Then o cupom deve ser aplicado
  And  o desconto exibido é "R$ 23,97"
  And o frete exibido é "Gratis"
  And o total exibido é "R$ 215,73"

Scenario: Aplicar cupom utilizando letras maiúsculas e minúsculas
  Given que o subtotal do carrinho é R$ 239,70
  When aplico o cupom "BeMvInDo10"
  Then o cupom deve ser aplicado
  And  o desconto exibido é "R$ 23,97"
  And o frete exibido é "Gratis"
  And o total exibido é "R$ 215,73"

Scenario: Aplicar cupom com espaços no início e no fim
  Given que o subtotal do carrinho é R$ 239,70
  When aplico o cupom "  BEMVINDO10  "
  Then o cupom deve ser aplicado
  And  o desconto exibido é "R$ 23,97"
  And o frete exibido é "Gratis"
  And o total exibido é "R$ 215,73"

Scenario: Aplicar cupom inexistente
  Given que o subtotal do carrinho é R$ 239,70
  When aplico o cupom "CUPOMINVALIDO"
  Then o cupom não deve ser aplicado
  And o desconto deve ser R$ 0,00
  And devo visualizar a mensagem "Cupom inválido."

Scenario: Aplicar cupom expirado
  Given que o subtotal do carrinho é R$ 239,70
  When aplico o cupom "VERAO2026"
  Then o cupom não deve ser aplicado
  And o desconto deve ser R$ 0,00
  And devo visualizar a mensagem "Cupom expirado."

Scenario: Impedir aplicação de dois cupons simultaneamente
  Given que o cupom "BEMVINDO10" está aplicado
  When tento aplicar outro cupom
  Then o sistema deve impedir a aplicação simultânea
  And apenas um cupom deve permanecer aplicado

Scenario: Remover cupom aplicado
  Given que o cupom "BEMVINDO10" está aplicado
  When removo o cupom
  Then o cupom não deve mais estar aplicado
  And o desconto deve ser R$ 0,00

Scenario: Aplicar novamente um cupom após remover o cupom atual
  Given que o cupom "BEMVINDO10" está aplicado
  When removo o cupom
  And aplico o cupom "VERAO2026"
  Then o sistema deve validar o novo cupom
  And o cupom expirado não deve gerar desconto


