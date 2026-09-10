public with sharing class LeadManagementController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getLeadCountByStatus() {

        Map<String, Integer> result = new Map<String, Integer>();

        for (AggregateResult ar : [
            SELECT Status, COUNT(Id) total
            FROM Lead
            WHERE IsConverted = false
            GROUP BY Status
        ]) {
            result.put(
                (String) ar.get('Status'),
                (Integer) ar.get('total')
            );
        }

        return result;
    }
}