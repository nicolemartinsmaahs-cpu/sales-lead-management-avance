# Sales Lead Management — Avance Educação Profissional

Projeto de portfólio desenvolvido em Salesforce para gerenciamento do processo comercial da **Avance Educação Profissional**, desde a entrada e qualificação de Leads até a conversão e acompanhamento do pipeline comercial.

O projeto demonstra conhecimentos práticos em **Salesforce Development, configuração declarativa, automação, integração com API externa, Apex, Lightning Web Components, testes automatizados e versionamento com Git/GitHub**.

---

## 📌 Visão geral

A solução representa um processo comercial para captação e acompanhamento de potenciais alunos:

**Lead → Qualificação → Conversão → Account + Contact + Opportunity → Pipeline → Closed Won / Closed Lost**

A implementação segue uma abordagem **native-first**, priorizando recursos nativos e declarativos do Salesforce antes de utilizar desenvolvimento customizado.

---

## 🎯 Objetivos

- Modelar um processo comercial no Salesforce;
- Gerenciar o ciclo de vida dos Leads;
- Validar CPF e CNPJ antes da criação do Lead;
- Integrar o Salesforce com uma API externa de validação;
- Automatizar tarefas de follow-up;
- Demonstrar Lead Conversion;
- Gerenciar o pipeline de Opportunities;
- Desenvolver uma interface customizada com Lightning Web Components;
- Implementar Apex com testes automatizados;
- Aplicar boas práticas de segurança;
- Utilizar Salesforce DX e Git/GitHub para versionamento.

---

## 🏗️ Arquitetura da solução

A arquitetura segue a seguinte prioridade:

**Salesforce Native → Configuração Declarativa → Flow → LWC/Aura → Apex quando necessário**

```text
                           Salesforce
                               │
                          Sales Cloud
                               │
                  ┌────────────┴─────────────┐
                  │                          │
                Leads                 Opportunities
                  │                          │
                  │                    Sales Pipeline
                  │                          │
                  ▼                          ▼
        Cadastro Inteligente         Closed Won / Lost
                  │                          │
             Screen Flow             Enrollment Task
                  │
          ┌───────┴──────────┐
          │                  │
   Pessoa Física     Pessoa Jurídica
          │                  │
        CPF                CNPJ
          │                  │
          └────────┬─────────┘
                   │
              CPF.CNPJ API
                   │
          Documento válido?
             /          \
           Não           Sim
            │             │
        Encerrar      Criar Lead
                          │
                          ▼
                   Tela de sucesso
```

---

## ⚙️ Desenvolvimento Apex

O projeto também contempla implementações práticas utilizando Apex para apoiar o processo de acompanhamento comercial.

### LeadApexService

Classe responsável por operações relacionadas a Leads:

- Buscar Leads não convertidos;
- Criar Leads de teste;
- Atualizar o Status de um Lead;
- Validar situações de erro durante a atualização.

Principais conceitos demonstrados:

- SOQL;
- DML;
- Métodos estáticos;
- Manipulação de registros Salesforce;
- Tratamento de exceções;
- Validação de cenários de borda.

### LeadBusinessTrigger e LeadBusinessHandler

Trigger executada nos eventos `before insert` e `before update` de Leads.

Quando um Lead possui o Status `Qualified` e não possui descrição, o Handler preenche automaticamente o campo `Description` com uma mensagem de acompanhamento.

A implementação utiliza o padrão de separação entre Trigger e Handler, facilitando:

- Organização do código;
- Manutenção;
- Reutilização;
- Testabilidade.

### LeadFollowUpBatch

Classe Batch Apex responsável por localizar Leads com o Status `Working - Contacted`.

Durante o processamento, os registros são avaliados e aqueles que possuem `Description` vazia recebem automaticamente a seguinte descrição:

> Acompanhamento comercial pendente via Batch Apex.

A implementação demonstra:

- `Database.Batchable<SObject>`;
- `Database.QueryLocator`;
- Processamento em lotes;
- Atualização de registros;
- Execução assíncrona.

### LeadFollowUpQueueable

Classe Queueable Apex responsável por realizar o acompanhamento assíncrono de Leads.

A classe:

1. Consulta Leads não convertidos;
2. Filtra Leads com Status `Working - Contacted`;
3. Identifica registros sem descrição;
4. Preenche a descrição automaticamente;
5. Atualiza os registros elegíveis.

Mensagem utilizada:

> Acompanhamento comercial via Queueable Apex.

A implementação demonstra:

- Interface `Queueable`;
- Método `execute`;
- `System.enqueueJob()`;
- Processamento assíncrono;
- Atualização condicional de registros.

---

## 🧩 Tratamento de exceções personalizadas

O projeto possui uma exceção Apex personalizada para representar erros específicos relacionados à validação de Leads:

### LeadValidationException

Exceção customizada utilizada para representar situações de validação do domínio de Leads.

