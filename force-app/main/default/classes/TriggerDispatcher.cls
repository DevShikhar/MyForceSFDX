public with sharing class TriggerDispatcher {
  public TriggerDispatcher() {
  }

  public static void run(
    MyTriggerInterface handler,
    System.TriggerOperation operationType
  ) {
    switch on operationType {
      when BEFORE_INSERT {
        handler.beforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
        handler.afterInsert(Trigger.new, Trigger.newMap);
      }
      when BEFORE_UPDATE {
        handler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
      }
      when AFTER_UPDATE {
        handler.afterUpdate(Trigger.oldMap, Trigger.newMap);
      }
      when BEFORE_DELETE {
        handler.beforeDelete(Trigger.old, Trigger.oldMap);
      }
      when AFTER_DELETE {
        handler.afterDelete(Trigger.oldMap);
      }
      when AFTER_UNDELETE {
        handler.afterUndelete(Trigger.new, Trigger.newMap);
      }
    }
  }
}