public with sharing class LeadApexService {

    public static List<Lead> buscarLeadsNaoConvertidos() {

        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new LeadValidationException(
                'Você não possui acesso ao objeto Lead.'
            );
        }

        if (!Schema.sObjectType.Lead.fields.Id.isAccessible()
            || !Schema.sObjectType.Lead.fields.FirstName.isAccessible()
            || !Schema.sObjectType.Lead.fields.LastName.isAccessible()
            || !Schema.sObjectType.Lead.fields.Company.isAccessible()
            || !Schema.sObjectType.Lead.fields.Status.isAccessible()
            || !Schema.sObjectType.Lead.fields.LeadSource.isAccessible()
            || !Schema.sObjectType.Lead.fields.IsConverted.isAccessible()) {
            throw new LeadValidationException(
                'Você não possui acesso a um ou mais campos necessários do Lead.'
            );
        }

        return [
            SELECT Id,
                   FirstName,
                   LastName,
                   Company,
                   Status,
                   LeadSource
            FROM Lead
            WHERE IsConverted = false
            LIMIT 10
        ];
    }

    public static Lead criarLeadDeTeste() {

        if (!Schema.sObjectType.Lead.isCreateable()) {
            throw new LeadValidationException(
                'Você não possui permissão para criar Leads.'
            );
        }

        if (!Schema.sObjectType.Lead.fields.FirstName.isCreateable()
            || !Schema.sObjectType.Lead.fields.LastName.isCreateable()
            || !Schema.sObjectType.Lead.fields.Company.isCreateable()
            || !Schema.sObjectType.Lead.fields.Status.isCreateable()
            || !Schema.sObjectType.Lead.fields.LeadSource.isCreateable()) {
            throw new LeadValidationException(
                'Você não possui permissão para criar um ou mais campos do Lead.'
            );
        }

        Lead novoLead = new Lead(
            FirstName = 'Apex',
            LastName = 'Training',
            Company = 'Avance Educação Profissional',
            Status = 'Open - Not Contacted',
            LeadSource = 'Other'
        );

        insert novoLead;

        return novoLead;
    }

    public static void atualizarStatusLead(
        Id leadId,
        String novoStatus
    ) {

        if (leadId == null) {
            throw new LeadValidationException(
                'O Id do Lead é obrigatório.'
            );
        }

        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new LeadValidationException(
                'Você não possui acesso ao objeto Lead.'
            );
        }

        if (!Schema.sObjectType.Lead.fields.Id.isAccessible()
            || !Schema.sObjectType.Lead.fields.Status.isAccessible()) {
            throw new LeadValidationException(
                'Você não possui acesso aos campos necessários do Lead.'
            );
        }

        if (!Schema.sObjectType.Lead.isUpdateable()
            || !Schema.sObjectType.Lead.fields.Status.isUpdateable()) {
            throw new LeadValidationException(
                'Você não possui permissão para atualizar o Status do Lead.'
            );
        }

        List<Lead> leads = [
            SELECT Id,
                   Status
            FROM Lead
            WHERE Id = :leadId
            LIMIT 1
        ];

        if (leads.isEmpty()) {
            throw new LeadValidationException(
                'Lead não encontrado.'
            );
        }

        Lead leadParaAtualizar = leads[0];
        leadParaAtualizar.Status = novoStatus;

        update leadParaAtualizar;
    }
}