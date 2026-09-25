public with sharing class LeadValidationService {

    public static void validarLead(Lead leadParaValidar) {
        if (leadParaValidar == null) {
            throw new LeadValidationException(
                'O Lead não pode ser nulo.'
            );
        }

        if (String.isBlank(leadParaValidar.LastName)) {
            throw new LeadValidationException(
                'O sobrenome do Lead é obrigatório.'
            );
        }

        if (String.isBlank(leadParaValidar.Company)) {
            throw new LeadValidationException(
                'A empresa do Lead é obrigatória.'
            );
        }
    }
}