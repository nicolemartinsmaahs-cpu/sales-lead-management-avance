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
    }

    @IsTest
    static void shouldReturnLeadCountByStatus() {

        Test.startTest();

        Map<String, Integer> result =
            LeadManagementController.getLeadCountByStatus();

        Test.stopTest();

        System.assertEquals(
            2,
            result.get('Open - Not Contacted')
        );

        System.assertEquals(
            3,
            result.get('Working - Contacted')
        );

        System.assertEquals(
            1,
            result.get('Qualified')
        );
    }
}