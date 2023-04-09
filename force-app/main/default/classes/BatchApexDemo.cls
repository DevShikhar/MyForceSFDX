public with sharing class BatchApexDemo implements Database.Batchable<SObject>, Database.Stateful {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT ID, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode from Account where ' +
        'BillingStreet = NULL AND ' +
        'BillingCity = NULL AND ' +
        'BillingPostalCode = NULL'
    );
  }

  public void execute(
    Database.BatchableContext bc,
    List<Account> batchAccount
  ) {
    Integer i = 123431;
    List<Account> accToUpdate = new List<Account>();
    for (Account acc : batchAccount) {
      acc.BillingStreet = acc.Name + 'Street';
      acc.BillingCity = acc.Name + 'City';
      acc.BillingState = acc.Name + 'State';
      acc.BillingPostalCode = String.valueOf(i);
      i++;
      accToUpdate.add(acc);
    }
    if (accToUpdate.size() > 0) {
      update accToUpdate;
    }
  }

  public void finish(Database.BatchableContext bc) {
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];
    System.debug(job);
  }
}