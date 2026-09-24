public with sharing class LeadBusinessHandler {

    public static void processarLeads(List<Lead> leads) {

        for (Lead lead : leads) {

            if (
                lead.Status == 'Qualified' &&
                String.isBlank(lead.Description)
            ) {
                lead.Description =
                    'Lead qualificado automaticamente via Apex.';
            }
        }
    }
}