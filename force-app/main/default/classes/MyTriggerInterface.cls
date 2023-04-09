public interface MyTriggerInterface {
  void beforeInsert(List<SObject> newRecordList);
  void afterInsert(List<SObject> newRecordList, Map<Id, SObject> newRecordMap);
  void beforeUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  );
  void afterUpdate(
    Map<Id, SObject> oldRecordMap,
    Map<Id, SObject> newRecordMap
  );
  void beforeDelete(List<SObject> oldRecordList, Map<Id, SObject> oldMapRecord);
  void afterDelete(Map<Id, SObject> oldRecordMap);
  void afterUndelete(
    List<SObject> newRecordList,
    Map<id, SObject> newRecordMap
  );
}