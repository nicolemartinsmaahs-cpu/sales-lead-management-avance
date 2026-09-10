# Sales Lead Management — Avance Educação Profissional

Projeto de portfólio desenvolvido em Salesforce para gerenciamento do processo comercial da **Avance Educação Profissional**, desde a entrada e qualificação de Leads até a conversão em Account, Contact e Opportunity.

O projeto foi desenvolvido com foco em demonstrar conhecimentos práticos de **Salesforce Development, configuração declarativa, automação, Apex, Lightning Web Components, testes e versionamento com Git/GitHub**.

---

## 📌 Visão geral

O sistema representa um processo comercial baseado no fluxo:

**Lead → Qualificação → Conversão → Account + Contact + Opportunity → Pipeline → Closed Won / Closed Lost**

A solução combina recursos nativos do Salesforce com automações em Flow, desenvolvimento em Apex e uma interface personalizada em Lightning Web Components.

---

## 🎯 Objetivo do projeto

Criar uma solução simples e funcional para apoiar o processo de captação e acompanhamento de potenciais alunos.

O projeto foi desenvolvido como uma aplicação de portfólio para demonstrar:

- Configuração de objetos Salesforce
- Custom Fields
- Picklists e Standard Value Sets
- Lead Management
- Lead Conversion
- Opportunity Pipeline
- Record-Triggered Flows
- Apex
- Apex Testing
- Lightning Web Components
- Jest
- Salesforce DX
- Git e GitHub

---

## 🏗️ Arquitetura

```text
                         ┌─────────────────────┐
                         │        LEAD         │
                         │                     │
                         │ Course of Interest  │
                         │ Learning Modality   │
                         │ Start Date          │
                         │ Lead Source         │
                         │ Status              │
                         └──────────┬──────────┘
                                    │
                              Qualification
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   LEAD CONVERSION   │
                         └──────────┬──────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
              ┌──────────┐   ┌──────────┐   ┌─────────────┐
              │ Account  │   │ Contact  │   │ Opportunity │
              └──────────┘   └──────────┘   └──────┬──────┘
                                                    │
                                                    ▼
                                             Sales Pipeline
                                                    │
                                      ┌─────────────┴─────────────┐
                                      ▼                           ▼
                                Closed Won                  Closed Lost
                                      │
                                      ▼
                              Enrollment Task