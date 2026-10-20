
# Sales Lead Management — Avance Educação Profissional

Projeto de portfólio desenvolvido em Salesforce para gerenciamento do processo comercial da **Avance Educação Profissional**, desde a entrada e qualificação de Leads até a conversão e o acompanhamento do pipeline comercial.

O projeto demonstra conhecimentos práticos em **Salesforce Development, configuração declarativa, automação, integração com API externa, Apex, Lightning Web Components, testes automatizados, segurança e versionamento com Git/GitHub**.

---

## 📌 Visão geral

A solução representa um processo comercial para captação e acompanhamento de potenciais alunos:

**Lead → Qualificação → Conversão → Account + Contact + Opportunity → Pipeline → Closed Won / Closed Lost**

A implementação segue uma abordagem **native-first**, priorizando recursos nativos e declarativos do Salesforce antes de utilizar desenvolvimento customizado.

O projeto combina recursos do Sales Cloud, Salesforce Flow, Apex, Lightning Web Components e integrações externas para demonstrar um fluxo comercial próximo de um cenário empresarial.

---

## 🎯 Objetivos

- Modelar um processo comercial no Salesforce.
- Gerenciar o ciclo de vida dos Leads.
- Validar CPF e CNPJ antes da criação do Lead.
- Integrar o Salesforce com uma API externa de validação.
- Automatizar tarefas de follow-up comercial.
- Demonstrar o processo nativo de conversão de Leads.
- Gerenciar o pipeline de Opportunities.
- Desenvolver uma interface customizada com Lightning Web Components.
- Implementar Apex com tratamento de exceções e testes automatizados.
- Aplicar boas práticas de segurança e acesso aos dados.
- Utilizar Custom Metadata Types para externalizar configurações de automação.
- Utilizar Salesforce DX, Git e GitHub para versionamento.
- Criar uma identidade visual personalizada para o painel de gerenciamento de Leads.

---

## 🏗️ Arquitetura da solução

A arquitetura segue a seguinte prioridade:

**Salesforce Native → Configuração Declarativa → Flow → LWC/Aura → Apex quando necessário**

```text
                         Salesforce
                             |
                         Sales Cloud
                             |
                +------------+------------+
                |                         |
              Leads                 Opportunities
                |                         |
        Cadastro Inteligente         Sales Pipeline
                |                         |
           Screen Flow              Closed Won / Lost
                |
         Pessoa Física / Jurídica
                |
            CPF / CNPJ
                |
       Integração com API externa
                |
       Validação dos dados cadastrais
                |
           Criar ou validar Lead
                |
          Qualificação comercial
                |
       Follow-up automatizado
                |
       Conversão nativa Salesforce
                |
     Account + Contact + Opportunity
```

### Princípios técnicos

- Priorizar recursos padrão do Salesforce.
- Utilizar configuração declarativa sempre que possível.
- Usar Flow para automações de negócio apropriadas.
- Utilizar LWC quando for necessária uma experiência de interface personalizada.
- Utilizar Apex quando a lógica exigir processamento customizado.
- Separar Trigger e Handler.
- Externalizar configurações de automação por meio de Custom Metadata Types.
- Validar cenários positivos, negativos e de borda.
- Considerar sharing, CRUD e FLS nas operações de dados.

---

## 🔄 Processo comercial

O projeto utiliza os seguintes status de Lead no processo de qualificação:

| Status | Significado |
|---|---|
| Open - Not Contacted | Lead recebido, ainda sem contato realizado. |
| Working - Contacted | O vendedor realizou contato e está trabalhando o Lead. |
| Qualified | Interesse e perfil confirmados; Lead apto a avançar no processo comercial. |
| Closed - Converted | Lead convertido no Salesforce. |
| Closed - Not Converted | Lead encerrado sem conversão. |

Após a qualificação, o processo pode seguir pela conversão nativa do Salesforce, relacionando os registros de Account, Contact e Opportunity.

O pipeline de Opportunities é utilizado para acompanhar a evolução comercial até a conclusão ou perda da oportunidade.

---

## 👤 Cadastro inteligente de Leads

O projeto contém o Screen Flow **Cadastro Inteligente de Lead**, com uma experiência guiada para cadastro de Pessoa Física (PF) ou Pessoa Jurídica (PJ).

