public with sharing class ContactTriggerHelper {
  public ContactTriggerHelper() {
  }

  public static void afterUpdateOperations(Map<id, Contact> newMapContacts) {
    Set<id> accIds = new Set<id>();
    for (Contact cnt : newMapContacts.values()) {
      accIds.add(cnt.AccountId);
    }

    AccountContactService.activeContactupdate(accIds);
  }

  public static void afterUpdateOperations(
    Map<id, Contact> oldMapContacts,
    Map<id, Contact> newMapContacts
  ) {
    Set<Id> accIds = new Set<Id>();
    for (Contact cnt : newMapContacts.values()) {
      if (
        String.isNotBlank(cnt.AccountId) &&
        cnt.Active__c != oldMapContacts.get(cnt.Id).Active__c
      ) {
        if (cnt.AccountId != oldMapContacts.get(cnt.Id).AccountId) {
          accIds.add(cnt.AccountId);
          if (String.isNotBlank(oldMapContacts.get(cnt.Id).AccountId)) {
            accIds.add(oldMapContacts.get(cnt.Id).AccountId);
          }
        } else {
          accIds.add(cnt.AccountId);
        }
      } else if (cnt.AccountId != oldMapContacts.get(cnt.Id).AccountId) {
        if (String.isBlank(cnt.AccountId)) {
          accIds.add(oldMapContacts.get(cnt.Id).AccountId);
        } else {
          accIds.add(cnt.AccountId);
          if (String.isNotBlank(oldMapContacts.get(cnt.Id).AccountId)) {
            accIds.add(oldMapContacts.get(cnt.Id).AccountId);
          }
        }
      }
    }
    AccountContactService.activeContactupdate(accIds);
  }
}