@IsTest
private class LeadValidationServiceTest {

    @IsTest
    static void deveAceitarLeadValido() {
        Lead leadValido = new Lead(
            LastName = 'Valido',
            Company = 'Avance Educacao Profissional'
        );

        LeadValidationService.validarLead(leadValido);

        System.assertEquals(
            'Valido',
            leadValido.LastName
        );
    }

    @IsTest
    static void deveRejeitarLeadNulo() {
        try {
            LeadValidationService.validarLead(null);

            System.assert(
                false,
                'Era esperada uma LeadValidationException.'
            );
        } catch (LeadValidationException ex) {
            System.assertEquals(
                'O Lead não pode ser nulo.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void deveRejeitarLeadSemSobrenome() {
        Lead leadInvalido = new Lead(
            Company = 'Avance Educacao Profissional'
        );

        try {
            LeadValidationService.validarLead(leadInvalido);

            System.assert(
                false,
                'Era esperada uma LeadValidationException.'
            );
        } catch (LeadValidationException ex) {
            System.assertEquals(
                'O sobrenome do Lead é obrigatório.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void deveRejeitarLeadSemEmpresa() {
        Lead leadInvalido = new Lead(
            LastName = 'SemEmpresa'
        );

        try {
            LeadValidationService.validarLead(leadInvalido);

            System.assert(
                false,
                'Era esperada uma LeadValidationException.'
            );
        } catch (LeadValidationException ex) {
            System.assertEquals(
                'A empresa do Lead é obrigatória.',
                ex.getMessage()
            );
        }
    }
}