### Fluxo funcional

1. O usuário inicia o cadastro inteligente.
2. Seleciona o tipo de cliente.
3. Preenche as informações correspondentes ao cenário PF ou PJ.
4. Informa CPF ou CNPJ e os dados comerciais do curso.
5. A validação cadastral é executada conforme a implementação.
6. O Flow conduz o processo de criação do Lead.
7. O registro segue o processo comercial de qualificação.

O projeto também contém a personalização da ação de criação de Lead por meio de um componente Aura, que inicia o Flow `Cadastro Inteligente de Lead`.

### Integração CPF/CNPJ

A classe `CpfCnpjValidator` implementa a integração de validação cadastral utilizada pelo fluxo.

A integração utiliza configuração de conexão do Salesforce por meio de Named Credential, evitando a necessidade de manter detalhes de conexão diretamente na lógica de negócio.

A solução demonstra:

- Integração entre Flow e Apex.
- Validação de informações cadastrais.
- Separação entre configuração de conexão e lógica de negócio.
- Tratamento de respostas e erros da integração.
- Reutilização de lógica de validação.

---

## ⚙️ Desenvolvimento Apex

O projeto contém classes Apex para operações com Leads, automações de negócio e processamento assíncrono.

### LeadApexService

Classe responsável por operações relacionadas a Leads.

Principais métodos:

- `buscarLeadsNaoConvertidos()`
- `criarLeadDeTeste()`
- `atualizarStatusLead(Id leadId, String novoStatus)`

A classe demonstra:

- SOQL.
- DML.
- Métodos estáticos.
- Manipulação de registros Salesforce.
- Tratamento de condições inválidas.
- Verificações de acesso ao objeto e aos campos utilizados.
- Validações antes da atualização dos registros.

A classe utiliza `with sharing` e `LeadValidationException` para representar condições inválidas, como ID nulo ou Lead inexistente.

### LeadBusinessTrigger e LeadBusinessHandler

A `LeadBusinessTrigger` é executada nos eventos `before insert` e `before update` de Leads.

Quando um Lead atende às condições configuradas para qualificação e não possui descrição, o Handler preenche automaticamente o campo Description.

A mensagem e o status utilizados pela automação são obtidos de configuração ativa em Custom Metadata Type.

A implementação utiliza o padrão de separação entre Trigger e Handler, favorecendo:

- Organização do código.
- Manutenção.
- Reutilização.
- Testabilidade.
- Centralização das regras de negócio.

### LeadFollowUpBatch

Classe Batch Apex responsável por localizar Leads não convertidos que atendam ao status configurado para acompanhamento e que ainda não possuam descrição.

A descrição é preenchida usando a mensagem definida no Custom Metadata Type `Batch_Follow_Up`.

A implementação demonstra:

- `Database.Batchable<SObject>`.
- `Database.QueryLocator`.
- Processamento em lotes.
- Atualização condicional de registros.
- Execução assíncrona.
- Leitura de configuração ativa.
- Logging com níveis de severidade e informações de execução.

### LeadFollowUpQueueable

Classe Queueable Apex responsável pelo acompanhamento assíncrono de Leads.

A classe:

1. Consulta a configuração ativa `Queueable_Follow_Up`.
2. Obtém o status definido na configuração.
3. Consulta Leads não convertidos elegíveis.
4. Identifica registros sem descrição.
5. Preenche a descrição com a mensagem configurada.
6. Atualiza os registros elegíveis.
7. Registra informações sobre a execução.

A implementação demonstra:

- Interface `Queueable`.
- Método `execute`.
- `System.enqueueJob()`.
- Processamento assíncrono.
- Atualização condicional de registros.
- Uso de Custom Metadata Types.
- Logging com `LoggingLevel.WARN` e `LoggingLevel.INFO`.

---

## ⚙️ Custom Metadata Types

O projeto utiliza o Custom Metadata Type:

`Lead_Automation_Configuration__mdt`

O objetivo é externalizar parâmetros das automações Apex, evitando que status e mensagens precisem ficar fixos diretamente no código.

### Campos

