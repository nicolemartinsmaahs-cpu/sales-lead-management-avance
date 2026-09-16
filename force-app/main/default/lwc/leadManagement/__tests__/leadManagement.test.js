import { createElement } from '@lwc/engine-dom';
import { refreshApex } from '@salesforce/apex';

jest.mock(
    'lightning/uiListsApi',
    () => {
        const {
            createLdsTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');

        return {
            getListRecordsByName: createLdsTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex/LeadManagementController.getLeadCountByStatus',
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');

        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

jest.mock(
    '@salesforce/apex',
    () => ({
        refreshApex: jest.fn()
    }),
    { virtual: true }
);

import { getListRecordsByName } from 'lightning/uiListsApi';
import getLeadCountByStatus from '@salesforce/apex/LeadManagementController.getLeadCountByStatus';

import LeadManagement from 'c/leadManagement';

describe('c-lead-management', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }

        jest.clearAllMocks();
    });

    const mockLeads = {
        records: [
            {
                id: '00Q000000000001AAA',
                fields: {
                    Name: {
                        value: 'Mariana Silva'
                    },
                    Company: {
                        value: 'Avance Educação Profissional'
                    },
                    Status: {
                        value: 'Working - Contacted'
                    },
                    LeadSource: {
                        value: 'WhatsApp'
                    },
                    Course_of_Interest__c: {
                        value: 'Salesforce'
                    },
                    Learning_Modality__c: {
                        value: 'Online'
                    },
                    Start_Date__c: {
                        value: '2026-10-01'
                    }
                }
            },
            {
                id: '00Q000000000002AAA',
                fields: {
                    Name: {
                        value: 'João Oliveira'
                    },
                    Company: {
                        value: 'Avance Educação Profissional'
                    },
                    Status: {
                        value: 'Working - Contacted'
                    },
                    LeadSource: {
                        value: 'Email'
                    },
                    Course_of_Interest__c: {
                        value: 'Python'
                    },
                    Learning_Modality__c: {
                        value: 'Online'
                    },
                    Start_Date__c: {
                        value: '2026-11-01'
                    }
                }
            }
        ],

        nextPageToken: 10,
        previousPageToken: null
    };

    const mockLeadSummary = {
        'Open - Not Contacted': 3,
        'Working - Contacted': 12,
        'Qualified': 1
    };

    it('carrega os Leads recebidos pela wire', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const datatable =
            element.shadowRoot.querySelector('lightning-datatable');

        expect(datatable).not.toBeNull();
        expect(datatable.data).toHaveLength(2);
        expect(datatable.data[0].Name).toBe('Mariana Silva');
        expect(datatable.data[1].Name).toBe('João Oliveira');
    });

    it('exibe a quantidade de Leads da página atual', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const count =
            element.shadowRoot.querySelector(
                '.slds-text-body_regular'
            );

        expect(count.textContent).toContain(
            '2 Leads nesta página'
        );
    });

    it('exibe o resumo de Leads retornado pelo Apex', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getLeadCountByStatus.emit(mockLeadSummary);

        await Promise.resolve();

        const pageText =
            element.shadowRoot.textContent;

        expect(pageText).toContain('Open - Not Contacted');
        expect(pageText).toContain('Working - Contacted');
        expect(pageText).toContain('Qualified');

        expect(pageText).toContain('3');
        expect(pageText).toContain('12');
        expect(pageText).toContain('1');
    });

    it('reinicia a paginação quando o usuário faz uma busca', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const nextButton = buttons[2];

        nextButton.click();

        await Promise.resolve();

        const searchInput =
            element.shadowRoot.querySelector('lightning-input');

        searchInput.value = 'Mar';

        searchInput.dispatchEvent(
            new CustomEvent('change')
        );

        await Promise.resolve();

        expect(element.shadowRoot.textContent)
            .toContain('Página 1');
    });

    it('aceita busca com pelo menos dois caracteres', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        const searchInput =
            element.shadowRoot.querySelector('lightning-input');

        searchInput.value = 'Mar';

        searchInput.dispatchEvent(
            new CustomEvent('change')
        );

        await Promise.resolve();

        expect(searchInput.value).toBe('mar');
    });

    it('reinicia a paginação quando o Status é alterado', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const nextButton = buttons[2];

        nextButton.click();

        await Promise.resolve();

        const statusCombobox =
            element.shadowRoot.querySelector(
                'lightning-combobox'
            );

        statusCombobox.value = 'Qualified';

        statusCombobox.dispatchEvent(
            new CustomEvent('change', {
                detail: {
                    value: 'Qualified'
                }
            })
        );

        await Promise.resolve();

        expect(element.shadowRoot.textContent)
            .toContain('Página 1');
    });

    it('avança para a próxima página quando o botão é clicado', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const nextButton = buttons[2];

        nextButton.click();

        await Promise.resolve();

        expect(element.shadowRoot.textContent)
            .toContain('Página 2');
    });

    it('permanece na primeira página ao tentar voltar sem página anterior', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const previousButton = buttons[1];

        previousButton.click();

        await Promise.resolve();

        expect(element.shadowRoot.textContent)
            .toContain('Página 1');
    });

    it('permite voltar para a página anterior', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit({
            ...mockLeads,
            nextPageToken: 20,
            previousPageToken: 0
        });

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const previousButton = buttons[1];

        previousButton.click();

        await Promise.resolve();

        expect(element.shadowRoot.textContent)
            .toContain('Página 1');
    });

    it('atualiza os dados ao clicar no botão Atualizar', async () => {
        const element = createElement('c-lead-management', {
            is: LeadManagement
        });

        document.body.appendChild(element);

        getListRecordsByName.emit(mockLeads);
        getLeadCountByStatus.emit(mockLeadSummary);

        await Promise.resolve();

        const buttons =
            element.shadowRoot.querySelectorAll('lightning-button');

        const refreshButton = buttons[0];

        refreshButton.click();

        await Promise.resolve();

        expect(refreshApex).toHaveBeenCalledTimes(2);
    });
});