### LeadValidationService

Serviço responsável por realizar validações em memória antes de qualquer operação de DML.

As regras implementadas incluem:

- Lead nulo;
- Sobrenome obrigatório;
- Empresa obrigatória.

Quando uma regra é violada, o serviço lança `LeadValidationException` com uma mensagem específica para o cenário.

### Tratamento no LeadApexService

O `LeadApexService` também utiliza `LeadValidationException` para tratar situações relacionadas à atualização de Leads:

- ID do Lead não informado;
- Lead não encontrado.

Essa abordagem torna o comportamento dos métodos mais explícito e permite que o código consumidor diferencie erros de validação de outras exceções genéricas.

---

## 🧪 Testes automatizados

O projeto contém classes de teste Apex para validar o comportamento das implementações customizadas.

### Cobertura de testes

| Classe | Cenários validados |
|---|---|
| `LeadApexServiceTest` | Busca, criação, atualização, ausência de Leads, Lead convertido, ID nulo e ID inexistente |
| `LeadBusinessHandlerTest` | Preenchimento condicional da `Description` |
| `LeadFollowUpBatchTest` | Atualização de Leads elegíveis e preservação de descrições existentes |
| `LeadFollowUpQueueableTest` | Processamento assíncrono e preservação de descrições existentes |
| `LeadValidationServiceTest` | Lead válido, Lead nulo, ausência de sobrenome e ausência de empresa |

Os testes utilizam recursos como:

- `@IsTest`;
- `@TestSetup`;
- `Test.startTest()`;
- `Test.stopTest()`;
- `System.assert()`;
- `System.assertEquals()`;
- `System.assertNotEquals()`.

### Resultado dos testes

#### LeadValidationServiceTest

Última execução:

- 4 testes executados;
- 4 testes aprovados;
- Taxa de sucesso: 100%;
- 0 falhas.

Testes realizados:

- `deveAceitarLeadValido`;
- `deveRejeitarLeadNulo`;
- `deveRejeitarLeadSemSobrenome`;
- `deveRejeitarLeadSemEmpresa`.

#### LeadApexServiceTest

Última execução:

- 7 métodos de teste executados;
- 7 métodos aprovados;
- Taxa de sucesso: 100%;
- 0 falhas.

Testes realizados:

- `deveBuscarLeadsNaoConvertidos`;
- `deveCriarLead`;
- `deveAtualizarStatusDoLead`;
- `deveRetornarListaVaziaQuandoNaoHouverLeads`;
- `deveFalharAoAtualizarLeadInexistente`;
- `deveFalharAoAtualizarComIdNulo`;
- `deveIgnorarLeadConvertido`.

O `@TestSetup` é executado separadamente durante a execução da classe e, por isso, o Salesforce apresenta um total de testes executados maior no resumo da execução.

#### LeadBusinessHandlerTest

Valida a regra de negócio responsável pelo preenchimento automático da `Description` quando o Lead possui Status `Qualified` e o campo está vazio.

#### LeadFollowUpBatchTest

Valida:

- Processamento de Leads elegíveis;
- Atualização automática da `Description`;
- Preservação da descrição de registros que já possuem informação.

#### LeadFollowUpQueueableTest

Valida:

- Execução assíncrona;
- Identificação de Leads elegíveis;
- Atualização condicional;
- Preservação de descrições existentes.

Resultado registrado anteriormente:

- 2 testes executados;
- 2 testes aprovados;
- Taxa de sucesso: 100%.

---

## 🔍 Testes de cenários de borda

Os testes Apex também cobrem cenários de exceção e limites do serviço de Leads.

No `LeadApexServiceTest` são validados:

- Busca quando não existem Leads não convertidos;
- Garantia de que Leads convertidos não sejam retornados;
- Tratamento de ID nulo ao atualizar um Lead;
- Tratamento de ID inexistente ao atualizar um Lead;
- Atualização correta do Status;
- Criação correta de Lead;
- Consulta de Leads não convertidos.

### Cenário sem Leads

O teste `deveRetornarListaVaziaQuandoNaoHouverLeads` garante que `buscarLeadsNaoConvertidos()` retorne uma lista vazia quando não houver registros elegíveis.

### Lead convertido

O teste `deveIgnorarLeadConvertido` garante que Leads convertidos não sejam retornados pelo método de busca.

### ID inexistente

O teste `deveFalharAoAtualizarLeadInexistente` valida que um ID que não corresponde a um Lead gera uma `LeadValidationException` com mensagem específica.

### ID nulo

O teste `deveFalharAoAtualizarComIdNulo` valida que um ID não informado gera uma `LeadValidationException`.

Essa abordagem demonstra preocupação com:

- Caminhos de sucesso;
- Dados ausentes;
- Registros inexistentes;
- Regras de validação;
- Comportamentos fora do fluxo principal.

---

## 🔄 Automações declarativas