| Campo | Tipo | Finalidade |
|---|---|---|
| `Active__c` | Checkbox | Indica se a configuração está ativa. |
| `Trigger_Status__c` | Text (80) | Status utilizado para selecionar os Leads elegíveis. |
| `Description_Message__c` | Text (255) | Mensagem aplicada à descrição do Lead. |

### Registros de configuração

| Developer Name | Finalidade |
|---|---|
| `Qualified_Lead` | Configuração utilizada pelo Trigger/Handler para Leads qualificados. |
| `Batch_Follow_Up` | Configuração utilizada pelo Batch Apex. |
| `Queueable_Follow_Up` | Configuração utilizada pelo Queueable Apex. |

As automações verificam se a configuração correspondente existe e está ativa antes de executar o processamento.

### Benefícios da abordagem

- Centralização dos parâmetros de negócio.
- Menor acoplamento entre regra de negócio e configuração.
- Facilidade para ajustar status e mensagens.
- Configurações versionáveis junto com o projeto.
- Possibilidade de desativar uma automação por configuração, quando implementado pelo respectivo componente.

---

## 🧩 Exceções personalizadas

O projeto contém uma exceção Apex personalizada para representar erros específicos de validação de Leads:

- `LeadValidationException`
- `LeadValidationService`
- `LeadValidationServiceTest`

O `LeadValidationService` realiza validações em memória antes de qualquer operação de DML.

Entre os cenários tratados estão:

- Lead nulo.
- Sobrenome obrigatório.
- Empresa obrigatória.

Quando uma regra é violada, o serviço lança `LeadValidationException` com uma mensagem específica para o cenário.

A classe de testes cobre cenários positivos e negativos, incluindo os casos em que uma regra de validação não é atendida.

---

## 🧪 Testes automatizados

O projeto contém classes de teste Apex e testes Jest para verificar o comportamento das implementações customizadas.

### Testes Apex

| Classe de teste | Principais cenários |
|---|---|
| `LeadApexServiceTest` | Busca, criação e atualização de Leads, IDs inválidos e exclusão de Leads convertidos do resultado. |
| `LeadBusinessHandlerTest` | Preenchimento condicional da Description e preservação de descrições existentes. |
| `LeadFollowUpBatchTest` | Atualização de Leads elegíveis, preservação de descrições e ausência de registros elegíveis. |
| `LeadFollowUpQueueableTest` | Processamento assíncrono, atualização condicional e ausência de registros elegíveis. |
| `LeadValidationServiceTest` | Lead nulo, sobrenome obrigatório, empresa obrigatória e Lead válido. |
| `LeadManagementControllerTest` | Contagem de Leads por status e exclusão de Leads convertidos do resumo. |

Os testes utilizam recursos como:

- `@IsTest`.
- `@TestSetup`.
- `Test.startTest()`.
- `Test.stopTest()`.
- `System.assertEquals()`.
- `System.assertNotEquals()`.
- Verificação de exceções esperadas.
- Dados de teste isolados.

### Resultados registrados durante o desenvolvimento

As seguintes execuções foram validadas:

| Classe de teste | Resultado registrado |
|---|---|
| `LeadApexServiceTest` | 7 métodos de teste aprovados; execução do CLI contabilizou 8 execuções incluindo `@TestSetup`. |
| `LeadManagementControllerTest` | Teste aprovado; execução do CLI contabilizou 2 execuções incluindo `@TestSetup`. |
| `LeadBusinessHandlerTest` | 4 testes aprovados. |
| `LeadFollowUpBatchTest` | 3 testes aprovados. |
| `LeadFollowUpQueueableTest` | 3 testes aprovados. |
| `LeadValidationServiceTest` | 4 testes aprovados. |

Foi executada uma regressão consolidada de 22 testes, com 100% de aprovação, antes das últimas alterações de segurança. Posteriormente, os testes de `LeadApexServiceTest` e `LeadManagementControllerTest` foram executados novamente após a inclusão das verificações CRUD/FLS, também com 100% de aprovação.

Esses resultados correspondem às execuções registradas durante o desenvolvimento; eles não representam uma nova execução global de todos os testes neste momento.

### Testes Jest

O projeto também possui configuração para testes Jest em Lightning Web Components.

A configuração utiliza `@salesforce/sfdx-lwc-jest`, com mocks dos adapters necessários para testar o componente.

Os cenários cobertos incluem:

