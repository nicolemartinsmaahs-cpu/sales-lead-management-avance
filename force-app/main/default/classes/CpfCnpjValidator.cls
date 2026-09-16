public with sharing class CpfCnpjValidator {

    public class Request {
        @InvocableVariable(required=true)
        public String documento;

        @InvocableVariable(required=true)
        public String tipo;
    }

    public class ValidationResult {
        @AuraEnabled
        @InvocableVariable
        public Boolean valido;

        @AuraEnabled
        @InvocableVariable
        public String mensagem;
    }

    @InvocableMethod(
        label='Validar CPF ou CNPJ'
        description='Valida CPF ou CNPJ usando a API CPF.CNPJ.'
    )
    public static List<ValidationResult> validar(List<Request> requests) {

        List<ValidationResult> resultados =
            new List<ValidationResult>();

        for (Request request : requests) {
            resultados.add(
                consultar(
                    request.tipo == 'CNPJ' ? '6' : '9',
                    request.documento,
                    request.tipo
                )
            );
        }

        return resultados;
    }

    @AuraEnabled
    public static ValidationResult validarCpf(String cpf) {
        return consultar('9', cpf, 'CPF');
    }

    @AuraEnabled
    public static ValidationResult validarCnpj(String cnpj) {
        return consultar('6', cnpj, 'CNPJ');
    }

    private static ValidationResult consultar(
        String pacote,
        String documento,
        String tipo
    ) {
        ValidationResult result = new ValidationResult();
        result.valido = false;

        if (String.isBlank(documento)) {
            result.mensagem = tipo + ' não informado.';
            return result;
        }

        String documentoNormalizado = documento
            .replace('.', '')
            .replace('-', '')
            .replace('/', '')
            .replace(' ', '')
            .toUpperCase();

        HttpRequest req = new HttpRequest();

        req.setEndpoint(
            'callout:CPF_CNPJ_API/' +
            pacote +
            '/' +
            EncodingUtil.urlEncode(
                documentoNormalizado,
                'UTF-8'
            )
        );

        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');

        try {
            HttpResponse res = new Http().send(req);

            if (res.getStatusCode() != 200) {
                result.mensagem =
                    'Erro na API ' + tipo +
                    ': HTTP ' +
                    res.getStatusCode() +
                    '.';
                return result;
            }

            Map<String, Object> resposta =
                (Map<String, Object>)
                JSON.deserializeUntyped(res.getBody());

            String status =
                String.valueOf(resposta.get('status'));

            if (status == '1') {
                result.valido = true;
                result.mensagem =
                    tipo + ' validado com sucesso.';
            } else {
                result.valido = false;

                if (resposta.containsKey('erro')) {
                    result.mensagem =
                        tipo + ' não validado: ' +
                        String.valueOf(
                            resposta.get('erro')
                        );
                } else {
                    result.mensagem =
                        tipo + ' não validado.';
                }
            }

        } catch (Exception e) {
            result.valido = false;
            result.mensagem =
                'Erro ao consultar ' +
                tipo +
                ': ' +
                e.getMessage();
        }

        return result;
    }
}