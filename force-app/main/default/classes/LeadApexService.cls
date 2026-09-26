public with sharing class LeadApexService {

    public static List<Lead> buscarLeadsNaoConvertidos() {
        return [
            SELECT Id, FirstName, LastName, Company, Status, LeadSource
            FROM Lead
            WHERE IsConverted = false
            LIMIT 10
        ];
    }

    public static Lead criarLeadDeTeste() {
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

    public static void atualizarStatusLead(Id leadId, String novoStatus) {
    if (leadId == null) {
        throw new LeadValidationException(
            'O Id do Lead é obrigatório.'
        );
    }

    List<Lead> leads = [
        SELECT Id, Status
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