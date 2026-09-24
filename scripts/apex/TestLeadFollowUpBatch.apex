Id batchJobId = Database.executeBatch(
    new LeadFollowUpBatch(),
    10
);

System.debug('Batch iniciado com sucesso!');
System.debug('Job ID: ' + batchJobId);