- Carregamento de dados.
- Resumo por status.
- Busca.
- Filtro de status.
- Paginação.
- Atualização de dados.

Uma execução anterior registrou uma suíte aprovada com 9 testes aprovados.

---

## 🧩 Lightning Web Components

O projeto contém o componente `leadManagement`, responsável por disponibilizar uma interface customizada para gerenciamento de Leads.

### Funcionalidades

- Consulta e exibição de Leads.
- Busca por nome ou empresa.
- Filtro por status.
- Paginação.
- Contador de registros da página.
- Atualização dos dados.
- Indicadores de quantidade de Leads por status.
- Exibição de spinner durante carregamentos.
- Tratamento e apresentação de mensagens de erro.
- Links para abrir os registros de Lead.

### Integração com Salesforce

O componente utiliza `getListRecordsByName` de `lightning/uiListsApi` para consultar os registros da List View `AllOpenLeads`.

A consulta utiliza os campos necessários para a exibição dos Leads, incluindo:

- Nome.
- Empresa.
- Status.
- Origem.
- Curso de interesse.
- Modalidade.
- Data de início.

O resumo de Leads por status é obtido pelo método `getLeadCountByStatus()` da classe `LeadManagementController`.

O componente também utiliza `refreshApex` para atualizar os dados exibidos.

### LeadManagementController

Classe Apex responsável por fornecer o resumo agregado de Leads não convertidos, agrupados por status.

A classe utiliza:

- `with sharing`.
- `@AuraEnabled(cacheable=true)`.
- SOQL com `GROUP BY`.
- Verificações de acesso ao objeto Lead.
- Verificações de acesso aos campos Status e IsConverted.

O método retorna um mapa de status e quantidade, utilizado pelos indicadores do LWC.

---

## 🎨 Identidade visual — Avance Educação Profissional

O componente `leadManagement` recebeu uma identidade visual personalizada para a Avance Educação Profissional, priorizando uma aparência corporativa em tons de marsala, rosa suave e dourado.

### Logotipo

O logotipo utilizado no cabeçalho está armazenado como Static Resource do Salesforce:

- Nome: `avanceLogo`
- Arquivo: `force-app/main/default/staticresources/avanceLogo.png`
- Metadata: `force-app/main/default/staticresources/avanceLogo.resource-meta.xml`

O LWC importa o recurso estático no JavaScript e utiliza a URL disponibilizada para exibir a imagem no HTML.

### Cabeçalho personalizado

O cabeçalho apresenta:

- Logotipo da Avance à esquerda.
- Título `Sales Lead Management`.
- Subtítulo `Gestão comercial de Leads`.
- Fundo marsala.
- Divisória dourada.
- Texto branco.
- Layout adaptável a telas menores.

### Paleta de cores

| Elemento | Cor | Código hexadecimal |
|---|---|---|
| Cabeçalho e destaques | Marsala | `#702D3A` |
| Detalhes e divisórias | Dourado | `#C5A46D` |
| Fundo do painel | Off-white rosado | `#FBF8F5` |
| Cards de resumo | Rosa suave | `#F7ECEE` |
| Bordas dos cards | Rosa acinzentado | `#E3C9D0` |
| Textos dos indicadores | Marsala escuro | `#5A3B41` |

### Componentes visuais

A personalização inclui:

- Cards de resumo por status.
- Destaque visual dos valores numéricos.
- Fundo suave do painel.
- Cabeçalho marsala para a seção `Lista de Leads`.
- Contador dinâmico de registros da página.
- Bordas arredondadas e sombras suaves.
- Ajustes responsivos do cabeçalho.

A tabela continua utilizando `lightning-datatable`, preservando os recursos fornecidos pelo componente padrão do Salesforce.

A personalização visual foi implementada no HTML e CSS do LWC, mantendo a lógica de busca, filtro, contagem, atualização e paginação.

---

## 🔄 Automações declarativas

O projeto utiliza Salesforce Flow para automatizar atividades do processo comercial.

### Flows implementados

- `Cadastro Inteligente de Lead`
- `Lead_Qualified_Follow_up_Task`
- `Opportunity_Closed_Won_Enrollment_Task`

Essas automações permitem:

