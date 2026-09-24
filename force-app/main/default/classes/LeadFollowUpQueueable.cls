public with sharing class LeadFollowUpQueueable
    implements Queueable {

    public void execute(QueueableContext context) {

        List<Lead> leadsParaAtualizar = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE IsConverted = false
            AND Status = 'Working - Contacted'
            LIMIT 50
        ];

        List<Lead> leadsElegiveis = new List<Lead>();

        for (Lead lead : leadsParaAtualizar) {

            if (String.isBlank(lead.Description)) {
                lead.Description =
                    'Acompanhamento comercial via Queueable Apex.';

                leadsElegiveis.add(lead);
            }
        }

        if (!leadsElegiveis.isEmpty()) {
            update leadsElegiveis;
        }

        System.debug(
            'Queueable de acompanhamento de Leads finalizado.'
        );
    }
}
