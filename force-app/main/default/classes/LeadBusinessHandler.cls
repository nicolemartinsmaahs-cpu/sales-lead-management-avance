public with sharing class LeadBusinessHandler {

    public static void processarLeads(List<Lead> leads) {

        List<Lead_Automation_Configuration__mdt> configuracoes = [
            SELECT Trigger_Status__c,
                   Description_Message__c,
                   Active__c
            FROM Lead_Automation_Configuration__mdt
            WHERE DeveloperName = 'Qualified_Lead'
            AND Active__c = true
            LIMIT 1
        ];

        if (configuracoes.isEmpty()) {
            return;
        }

        Lead_Automation_Configuration__mdt configuracao =
            configuracoes[0];

        for (Lead lead : leads) {

            if (
                lead.Status == configuracao.Trigger_Status__c &&
                String.isBlank(lead.Description)
            ) {
                lead.Description =
                    configuracao.Description_Message__c;
            }
        }
    }
}