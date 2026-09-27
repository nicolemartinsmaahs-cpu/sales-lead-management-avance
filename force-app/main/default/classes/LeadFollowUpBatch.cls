public with sharing class LeadFollowUpBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext context
    ) {
        List<Lead_Automation_Configuration__mdt> configuracoes = [
            SELECT Trigger_Status__c,
                   Description_Message__c,
                   Active__c
            FROM Lead_Automation_Configuration__mdt
            WHERE DeveloperName = 'Batch_Follow_Up'
            AND Active__c = true
            LIMIT 1
        ];

        if (configuracoes.isEmpty()) {
            System.debug(
                LoggingLevel.WARN,
                'Configuração do Batch não encontrada ou inativa.'
            );

            return Database.getQueryLocator([
                SELECT Id, Status, Description
                FROM Lead
                WHERE Id = null
            ]);
        }

        String triggerStatus =
            configuracoes[0].Trigger_Status__c;

        return Database.getQueryLocator([
            SELECT Id, Status, Description
            FROM Lead
            WHERE IsConverted = false
            AND Status = :triggerStatus
        ]);
    }

    public void execute(
        Database.BatchableContext context,
        List<Lead> leads
    ) {
        List<Lead_Automation_Configuration__mdt> configuracoes = [
            SELECT Description_Message__c,
                   Active__c
            FROM Lead_Automation_Configuration__mdt
            WHERE DeveloperName = 'Batch_Follow_Up'
            AND Active__c = true
            LIMIT 1
        ];

        if (configuracoes.isEmpty()) {
            System.debug(
                LoggingLevel.WARN,
                'Configuração do Batch não encontrada ou inativa durante o processamento.'
            );
            return;
        }

        String descriptionMessage =
            configuracoes[0].Description_Message__c;

        List<Lead> leadsParaAtualizar = new List<Lead>();

        for (Lead lead : leads) {
            if (String.isBlank(lead.Description)) {
                lead.Description = descriptionMessage;
                leadsParaAtualizar.add(lead);
            }
        }

        if (!leadsParaAtualizar.isEmpty()) {
            update leadsParaAtualizar;
        }

        System.debug(
            LoggingLevel.INFO,
            'Batch executado. Leads recebidos: ' +
            leads.size() +
            '. Leads atualizados: ' +
            leadsParaAtualizar.size() +
            '.'
        );
    }

    public void finish(
        Database.BatchableContext context
    ) {
        System.debug(
            LoggingLevel.INFO,
            'Batch de acompanhamento de Leads finalizado.'
        );
    }
}