- Cadastro guiado de Leads.
- Validação de informações cadastrais.
- Criação automática de tarefas de follow-up.
- Acompanhamento de Leads qualificados.
- Criação de tarefas após Opportunities Closed Won.

O projeto combina Flow com Apex quando há necessidade de validação ou lógica customizada que não deve ficar duplicada em múltiplos elementos declarativos.

---

## 🔐 Segurança e qualidade

O projeto considera boas práticas de segurança e qualidade no desenvolvimento Salesforce.

Entre as medidas implementadas estão:

- Uso de classes `with sharing`.
- Verificações de acesso ao objeto Lead.
- Verificações de leitura e atualização de campos nas operações protegidas.
- Verificações de criação de registros e campos utilizados na criação de Leads.
- Validações de dados antes de operações de DML.
- Exceções personalizadas para condições inválidas.
- Separação entre Trigger e Handler.
- Configuração externa das regras de automação por Custom Metadata Types.
- Testes automatizados para cenários positivos, negativos e de borda.
- Uso de Named Credential para configuração de integração externa.
- Versionamento do código com Git.

As verificações de segurança são aplicadas nos pontos em que foram implementadas e não substituem uma revisão completa de todos os perfis, Permission Sets, sharing rules e permissões da organização.

---

## 📊 Logging e observabilidade

As automações assíncronas utilizam logs com níveis de severidade e informações sobre a execução.

### Batch Apex

O `LeadFollowUpBatch` registra:

- Aviso quando a configuração não é encontrada ou está inativa.
- Quantidade de Leads recebidos pelo processamento.
- Quantidade de Leads atualizados.
- Finalização do processamento.

### Queueable Apex

O `LeadFollowUpQueueable` registra:

- Aviso quando a configuração não é encontrada ou está inativa.
- Quantidade de Leads encontrados.
- Quantidade de Leads atualizados.
- Finalização do processamento.

Os logs utilizam `LoggingLevel.WARN` para condições de atenção e `LoggingLevel.INFO` para informações do processamento.

---

## 🛠️ Tecnologias utilizadas

- Salesforce Sales Cloud.
- Salesforce Flow.
- Apex.
- SOQL.
- Lightning Web Components.
- Aura Components.
- Lightning Data Service / UI API.
- `lightning/uiListsApi`.
- Jest.
- Custom Metadata Types.
- Named Credentials.
- Salesforce CLI.
- Salesforce DX.
- Git.
- GitHub.
- API externa de validação de CPF e CNPJ.
- HTML e CSS para personalização do LWC.

---

## 📁 Estrutura principal do projeto

```text
force-app/
└── main/
    └── default/
        ├── classes/
        │   ├── CpfCnpjValidator.cls
        │   ├── LeadManagementController.cls
        │   ├── LeadApexService.cls
        │   ├── LeadBusinessHandler.cls
        │   ├── LeadFollowUpBatch.cls
        │   ├── LeadFollowUpQueueable.cls
        │   ├── LeadValidationException.cls
        │   ├── LeadValidationService.cls
        │   └── classes de teste
        │
        ├── triggers/
        │   └── LeadBusinessTrigger.trigger
        │
        ├── lwc/
        │   └── leadManagement/
        │       ├── __tests__/
        │       ├── leadManagement.html
        │       ├── leadManagement.js
        │       ├── leadManagement.css
        │       └── leadManagement.js-meta.xml
        │
        ├── aura/
        │   └── LeadNewOverride/
        │
        ├── flows/
        │   ├── Cadastro Inteligente de Lead
        │   ├── Lead_Qualified_Follow_up_Task
        │   └── Opportunity_Closed_Won_Enrollment_Task
        │
        ├── customMetadata/
        │   ├── Lead_Automation_Configuration.Qualified_Lead
        │   ├── Lead_Automation_Configuration.Batch_Follow_Up
        │   └── Lead_Automation_Configuration.Queueable_Follow_Up
        │
        ├── objects/
        │   ├── Lead/
        │   └── Opportunity/
        │
        └── staticresources/
            ├── avanceLogo.png
            └── avanceLogo.resource-meta.xml
```

A estrutura acima destaca os principais componentes do projeto. Outros metadados Salesforce, classes de teste e arquivos de configuração permanecem no repositório conforme a implementação.

---

## 🚀 Desenvolvimento e execução

