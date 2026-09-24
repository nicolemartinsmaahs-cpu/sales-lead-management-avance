public with sharing class LeadFollowUpBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext context
    ) {
        return Database.getQueryLocator([
            SELECT Id, Status, Description
            FROM Lead
            WHERE IsConverted = false
            AND Status = 'Working - Contacted'
        ]);
    }

    public void execute(
        Database.BatchableContext context,
        List<Lead> leads
    ) {
        List<Lead> leadsParaAtualizar = new List<Lead>();

        for (Lead lead : leads) {
            if (String.isBlank(lead.Description)) {
                lead.Description =
                    'Acompanhamento comercial pendente via Batch Apex.';

                leadsParaAtualizar.add(lead);
            }
        }

        if (!leadsParaAtualizar.isEmpty()) {
            update leadsParaAtualizar;
        }
    }

    public void finish(
        Database.BatchableContext context
    ) {
        System.debug(
            'Batch de acompanhamento de Leads finalizado.'
        );
    }
}
