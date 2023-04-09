public with sharing class AccountController {
  public AccountController() {
  }

  public static void UpdateAvgCaseResolutionDays(List<Id> accountIds) {
    Integer totalCases = 0;
    Integer totalDays = 0;
    Map<Id, Integer> totalCaseMap = new Map<Id, Integer>();
    Map<Id, Integer> totalDaysMap = new Map<Id, Integer>();

    for (Case accCase : [
      SELECT id, createdDate, closedDate, AccountId
      FROM Case
      WHERE IsClosed = TRUE AND AccountId IN :accountIds
    ]) {
      if (!totalCaseMap.containsKey(accCase.AccountId)) {
        totalCases++;
        totalCaseMap.put(accCase.AccountId, totalCases);
      } else {
        totalCases = totalCaseMap.get(accCase.AccountId) + 1;
        totalCaseMap.put(accCase.AccountId, totalCases);
      }

      if (!totalDaysMap.containsKey(accCase.AccountId)) {
        totalDays += accCase.CreatedDate.date()
          .daysBetween(accCase.closedDate.date());
        totalDaysMap.put(accCase.AccountId, totalDays);
      } else {
        totalDays =
          totalDaysMap.get(accCase.AccountId) +
          accCase.CreatedDate.date().daysBetween(accCase.closedDate.date());
        totalDaysMap.put(accCase.AccountId, totalDays);
      }
      totalCases = 0;
      totalDays = 0;
    }

    List<Account> accToUpdate = new List<Account>();
    for (ID accId : totalCaseMap.keySet()) {
      Decimal AvgCaseDays = totalDaysMap.get(accId) / totalCaseMap.get(accId);
      SYstem.debug(
        'Account: ' +
          accId +
          ' ** ' +
          totalDaysMap.get(accId) +
          ' ** ' +
          totalCaseMap.get(accId)
      );
      accToUpdate.add(
        new Account(Id = accId, Avg_case_resolution_days__c = AvgCaseDays)
      );
    }

    update accToUpdate;
  }
}