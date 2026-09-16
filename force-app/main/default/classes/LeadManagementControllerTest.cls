@IsTest
private class LeadManagementControllerTest {

    @TestSetup
    static void setupData() {

        List<Lead> leads = new List<Lead>();

        for (Integer i = 0; i < 2; i++) {
            leads.add(new Lead(
                FirstName = 'Teste',
                LastName = 'Open' + i,
                Company = 'Avance Educação Profissional',
                Status = 'Open - Not Contacted',
                LeadSource = 'Web'
            ));
        }

        for (Integer i = 0; i < 3; i++) {
            leads.add(new Lead(
                FirstName = 'Teste',
                LastName = 'Working' + i,
                Company = 'Avance Educação Profissional',
                Status = 'Working - Contacted',
                LeadSource = 'Web'
            ));
        }

        leads.add(new Lead(
            FirstName = 'Teste',
            LastName = 'Qualified',
            Company = 'Avance Educação Profissional',
            Status = 'Qualified',
            LeadSource = 'Web'
        ));

        insert leads;

        Lead convertedLead = new Lead(
            FirstName = 'Teste',
            LastName = 'Converted',
            Company = 'Lead Convertido',
            Status = 'Open - Not Contacted',
            LeadSource = 'Web'
        );

        insert convertedLead;

        Database.LeadConvert conversion = new Database.LeadConvert();
        conversion.setLeadId(convertedLead.Id);
        conversion.setDoNotCreateOpportunity(true);

        LeadStatus convertedStatus = [
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];

        conversion.setConvertedStatus(convertedStatus.MasterLabel);

        Database.convertLead(conversion);
    }

    @IsTest
    static void shouldReturnLeadCountByStatus() {

        Test.startTest();

        Map<String, Integer> result =
            LeadManagementController.getLeadCountByStatus();

        Test.stopTest();

        System.assertEquals(
            2,
            result.get('Open - Not Contacted'),
            'Deve retornar somente os 2 Leads Open não convertidos.'
        );

        System.assertEquals(
            3,
            result.get('Working - Contacted'),
            'Deve retornar os 3 Leads Working não convertidos.'
        );

        System.assertEquals(
            1,
            result.get('Qualified'),
            'Deve retornar o 1 Lead Qualified não convertido.'
        );
    }
}