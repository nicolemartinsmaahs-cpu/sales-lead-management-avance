import { LightningElement, wire } from 'lwc';
import { getListRecordsByName } from 'lightning/uiListsApi';
import getLeadCountByStatus from '@salesforce/apex/LeadManagementController.getLeadCountByStatus';

export default class LeadManagement extends LightningElement {
    leads = [];
    filteredLeads = [];

    selectedStatus = 'ALL';
    searchTerm = null;

    errorMessage = '';

    // Controle de carregamento da lista
    isLoading = true;

    // Controle de carregamento do resumo
    isLoadingSummary = true;

    pageToken = null;
    nextPageToken = null;
    previousPageToken = null;
    pageNumber = 1;

    // Filtro enviado diretamente para o Salesforce.
    whereFilter = null;

    // Resumo retornado pelo Apex
    leadSummary = {};

    columns = [
        {
            label: 'Nome',
            fieldName: 'recordUrl',
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                },
                target: '_self'
            }
        },
        {
            label: 'Empresa',
            fieldName: 'Company',
            type: 'text'
        },
        {
            label: 'Status',
            fieldName: 'Status',
            type: 'text'
        },
        {
            label: 'Origem',
            fieldName: 'LeadSource',
            type: 'text'
        },
        {
            label: 'Curso',
            fieldName: 'Course_of_Interest__c',
            type: 'text'
        },
        {
            label: 'Modalidade',
            fieldName: 'Learning_Modality__c',
            type: 'text'
        },
        {
            label: 'Início',
            fieldName: 'Start_Date__c',
            type: 'date'
        }
    ];

    statusOptions = [
        { label: 'Todos', value: 'ALL' },
        {
            label: 'Open - Not Contacted',
            value: 'Open - Not Contacted'
        },
        {
            label: 'Working - Contacted',
            value: 'Working - Contacted'
        },
        {
            label: 'Qualified',
            value: 'Qualified'
        },
        {
            label: 'Closed - Converted',
            value: 'Closed - Converted'
        },
        {
            label: 'Closed - Not Converted',
            value: 'Closed - Not Converted'
        }
    ];

    // =========================================================
    // LEADS
    // =========================================================

    @wire(getListRecordsByName, {
        objectApiName: 'Lead',
        listViewApiName: 'AllOpenLeads',

        fields: [
            'Lead.Name',
            'Lead.Company',
            'Lead.Status',
            'Lead.LeadSource',
            'Lead.Course_of_Interest__c',
            'Lead.Learning_Modality__c',
            'Lead.Start_Date__c'
        ],

        pageSize: 10,
        pageToken: '$pageToken',
        searchTerm: '$searchTerm',
        where: '$whereFilter'
    })
    wiredLeads({ error, data }) {
        if (data) {
            this.errorMessage = '';

            const records = data.records || [];

            this.nextPageToken = data.nextPageToken || null;
            this.previousPageToken =
                data.previousPageToken || null;

            this.leads = records.map(record => ({
                Id: record.id,

                Name:
                    record.fields?.Name?.value || '',

                Company:
                    record.fields?.Company?.value || '',

                Status:
                    record.fields?.Status?.value || '',

                LeadSource:
                    record.fields?.LeadSource?.value || '',

                Course_of_Interest__c:
                    record.fields?.Course_of_Interest__c?.value || '',

                Learning_Modality__c:
                    record.fields?.Learning_Modality__c?.value || '',

                Start_Date__c:
                    record.fields?.Start_Date__c?.value || '',

                recordUrl:
                    `/lightning/r/Lead/${record.id}/view`
            }));

            this.filteredLeads = this.leads;

            this.isLoading = false;

        } else if (error) {
            this.leads = [];
            this.filteredLeads = [];
            this.errorMessage =
                this.getErrorMessage(error);

            this.isLoading = false;
        }
    }

    // =========================================================
    // RESUMO VIA APEX
    // =========================================================

    @wire(getLeadCountByStatus)
    wiredLeadSummary({ error, data }) {
        if (data) {
            this.leadSummary = data;
            this.isLoadingSummary = false;

        } else if (error) {
            this.leadSummary = {};
            this.isLoadingSummary = false;

            this.errorMessage =
                this.getErrorMessage(error);
        }
    }

    // =========================================================
    // CONTADORES DO RESUMO
    // =========================================================

    get openLeadCount() {
        return this.leadSummary['Open - Not Contacted'] || 0;
    }

    get workingLeadCount() {
        return this.leadSummary['Working - Contacted'] || 0;
    }

    get qualifiedLeadCount() {
        return this.leadSummary['Qualified'] || 0;
    }

    // =========================================================
    // ERROS
    // =========================================================

    getErrorMessage(error) {
        if (Array.isArray(error?.body)) {
            return error.body
                .map(item => item.message)
                .join(' | ');
        }

        if (error?.body?.message) {
            return error.body.message;
        }

        if (error?.message) {
            return error.message;
        }

        return 'Não foi possível carregar os Leads.';
    }

    // =========================================================
    // BUSCA
    // =========================================================

    handleSearch(event) {
        const value =
            event.target.value.trim().toLowerCase();

        // A API exige pelo menos 2 caracteres.
        this.searchTerm =
            value.length >= 2 ? value : null;

        // Nova busca sempre começa na primeira página.
        this.pageToken = null;
        this.pageNumber = 1;

        this.isLoading = true;
    }

    // =========================================================
    // FILTRO DE STATUS
    // =========================================================

    handleStatusChange(event) {
        this.selectedStatus =
            event.detail.value;

        // Volta para a primeira página.
        this.pageToken = null;
        this.pageNumber = 1;

        if (this.selectedStatus === 'ALL') {
            this.whereFilter = null;
        } else {
            this.whereFilter =
                `{ Status: { eq: "${this.selectedStatus}" } }`;
        }

        this.isLoading = true;
    }

    // =========================================================
    // PAGINAÇÃO
    // =========================================================

    handleNextPage() {
        if (this.nextPageToken !== null) {
            this.pageToken = this.nextPageToken;
            this.pageNumber += 1;
            this.isLoading = true;
        }
    }

    handlePreviousPage() {
        if (this.previousPageToken !== null) {
            this.pageToken =
                this.previousPageToken;

            this.pageNumber -= 1;
            this.isLoading = true;
        }
    }

    get isPreviousDisabled() {
        return this.previousPageToken === null;
    }

    get isNextDisabled() {
        return this.nextPageToken === null;
    }

    // =========================================================
    // CONTADOR DA PÁGINA
    // =========================================================

    get recordCountLabel() {
        const count =
            this.filteredLeads.length;

        if (count === 1) {
            return '1 Lead nesta página';
        }

        return `${count} Leads nesta página`;
    }

    // =========================================================
    // ATUALIZAR
    // =========================================================

    handleRefresh() {
        window.location.reload();
    }
}