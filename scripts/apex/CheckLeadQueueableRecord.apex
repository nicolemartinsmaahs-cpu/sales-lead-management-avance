Lead leadTeste = [
    SELECT Id, FirstName, LastName, Status, Description, IsConverted
    FROM Lead
    WHERE Id = '00Qg700000JL9DREA1'
];

System.debug('ID: ' + leadTeste.Id);
System.debug('Nome: ' + leadTeste.FirstName + ' ' + leadTeste.LastName);
System.debug('Status atual: ' + leadTeste.Status);
System.debug('Description: ' + leadTeste.Description);
System.debug('Convertido: ' + leadTeste.IsConverted);
