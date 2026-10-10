# Verzel Store — Teste Técnico de QA

Repositório com a entrega do teste técnico de QA da **Verzel Store**: cenários de teste em Gherkin, execução dos testes (UI e API), report de bugs, evidências e automação com Playwright.

- **Aplicação testada:** https://verzel-store.qa-test-verzel-store.workers.dev/
- **API testada:** https://verzel-store.qa-test-verzel-store.workers.dev/api
- **Autor:** Daniel Bruno da Silva Nascimento

---

## Escopo testado

As regras de negócio cobertas, tanto na interface quanto na API, foram:

| Regra | O que foi validado |
|---|---|
| Cupom de desconto | Cupom `BEMVINDO10`; código sem distinção de maiúsculas/minúsculas e com espaços nas pontas; cupom inexistente; cupom expirado; apenas um cupom por vez; remoção e reaplicação |
| Frete grátis | Frete grátis a partir de R$ 200,00 sobre o subtotal **antes** do desconto; valor restante para o frete grátis; desconto não incide sobre o frete |
| Limite de itens | Máximo de 5 unidades por produto (5 aceito, acima disso rejeitado, inclusive com o mesmo produto repetido na lista) |
| Arredondamento | Desconto, frete e total com duas casas decimais |
| Finalização do pedido | Nome completo, e-mail e CEP (formatos válidos e inválidos, campos vazios) |

---

## Ferramentas utilizadas

