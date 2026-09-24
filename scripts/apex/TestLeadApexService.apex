List<Lead> leads = LeadApexService.buscarLeadsNaoConvertidos();

System.debug('Quantidade de Leads encontrados: ' + leads.size());

for (Lead lead : leads) {
    System.debug(
        'Lead: ' + lead.FirstName + ' ' +
        lead.LastName + ' | Status: ' +
        lead.Status
    );
}
