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
    @IsTest
    static void deveRetornarListaVaziaQuandoNaoHouverLeads() {
        delete [
            SELECT Id
            FROM Lead
        ];

        Test.startTest();

        List<Lead> leads =
            LeadApexService.buscarLeadsNaoConvertidos();

        Test.stopTest();

        System.assertEquals(
            0,
            leads.size(),
            'Deveria retornar uma lista vazia quando não houver Leads.'
        );
    }
   @IsTest
static void deveFalharAoAtualizarLeadInexistente() {
    Id leadIdInexistente = '00Q000000000000AAA';

    try {
        LeadApexService.atualizarStatusLead(
            leadIdInexistente,
            'Working - Contacted'
        );

        System.assert(
            false,
            'Era esperada uma LeadValidationException.'
        );
    } catch (LeadValidationException ex) {
        System.assertEquals(
            'Lead não encontrado.',
            ex.getMessage()
        );
    }
}
@IsTest
static void deveFalharAoAtualizarComIdNulo() {
    try {
        LeadApexService.atualizarStatusLead(
            null,
            'Working - Contacted'
        );

        System.assert(
            false,
            'Era esperada uma LeadValidationException.'
        );
    } catch (LeadValidationException ex) {
        System.assertEquals(
            'O Id do Lead é obrigatório.',
            ex.getMessage()
        );
    }
}
    @IsTest
    static void deveIgnorarLeadConvertido() {
        Lead leadParaConverter = new Lead(
            FirstName = 'Teste',
            LastName = 'Convertido',
            Company = 'Empresa Convertida',
            Status = 'Open - Not Contacted',
            LeadSource = 'Web'
        );

        insert leadParaConverter;

        LeadStatus statusConvertido = [
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];

        Database.LeadConvert conversao = new Database.LeadConvert();
        conversao.setLeadId(leadParaConverter.Id);
        conversao.setConvertedStatus(statusConvertido.MasterLabel);

        Database.LeadConvertResult resultado =
            Database.convertLead(conversao);

        System.assert(
            resultado.isSuccess(),
            'A conversao do Lead deveria ser bem-sucedida.'
        );

        Test.startTest();

        List<Lead> leads =
            LeadApexService.buscarLeadsNaoConvertidos();

        Test.stopTest();

        for (Lead lead : leads) {
            System.assertNotEquals(
                leadParaConverter.Id,
                lead.Id,
                'Um Lead convertido nao deveria ser retornado.'
            );
        }
    }
}