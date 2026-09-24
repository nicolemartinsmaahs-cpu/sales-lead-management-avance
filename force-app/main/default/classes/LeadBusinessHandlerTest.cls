@IsTest
private class LeadBusinessHandlerTest {

    @IsTest
    static void devePreencherDescricaoAoCriarLeadQualificado() {

        Lead leadTeste = new Lead(
            FirstName = 'Teste',
            LastName = 'Trigger',
            Company = 'Avance Educação Profissional',
            Status = 'Qualified',
            LeadSource = 'Other'
        );

        Test.startTest();

        insert leadTeste;

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Qualified',
            leadConsultado.Status
        );

        System.assertEquals(
            'Lead qualificado automaticamente via Apex.',
            leadConsultado.Description
        );
    }

    @IsTest
    static void naoDeveAlterarDescricaoExistente() {

        Lead leadTeste = new Lead(
            FirstName = 'Teste',
            LastName = 'Descricao',
            Company = 'Avance Educação Profissional',
            Status = 'Qualified',
            LeadSource = 'Other',
            Description = 'Descricao preenchida manualmente.'
        );

        Test.startTest();

        insert leadTeste;

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, Description
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Descricao preenchida manualmente.',
            leadConsultado.Description
        );
    }

    @IsTest
    static void naoDevePreencherDescricaoParaLeadNaoQualificado() {

        Lead leadTeste = new Lead(
            FirstName = 'Teste',
            LastName = 'NaoQualificado',
            Company = 'Avance Educação Profissional',
            Status = 'Open - Not Contacted',
            LeadSource = 'Other'
        );

        Test.startTest();

        insert leadTeste;

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, Status, Description
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Open - Not Contacted',
            leadConsultado.Status
        );

        System.assertEquals(
            null,
            leadConsultado.Description
        );
    }
}
