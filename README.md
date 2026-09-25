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
                  ┌────────────┴────────────┐
                  │                         │
                Leads                 Opportunities
                  │                         │
                  │                    Sales Pipeline
                  │                         │
                  ▼                         ▼
        Cadastro Inteligente         Closed Won / Lost
                  │                         │
             Screen Flow             Enrollment Task
                  │
          ┌───────┴────────┐
          │                │
   Pessoa Física     Pessoa Jurídica
          │                │
        CPF              CNPJ
          │                │
          └───────┬────────┘
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


---

## ⚙️ Desenvolvimento Apex

O projeto também contempla implementações práticas utilizando Apex para apoiar o processo de acompanhamento comercial.

### LeadApexService

Classe responsável por operações básicas relacionadas a Leads:

- Buscar Leads não convertidos;
- Criar Leads de teste;
- Atualizar o Status de um Lead.

Principais conceitos demonstrados:

- SOQL;
- DML;
- Métodos estáticos;
- Manipulação de registros Salesforce.

### LeadBusinessTrigger e LeadBusinessHandler

Trigger executada nos eventos `before insert` e `before update` de Leads.

Quando um Lead possui o Status `Qualified` e não possui descrição, o Handler preenche automaticamente o campo Description com uma mensagem de acompanhamento.

A implementação utiliza o padrão de separação entre Trigger e Handler, facilitando:

- Organização do código;
- Manutenção;
- Reutilização;
- Testabilidade.

### LeadFollowUpBatch

Classe Batch Apex responsável por localizar Leads com o Status `Working - Contacted` e Description vazia.

Esses Leads recebem automaticamente a seguinte descrição:

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

## 🧪 Testes automatizados

O projeto contém classes de teste Apex para validar o comportamento das implementações customizadas.

### Cobertura de testes

| Classe | Cenários validados |
|---|---|
| LeadApexServiceTest | Busca, criação e atualização de Leads |
| LeadBusinessHandlerTest | Preenchimento condicional da Description |
| LeadFollowUpBatchTest | Atualização de Leads elegíveis e preservação de descrições existentes |
| LeadFollowUpQueueableTest | Processamento assíncrono e preservação de descrições existentes |

Os testes utilizam recursos como:

- `@IsTest`;
- `Test.startTest()`;
- `Test.stopTest()`;
- `System.assertEquals()`;
- `System.assertNotEquals()`.

### Resultado dos testes

A classe `LeadFollowUpQueueableTest` foi executada com:

- 2 testes executados;
- 2 testes aprovados;
- Taxa de sucesso de 100%;
- 0 falhas.

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

### Tratamento de exceções personalizadas

O projeto também possui uma exceção Apex personalizada para representar erros específicos de validação de Leads:

- `LeadValidationException`
- `LeadValidationService`
- `LeadValidationServiceTest`

O `LeadValidationService` realiza validações em memória antes de qualquer operação de DML:

- Lead nulo
- Sobrenome obrigatório
- Empresa obrigatória

Quando uma regra é violada, o serviço lança `LeadValidationException` com uma mensagem específica para o cenário.

A classe `LeadValidationServiceTest` cobre os cenários de sucesso e de exceção.

Resultado dos testes:

- 4 testes executados
- 4 testes aprovados
- Taxa de sucesso: 100%