trigger LeadBusinessTrigger on Lead (before insert, before update) {

    if (Trigger.isBefore) {
        LeadBusinessHandler.processarLeads(Trigger.new);
    }

}