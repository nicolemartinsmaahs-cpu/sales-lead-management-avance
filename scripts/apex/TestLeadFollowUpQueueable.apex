Id jobId = System.enqueueJob(
    new LeadFollowUpQueueable()
);

System.debug('Queueable iniciado com sucesso!');
System.debug('Job ID: ' + jobId);