| Ferramenta | Uso |
|---|---|
| **Playwright** (`@playwright/test`) | Automação dos testes de interface (web) |
| **Postman** | Testes manuais/exploratórios da API e coleta das evidências |
| **Gherkin** (`.feature`) | Escrita dos cenários de teste, em português |
| **Node.js / npm** | Execução do projeto e gerenciamento de dependências |
| **VS Code** | Ambiente de desenvolvimento |
| **Ferramentas de IA** | Veja a seção [Uso de ferramentas de IA](#uso-de-ferramentas-de-ia) |

---

## Estrutura de pastas

```
teste-verzel-qa/                      # raiz do repositório
├── README.md
└── teste-verzel-qa/                  # projeto
    ├── Automacao_tests/              # automação com Playwright
    │   ├── tests/
    │   │   ├── carrinho.spec.js      # adicionar e remover produtos do carrinho
    │   │   ├── cupom.spec.js         # aplicação do cupom BEMVINDO10
    │   │   └── pedidos.spec.js       # finalização de pedido com frete grátis
    │   └── resources/                # massa de dados dos testes
    │       ├── carrinho.json         # lista de produtos
    │       └── formulario.json       # dados do cliente (nome, e-mail, CEP)
    ├── features/                     # cenários em Gherkin
    │   ├── cenarios_web/
    │   │   ├── 01_cupom_desconto.feature
    │   │   ├── 02_frete.feature
    │   │   ├── 03_carrinho.feature
    │   │   ├── 04_arredondamento_valores.feature
    │   │   └── 05_pedidos.feature
    │   └── cenarios_api/
    │       ├── 01_produtos_e_comportamento_geral.feature
    │       ├── 02_calculo_do_carrinho.feature
    │       └── 03_pedidos.feature
    ├── docs/
    │   └── evidencias/
    │       ├── relatorio_bugs_web/
    │       │   └── relatorio_testes.pdf      # report de bugs da interface
    │       └── relatorio_testes_api/
    │           ├── Relatorio_testes_API.pdf  # report de bugs da API
    │           ├── 01.Consulta_produtos_comportamento/   # prints do Postman
    │           ├── 02.Calcula_carrinho/                  # prints do Postman
    │           └── 03.Pedidos/                           # prints do Postman
    ├── playwright.config.js          # configuração do Playwright
    ├── package.json                  # dependências e scripts
    ├── playwright-report/            # relatório HTML gerado pela execução
    └── test-results/                 # resultados e traces gerados pela execução
```

---

## O que foi realizado

### 1. Cenários de teste em Gherkin

Os cenários ficam em `features/` e estão separados por canal:

- **`cenarios_web/`**: comportamento visto pelo usuário na interface (cupom, frete, carrinho, arredondamento e finalização do pedido).
- **`cenarios_api/`**: contrato e regras de negócio da API, baseados na documentação do produto, cobrindo catálogo de produtos, cálculo do carrinho (`POST /api/carrinho/calcular`) e confirmação de pedidos (`POST /api/pedidos`), incluindo cenários negativos e de valor limite.

Os cenários referenciam os critérios de aceite da documentação (CA02, CA03, CA04, CA05, CA08, CA09, CA10, CA11).

### 2. Testes de API com Postman

Os endpoints foram exercitados no Postman com cenários positivos, negativos e de fronteira (por exemplo, subtotal exatamente igual a R$ 200,00, 5 e 6 unidades do mesmo produto, cupom expirado, corpo inválido, rotas e métodos inexistentes). Os prints de cada requisição e resposta estão em `docs/evidencias/relatorio_testes_api/`, organizados por endpoint e numerados na ordem de execução.

### 3. Automação com Playwright

Foram automatizados 4 testes de interface, em 3 specs:

| Spec | Teste | O que valida |
|---|---|---|
| `carrinho.spec.js` | Adicionar cada produto ao carrinho sequencialmente | Cada produto adicionado aparece no carrinho com quantidade 1 |
| `carrinho.spec.js` | Remover todos os produtos | Carrinho vazio exibe a mensagem esperada e o link "Ver produtos" volta para a vitrine |
| `cupom.spec.js` | Aplicar cupom de 10% | Mensagem de cupom aplicado e desconto igual a 10% do subtotal (com arredondamento) |
| `pedidos.spec.js` | Finalizar pedido com frete grátis | Frete "Grátis", preenchimento do formulário, confirmação do pedido (`VZ-XXXXXX`) e itens listados |

Detalhes da configuração (`playwright.config.js`):

- `testDir`: `./Automacao_tests/tests`
- `baseURL`: URL da Verzel Store
- Projetos de navegador: Chromium, Firefox e WebKit
- Script `test:e2e` executa com `--workers=1`, para evitar interferência entre testes que dependem do estado do carrinho
- Os dados de teste ficam separados do código, em `Automacao_tests/resources/`

### 4. Bugs encontrados

Os reports completos estão em `docs/evidencias/` (PDFs de web e API).

| ID | Onde | Resumo |
|---|---|---|
| BUG-001 | UI e API | Subtotal exatamente igual a R$ 200,00 cobra frete de R$ 19,90 em vez de frete grátis (CA06). Confirmado também em `POST /api/pedidos` |
| BUG-002 | API `POST /api/carrinho/calcular` | Aceita mais de 5 unidades do mesmo produto (retorna 200 e calcula), violando o limite (CA10) |
| BUG-003 | API `POST /api/pedidos` | Confirma pedido com mais de 5 unidades do mesmo produto (retorna 201 com número de pedido), violando o limite (CA10) |

**Observações que não foram classificadas como bug:**

- O campo de nome aceita apenas números (por exemplo, `000 000`); registrado como melhoria.
- Cupom expirado no `/api/carrinho/calcular` retorna 200 sem aplicar desconto; considerado comportamento esperado para esse endpoint.

---

## Como executar a automação

**Pré-requisito:** Node.js instalado.

```bash
# 1. entrar na pasta do projeto
cd teste-verzel-qa

# 2. instalar as dependências
npm install

# 3. baixar os navegadores do Playwright (apenas na primeira vez)
npx playwright install

# 4. executar os testes
npm run test:e2e

# 5. abrir o relatório HTML da última execução
npx playwright show-report
```

Opções úteis:

```bash
npx playwright test --project=chromium     # roda só no Chromium
npx playwright test --headed --workers=1   # mostra o navegador
npx playwright test --ui                   # abre o modo interativo (UI Mode)
```

## Uso de ferramentas de IA

### Ferramenta utilizada

Usei o **Claude (Anthropic)**, em conversas de chat, como assistente ao longo do teste. A IA apoiou o trabalho, mas a execução dos testes, a confirmação dos bugs e as decisões de classificação foram minhas.

### Em quais etapas

- **Cenários em Gherkin:** geração dos cenários da interface e da API, a partir da documentação do produto que forneci.
- **Planilha de casos de teste e estrutura de pastas:** apoio na organização dos casos e do projeto no VS Code.
- **Report de bugs:** apoio na redação dos reports (título, passos para reproduzir, resultado esperado e obtido) e do campo "Objetivo" do relatório de testes da API.
- **Automação com Playwright:** simplificação do código dos testes e ajuda para resolver erros de ambiente (erro de digitação em comandos, caminhos de `require`, conflito de versões do `@playwright/test` e duas cópias do projeto em pastas diferentes).
- **README:** estruturação do documento a partir do conteúdo do repositório.

### Como usei

Enviei contexto real para cada pedido: trechos da documentação, prints da aplicação e do Postman, código dos testes e mensagens de erro do terminal. Revisei cada resposta, pedi ajustes e repeti o ciclo até chegar ao resultado final.

### O que validei e decidi por conta própria

- **Bugs:** os problemas foram encontrados por mim na interface e confirmados na API pelo Postman antes de pedir o report. Os reports só descrevem comportamentos que reproduzi.
- **Classificação:** decidi o que é bug e o que é observação. Por exemplo, nome aceitando apenas números ficou como melhoria, e cupom expirado retornando 200 em `/api/carrinho/calcular` foi considerado comportamento esperado.
- **Automação:** executei os testes (incluindo o modo UI do Playwright) e corrigi o que não funcionava no meu ambiente.

### Aprendizados e limitações

- A IA acelerou a escrita de cenários, reports e documentação, mas o resultado só foi aceito depois de conferido com a execução real contra a aplicação.
- Em um dos erros de ambiente, a IA assumiu que existia um `package.json` na pasta que eu estava usando, e isso não era verdade. Só foi resolvido quando verifiquei a estrutura real das pastas, o que reforçou a importância de checar as sugestões antes de aplicá-las.
