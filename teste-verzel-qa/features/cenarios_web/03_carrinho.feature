Feature: Carrinho de compras
  Eu Como cliente da Verzel Store
  Quero adicionar, alterar e remover produtos do carrinho
  Para conferir os itens e o subtotal antes de finalizar o pedido.

Scenario: Adicionar produto ao carrinho
  Given que estou na página da loja
  When adiciono o produto "Camiseta Essencial"
  Then o produto deve aparecer no carrinho
  And sua quantidade deve ser 1

Scenario: Adicionar até 5 unidades do mesmo produto
  Given que estou com o produto "Camiseta Essencial" no carrinho
  When aumento sua quantidade para 5
  Then a quantidade do produto deve ser 5
  And o sistema deve permitir a operação

Scenario: Impedir mais de 5 unidades do mesmo produto
  Given que estou com 5 unidades do produto "Camiseta Essencial"
  When tento adicionar a sexta unidade
  Then o sistema deve impedir a operação
  And a quantidade deve permanecer 5

Scenario: Calcular subtotal de múltiplas unidades
  Given que adiciono 3 unidades da "Camiseta Essencial"
  When visualizo o resumo do carrinho
  Then o subtotal deve ser R$ 179,70

Scenario: Remover produto do carrinho
  Given que existe um produto no carrinho
  When removo o produto
  Then o produto não deve mais aparecer
  And o subtotal deve ser atualizado
