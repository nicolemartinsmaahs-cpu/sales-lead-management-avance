Lead leadTeste = new Lead(
    FirstName = 'Queueable',
    LastName = 'Training',
    Company = 'Avance Educação Profissional',
    Status = 'Working - Contacted',
    LeadSource = 'Other'
);

insert leadTeste;

System.debug('Lead criado para teste do Queueable!');
System.debug('ID: ' + leadTeste.Id);
