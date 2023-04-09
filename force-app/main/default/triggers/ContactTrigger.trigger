trigger ContactTrigger on Contact(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  TriggerDispatcher.run(new ContactTriggerHandler(), Trigger.operationType);
  //   switch on Trigger.OperationType {
  //     when AFTER_INSERT {
  //       ContactTriggerHandler.afterUpdateOperations(Trigger.newMap);
  //     }
  //     when AFTER_UPDATE {
  //       ContactTriggerHandler.afterUpdateOperations(
  //         Trigger.oldMap,
  //         Trigger.newMap
  //       );
  //     }
  //     when AFTER_DELETE {
  //       ContactTriggerHandler.afterUpdateOperations(Trigger.oldMap);
  //     }
  //     when AFTER_UNDELETE {
  //       ContactTriggerHandler.afterUpdateOperations(Trigger.newMap);
  //     }
  //   }
}