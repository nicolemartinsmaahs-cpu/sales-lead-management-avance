public with sharing class LeadFollowUpQueueable
    implements Queueable {

    public void execute(QueueableContext context) {

        List<Lead_Automation_Configuration__mdt> configuracoes = [
            SELECT Trigger_Status__c,
                   Description_Message__c,
                   Active__c
            FROM Lead_Automation_Configuration__mdt
            WHERE DeveloperName = 'Queueable_Follow_Up'
            AND Active__c = true
            LIMIT 1
        ];

        if (configuracoes.isEmpty()) {
            System.debug(
                'Configuração do Queueable não encontrada ou inativa.'
            );
            return;
        }

        Lead_Automation_Configuration__mdt configuracao =
            configuracoes[0];

        List<Lead> leadsParaAtualizar = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE IsConverted = false
            AND Status = :configuracao.Trigger_Status__c
            LIMIT 50
        ];

        List<Lead> leadsElegiveis = new List<Lead>();

        for (Lead lead : leadsParaAtualizar) {

            if (String.isBlank(lead.Description)) {
                lead.Description =
                    configuracao.Description_Message__c;

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
