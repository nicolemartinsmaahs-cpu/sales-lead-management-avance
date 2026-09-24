@IsTest
private class LeadFollowUpQueueableTest {

    @IsTest
    static void deveAtualizarDescricaoDosLeadsElegiveis() {

        Lead leadElegivel = new Lead(
            FirstName = 'Queueable',
            LastName = 'Elegivel',
            Company = 'Avance Educação Profissional',
            Status = 'Working - Contacted',
            LeadSource = 'Other'
        );

        insert leadElegivel;

        Test.startTest();

        Id jobId = System.enqueueJob(
            new LeadFollowUpQueueable()
        );

        Test.stopTest();

        Lead leadAtualizado = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE Id = :leadElegivel.Id
        ];

        System.assertNotEquals(null, jobId);

        System.assertEquals(
            'Acompanhamento comercial via Queueable Apex.',
            leadAtualizado.Description
        );
    }

    @IsTest
    static void naoDeveSobrescreverDescricaoExistente() {

        Lead leadTeste = new Lead(
            FirstName = 'Queueable',
            LastName = 'ComDescricao',
            Company = 'Avance Educação Profissional',
            Status = 'Working - Contacted',
            LeadSource = 'Other',
            Description = 'Descrição já existente.'
        );

        insert leadTeste;

        Test.startTest();

        System.enqueueJob(
            new LeadFollowUpQueueable()
        );

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, Description
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Descrição já existente.',
            leadConsultado.Description
        );
    }
}
