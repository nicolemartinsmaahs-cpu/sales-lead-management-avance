AsyncApexJob job = [
    SELECT Id, Status, JobItemsProcessed, TotalJobItems,
           NumberOfErrors, ExtendedStatus, CreatedDate,
           CompletedDate
    FROM AsyncApexJob
    WHERE Id = '707g700000vFlEd'
];

System.debug('Status: ' + job.Status);
System.debug('Itens processados: ' + job.JobItemsProcessed);
System.debug('Total de itens: ' + job.TotalJobItems);
System.debug('Erros: ' + job.NumberOfErrors);
System.debug('Status detalhado: ' + job.ExtendedStatus);
System.debug('Data de conclusao: ' + job.CompletedDate);
