public with sharing class CTLocationController {
  public CTLocationController() {
  }

  public static List<Location__c> getRecentStatusChanges() {
    List<Location__c> allLocations = [
      SELECT
        Id,
        Status__c,
        Status_Update_Date__c,
        Red_Score__c,
        Pincode__c,
        Address__c,
        Name
      FROM Location__c
      ORDER BY Status_Update_Date__c DESC
      LIMIT 100
    ];
    if (allLocations.size() > 0) {
      return allLocations;
    } else {
      return null;
    }
  }

  public static List<Location__c> searchLocations(String searchTerm) {
    List<Location__c> allLocations = [
      SELECT
        Id,
        Status__c,
        Status_Update_Date__c,
        Red_Score__c,
        Pincode__c,
        Address__c,
        Name
      FROM Location__c
      WHERE
        name LIKE :searchTerm
        OR Pincode__c LIKE :searchTerm
        OR Address__c LIKE :searchTerm
      ORDER BY Status_Update_Date__c DESC
      LIMIT 100
    ];
    if (allLocations.size() > 0) {
      return allLocations;
    } else {
      return null;
    }
  }

  public static Location__c getLocationById(String locationId) {
    List<Location__c> allLocations = [
      SELECT
        Id,
        Status__c,
        Status_Update_Date__c,
        Red_Score__c,
        Pincode__c,
        Address__c,
        Name
      FROM Location__c
      WHERE id = :locationId
    ];
    if (allLocations.size() > 0) {
      return allLocations[0];
    } else {
      return null;
    }
  }

  public static Map<String, Integer> getStatusCount() {
    Map<String, Integer> locationStatusMap = new Map<String, Integer>();
    for (AggregateResult agr : [
      SELECT count(id) locationCount, Status__c
      FROM Location__c
      GROUP BY Status__c
    ]) {
      locationStatusMap.put(
        String.valueOf(agr.get('Status__c')),
        Integer.valueOf(agr.get('locationCount'))
      );
    }
    if (locationStatusMap.keySet().size() > 0) {
      return locationStatusMap;
    } else {
      return null;
    }
  }

  public static void UpdateRedScore(
    List<Location_Tracing__c> locationsVisited
  ) {
    Set<Id> locIds = new Set<Id>();
    for (Location_Tracing__c ltr : locationsVisited) {
      locIds.add(ltr.Location__c);
    }

    List<Location__c> locationToUpdate = new List<Location__c>();
    AggregateResult[] agr = [
      SELECT location__c, count(Id) redCount
      FROM Location_Tracing__c
      WHERE
        Location__c IN :locIds
        AND Person__r.Health_Status__c = 'Red'
        AND visit_date__c = LAST_N_DAYS:10
      GROUP BY location__c
    ];
    for (AggregateResult res : agr) {
      String locId = String.valueOf(res.get('location__c'));
      Integer redCount = Integer.valueOf(res.get('redCount'));
      String redStatus = getStatus(redCount);
      locationToUpdate.add(
        new Location__c(
          id = locId,
          Status__c = redStatus,
          red_score__c = redCount
        )
      );
    }
    update locationToUpdate;
  }

  public static String getStatus(Integer redScore) {
    if (redScore == 0) {
      return 'Green';
    } else if (redScore > 0 && redScore <= 5) {
      System.debug('return yellow');
      return 'Yellow';
    } else if (redScore > 5 && redScore <= 10) {
      return 'Orange';
    } else {
      return 'Red';
    }
  }
}