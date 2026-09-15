# Sales Lead Management — Avance Educação Profissional

Projeto de portfólio desenvolvido em Salesforce para gerenciamento do processo comercial da **Avance Educação Profissional**, desde a entrada e qualificação de Leads até a conversão e acompanhamento do pipeline comercial.

O projeto foi desenvolvido com foco em demonstrar conhecimentos práticos de **Salesforce Development, configuração declarativa, automação, integração com API externa, Apex, Lightning Web Components, testes e versionamento com Git/GitHub**.

---

## 📌 Visão geral

A solução representa um processo comercial para captação e acompanhamento de potenciais alunos:

**Lead → Qualificação → Conversão → Account + Contact + Opportunity → Pipeline → Closed Won / Closed Lost**

O projeto utiliza uma abordagem **native-first**, priorizando recursos nativos e declarativos do Salesforce antes de recorrer ao desenvolvimento customizado.

---

## 🎯 Objetivos

O projeto tem como objetivos:

- Modelar um processo comercial no Salesforce;
- Gerenciar Leads e seu ciclo de qualificação;
- Validar documentos de identificação antes da criação do Lead;
- Automatizar atividades de follow-up;
- Demonstrar Lead Conversion;
- Gerenciar o pipeline de Opportunities;
- Demonstrar desenvolvimento com Apex e Lightning Web Components;
- Implementar testes automatizados;
- Aplicar boas práticas de segurança;
- Utilizar Salesforce DX e Git/GitHub para versionamento.

---

## 🏗️ Arquitetura da solução

A arquitetura segue a seguinte prioridade:

**Salesforce Native → Configuração Declarativa → Flow → LWC/Aura → Apex quando necessário**

Essa abordagem busca reduzir código customizado quando o recurso nativo ou declarativo atende ao requisito.

```text
                         Salesforce
                              │
                         Sales Cloud
                              │
                    ┌─────────┴─────────┐
                    │                   │
                  Leads            Opportunities
                    │                   │
                    │              Sales Pipeline
                    │                   │
                    ▼                   ▼
          Cadastro Inteligente    Closed Won / Lost
                    │                   │
              Screen Flow        Enrollment Task
                    │
          ┌─────────┴─────────┐
          │                   │
   Pessoa Física       Pessoa Jurídica
          │                   │
       CPF API             CNPJ API
          │                   │
          └─────────┬─────────┘
                    │
              ValidaSeguro
                    │
             Documento válido?
                /          \
              Não            Sim
               │              │
          Encerrar        Criar Lead
                              │
                              ▼
                       Tela de sucesso