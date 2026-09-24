@IsTest
private class LeadFollowUpBatchTest {

    @IsTest
    static void deveAtualizarDescricaoDosLeadsElegiveis() {

        List<Lead> leadsTeste = new List<Lead>{
            new Lead(
                FirstName = 'Batch',
                LastName = 'Elegivel',
                Company = 'Avance Educação Profissional',
                Status = 'Working - Contacted',
                LeadSource = 'Other'
            ),
            new Lead(
                FirstName = 'Batch',
                LastName = 'NaoElegivel',
                Company = 'Avance Educação Profissional',
                Status = 'Open - Not Contacted',
                LeadSource = 'Other'
            )
        };

        insert leadsTeste;

        Test.startTest();

        Id jobId = Database.executeBatch(
            new LeadFollowUpBatch(),
            10
        );

        Test.stopTest();

        Lead leadElegivel = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE Id = :leadsTeste[0].Id
        ];

        Lead leadNaoElegivel = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE Id = :leadsTeste[1].Id
        ];

        System.assertNotEquals(
            null,
            jobId,
            'O Batch deveria retornar um Job ID.'
        );

        System.assertEquals(
            'Acompanhamento comercial pendente via Batch Apex.',
            leadElegivel.Description
        );

        System.assertEquals(
            null,
            leadNaoElegivel.Description
        );
    }

    @IsTest
    static void naoDeveSobrescreverDescricaoExistente() {

        Lead leadTeste = new Lead(
            FirstName = 'Batch',
            LastName = 'ComDescricao',
            Company = 'Avance Educação Profissional',
            Status = 'Working - Contacted',
            LeadSource = 'Other',
            Description = 'Descrição preenchida anteriormente.'
        );

        insert leadTeste;

        Test.startTest();

        Database.executeBatch(
            new LeadFollowUpBatch(),
            10
        );

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, Description
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Descrição preenchida anteriormente.',
            leadConsultado.Description
        );
    }
}