O projeto utiliza Salesforce Flow para automatizar atividades do processo comercial.

### Flows implementados

- Cadastro Inteligente de Lead;
- Lead Qualified Follow-up Task;
- Opportunity Closed Won Enrollment Task.

Essas automações permitem:

- Cadastro guiado de Leads;
- Validação de informações;
- Criação automática de tarefas;
- Acompanhamento de Leads qualificados;
- Criação de tarefas após Opportunities Closed Won.

---

## 🧩 Lightning Web Components

O projeto contém componentes Lightning Web Components para oferecer uma interface customizada de gerenciamento de Leads.

### leadManagement

Funcionalidades demonstradas:

- Exibição de informações de Leads;
- Pesquisa;
- Filtros;
- Paginação;
- Integração com Apex;
- Testes Jest.

O componente utiliza o `LeadManagementController` para consultar informações agregadas sobre Leads não convertidos.

### Testes Jest

O componente `leadManagement` possui testes automatizados utilizando Jest para validar seu comportamento.

Os testes cobrem cenários relacionados à:

- Renderização;
- Pesquisa;
- Filtros;
- Paginação;
- Integração com dados provenientes do Apex.

---

## 🔐 Segurança e qualidade

O projeto considera boas práticas de segurança e qualidade no desenvolvimento Salesforce, incluindo:

- Uso de classes `with sharing`;
- Verificações de acesso a objetos e campos quando aplicável;
- Separação entre Trigger e Handler;
- Validações de dados;
- Automação declarativa antes de código customizado;
- Testes automatizados;
- Versionamento de código com Git.

### Integração externa

A validação de CPF e CNPJ utiliza uma API externa por meio de recursos configurados no Salesforce.

A integração foi estruturada utilizando:

- Named Credential;
- Apex;
- Invocable Method;
- `@AuraEnabled`.

---

## 🛠️ Tecnologias utilizadas

- Salesforce Sales Cloud;
- Salesforce Flow;
- Apex;
- SOQL;
- Lightning Web Components;
- Aura Components;
- Jest;
- Salesforce CLI;
- Salesforce DX;
- Git;
- GitHub;
- Named Credentials;
- API externa de validação de CPF e CNPJ.

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
        │
        ├── aura/
        │   └── LeadNewOverride/
        │
        └── flows/
```

---

## 🚀 Execução e desenvolvimento

O projeto pode ser desenvolvido, validado e implantado utilizando Salesforce CLI e Salesforce DX.

Principais atividades realizadas no projeto:

- Desenvolvimento de Apex;
- Criação de Flows;
- Desenvolvimento de Lightning Web Components;
- Desenvolvimento de Aura Component para override;
- Integração com API externa;
- Criação de testes automatizados;
- Execução de testes Apex;
- Execução de testes Jest;
- Deploy de metadata;
- Versionamento com Git;
- Publicação no GitHub.

### Exemplos de comandos utilizados

Executar testes Apex:

```powershell
sf apex run test --tests LeadApexServiceTest --target-org AvanceEducacao --result-format human --wait 10
```

Executar testes de um serviço específico:

```powershell
sf apex run test --tests LeadValidationServiceTest --target-org AvanceEducacao --result-format human --wait 10
```

Realizar deploy de uma classe:

```powershell
sf project deploy start --source-dir force-app/main/default/classes/LeadApexService.cls --target-org AvanceEducacao
```

Verificar o estado do Git:

```powershell
git status
```

---

## 🌱 Versionamento

O projeto utiliza Git para controle de versão e GitHub para hospedagem do código-fonte.

O desenvolvimento é realizado de forma incremental, com alterações organizadas em commits específicos para cada funcionalidade ou melhoria.

Entre os commits realizados estão:

```text
1b691a9 docs: document Apex automation and project architecture
b90cafe feat: add custom lead validation exceptions
```

---

## 📌 Próximas melhorias

Possíveis evoluções do projeto:

- Implementação de Custom Metadata Types;
- Evolução do tratamento de logs;
- Expansão dos cenários de testes;
- Ampliação das validações de negócio;
- Evolução da interface de gerenciamento de Leads;
- Novas integrações externas;
- Maior cobertura de cenários negativos;
- Evolução da observabilidade das automações assíncronas.

---

## 🎓 Objetivo do projeto de portfólio

Este projeto foi desenvolvido para demonstrar conhecimentos práticos em diferentes áreas do ecossistema Salesforce, combinando:

**Administração + Automação + Desenvolvimento + Integração + Testes + Versionamento**

A proposta é representar um projeto próximo de um cenário empresarial, utilizando recursos nativos do Salesforce sempre que possível e desenvolvimento customizado quando necessário.

---

## 👩‍💻 Autora

**Nicole Martins Maahs**

Projeto desenvolvido como parte da transição de carreira para a área de Salesforce Development, com foco em desenvolvimento Apex, Lightning Web Components, automação e integração.