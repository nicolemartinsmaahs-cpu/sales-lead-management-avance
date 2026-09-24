@IsTest
private class LeadApexServiceTest {

    @TestSetup
    static void criarDadosDeTeste() {
        insert new List<Lead>{
            new Lead(
                FirstName = 'Teste',
                LastName = 'Apex 1',
                Company = 'Avance Educação Profissional',
                Status = 'Open - Not Contacted',
                LeadSource = 'Web'
            ),
            new Lead(
                FirstName = 'Teste',
                LastName = 'Apex 2',
                Company = 'Avance Educação Profissional',
                Status = 'Working - Contacted',
                LeadSource = 'Web'
            )
        };
    }

    @IsTest
    static void deveBuscarLeadsNaoConvertidos() {
        Test.startTest();

        List<Lead> leads =
            LeadApexService.buscarLeadsNaoConvertidos();

        Test.stopTest();

        System.assert(
            leads.size() > 0,
            'Deveria retornar pelo menos um Lead.'
        );
    }

    @IsTest
    static void deveCriarLead() {
        Test.startTest();

        Lead novoLead =
            LeadApexService.criarLeadDeTeste();

        Test.stopTest();

        Lead leadConsultado = [
            SELECT Id, FirstName, LastName, Company, Status
            FROM Lead
            WHERE Id = :novoLead.Id
        ];

        System.assertEquals(
            'Apex',
            leadConsultado.FirstName
        );

        System.assertEquals(
            'Training',
            leadConsultado.LastName
        );

        System.assertEquals(
            'Open - Not Contacted',
            leadConsultado.Status
        );
    }

    @IsTest
    static void deveAtualizarStatusDoLead() {
        Lead leadTeste = [
            SELECT Id, Status
            FROM Lead
            LIMIT 1
        ];

        Test.startTest();

        LeadApexService.atualizarStatusLead(
            leadTeste.Id,
            'Working - Contacted'
        );

        Test.stopTest();

        Lead leadAtualizado = [
            SELECT Id, Status
            FROM Lead
            WHERE Id = :leadTeste.Id
        ];

        System.assertEquals(
            'Working - Contacted',
            leadAtualizado.Status
        );
    }
}