public with sharing class AccountContactService {
  public AccountContactService() {
  }

  public static void activeContactupdate(Set<Id> accIds) {
    Map<id, integer> mapOfAccountToCount = new Map<id, integer>();
    List<Account> accountToUpdate = new List<Account>();

    for (Id accid : accIds) {
      mapOfAccountToCount.put(accid, 0);
    }

    for (AggregateResult agr : [
      SELECT accountid, count(id) activeCount
      FROM contact
      WHERE accountid IN :accIds AND Active__c = TRUE
      GROUP BY accountid
    ]) {
      mapOfAccountToCount.put(
        String.valueOf(agr.get('accountid')),
        Integer.valueOf(agr.get('activeCount'))
      );
    }
    System.debug(accIds);
    System.debug(mapOfAccountToCount);
    for (Id accid : accIds) {
      accountToUpdate.add(
        new Account(
          Id = accid,
          Total_active_contacts__c = mapOfAccountToCount.get(accid)
        )
      );
    }
    System.debug(accountToUpdate);
    if (accountToUpdate.size() > 0) {
      update accountToUpdate;
    }
  }
}