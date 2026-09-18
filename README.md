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