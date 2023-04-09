public with sharing class ContactTriggerHandler implements MyTriggerInterface {
  public ContactTriggerHandler() {
  }

  public void beforeInsert(List<SObject> newRecordList) {
  }
  public void afterInsert(
    List<SObject> newRecordList,
    Map<Id, SObject> newRecordMap
  ) {
    Map<Id, Contact> newContactsMap = (Map<Id, Contact>) newRecordMap;
    ContactTriggerHelper.afterUpdateOperations(newContactsMap);
  }
  public void beforeUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
  }
  public void afterUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  ) {
    Map<Id, Contact> oldContactsMap = (Map<Id, Contact>) oldRecordMap;
    Map<Id, Contact> newContactsMap = (Map<Id, Contact>) newRecordMap;
    ContactTriggerHelper.afterUpdateOperations(oldContactsMap, newContactsMap);
  }
  public void beforeDelete(
    List<SObject> oldRecordList,
    Map<Id, SObject> oldMapRecord
  ) {
  }
  public void afterDelete(Map<id, SObject> oldRecordMap) {
    Map<Id, Contact> oldContactsMap = (Map<Id, Contact>) oldRecordMap;
    ContactTriggerHelper.afterUpdateOperations(oldContactsMap);
  }
  public void afterUndelete(
    List<SObject> newRecordList,
    Map<id, SObject> newRecordMap
  ) {
    Map<Id, Contact> newContactsMap = (Map<Id, Contact>) newRecordMap;
    ContactTriggerHelper.afterUpdateOperations(newContactsMap);
  }
}