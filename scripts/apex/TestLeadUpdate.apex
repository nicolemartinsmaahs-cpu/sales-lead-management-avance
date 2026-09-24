Id leadId = '00Qg700000JKRdpEAH';

LeadApexService.atualizarStatusLead(
    leadId,
    'Working - Contacted'
);

Lead leadAtualizado = [
    SELECT Id, FirstName, LastName, Status
    FROM Lead
    WHERE Id = :leadId
];

System.debug('Lead atualizado com sucesso!');
System.debug('Nome: ' + leadAtualizado.FirstName + ' ' + leadAtualizado.LastName);
System.debug('Novo status: ' + leadAtualizado.Status);
