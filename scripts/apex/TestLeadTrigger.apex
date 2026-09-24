Lead leadTeste = new Lead(
    FirstName = 'Trigger',
    LastName = 'Training',
    Company = 'Avance Educação Profissional',
    Status = 'Qualified',
    LeadSource = 'Other'
);

insert leadTeste;

Lead leadConsultado = [
    SELECT Id, FirstName, LastName, Status, Description
    FROM Lead
    WHERE Id = :leadTeste.Id
];

System.debug('Lead criado pela Trigger!');
System.debug('ID: ' + leadConsultado.Id);
System.debug('Status: ' + leadConsultado.Status);
System.debug('Description: ' + leadConsultado.Description);