O projeto utiliza Salesforce DX e Salesforce CLI para deploy e recuperação de metadata, execução de testes e integração com a organização Salesforce.

### Organização Salesforce

Alias utilizado durante o desenvolvimento:

```text
AvanceEducacao
```

### Executar testes Apex

Executar os testes de `LeadApexService`:

```powershell
sf apex run test --tests LeadApexServiceTest --target-org AvanceEducacao --result-format human --wait 10
```

Executar os testes do serviço de validação:

```powershell
sf apex run test --tests LeadValidationServiceTest --target-org AvanceEducacao --result-format human --wait 10
```

Executar os testes da automação Batch:

```powershell
sf apex run test --tests LeadFollowUpBatchTest --target-org AvanceEducacao --result-format human --wait 10
```

Executar os testes da automação Queueable:

```powershell
sf apex run test --tests LeadFollowUpQueueableTest --target-org AvanceEducacao --result-format human --wait 10
```

### Executar deploy do componente LWC

```powershell
sf project deploy start --source-dir force-app/main/default/lwc/leadManagement --target-org AvanceEducacao --wait 10
```

### Recuperar a logo do Salesforce

```powershell
sf project retrieve start --metadata StaticResource:avanceLogo --target-org AvanceEducacao --wait 10
```

### Verificar o estado do Git

```powershell
git status
```

### Publicar alterações no GitHub

```powershell
git add .
git commit -m "mensagem do commit"
git push origin main
```

O comando `git add .` deve ser utilizado com atenção, após verificar se os arquivos que serão incluídos pertencem à alteração desejada.

---

## 🌱 Versionamento

O projeto utiliza Git para controle de versão e GitHub para hospedagem do código-fonte.

O desenvolvimento é realizado de forma incremental, com commits específicos para novas funcionalidades, testes, segurança, documentação e melhorias visuais.

### Repositório

[Sales Lead Management — Avance no GitHub](https://github.com/nicolemartinsmaahs-cpu/sales-lead-management-avance)

### Commits recentes

| Commit | Descrição |
|---|---|
| `94de6e9` | `chore: improve Apex automation logging` |
| `a76caf7` | `security: enforce CRUD and FLS checks in lead services` |
| `223ed13` | `feat: add Avance marsala branding to lead management` |

O commit `223ed13` inclui as alterações de HTML, JavaScript e CSS do LWC, além do logotipo como Static Resource.

O commit `a76caf7` registra as verificações de segurança adicionadas às classes Apex.

O commit `94de6e9` registra as melhorias de logging das automações assíncronas.

O histórico do GitHub mantém essas melhorias separadas em commits específicos.

---

## 📌 Próximas melhorias

Possíveis evoluções do projeto:

- Concluir a revisão técnica final de segurança e qualidade.
- Revisar Permission Sets, permissões de objetos, acesso a campos e sharing.
- Consolidar uma execução de regressão global após as últimas alterações.
- Validar a cobertura dos cenários negativos de segurança.
- Revisar testes Jest após as mudanças visuais do LWC.
- Atualizar capturas de tela e documentação do portfólio.
- Refinar a experiência visual e a responsividade da interface.
- Revisar a documentação da integração externa.
- Expandir a observabilidade das automações conforme a necessidade.
- Preparar a apresentação técnica do projeto para entrevistas.

Essas melhorias representam possibilidades futuras; não devem ser interpretadas como funcionalidades já implementadas.

---

## 🎓 Objetivo do projeto de portfólio

Este projeto foi desenvolvido para demonstrar conhecimentos práticos em diferentes áreas do ecossistema Salesforce, combinando:

**Administração + Automação + Desenvolvimento + Integração + Segurança + Testes + Versionamento**

A proposta é representar um projeto próximo de um cenário empresarial, utilizando recursos nativos do Salesforce sempre que possível e desenvolvimento customizado quando necessário.

O projeto também busca demonstrar organização de código, documentação, testes automatizados, configuração de integrações, uso de Custom Metadata Types e preocupação com segurança e manutenção.

---

## 👩‍💻 Autora

**Nicole Martins Maahs**

Projeto desenvolvido como parte da transição de carreira para a área de Salesforce Development, com foco em Apex, Lightning Web Components, automação declarativa, integração e qualidade de software.
