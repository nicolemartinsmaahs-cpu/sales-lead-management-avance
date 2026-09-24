Lead novoLead = LeadApexService.criarLeadDeTeste();

System.debug('Lead criado com sucesso!');
System.debug('ID: ' + novoLead.Id);
System.debug('Nome: ' + novoLead.FirstName + ' ' + novoLead.LastName);
System.debug('Status: ' + novoLead.Status);
