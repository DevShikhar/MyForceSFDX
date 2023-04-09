@RestResource(urlMapping='/studInfo/*')
global with sharing class StudentREST {
    
    @HttpGet
    global static StudData getStudentById() {
        RestRequest req = RestContext.request;

        String studId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Student__c stud = [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, CreatedById, LastModifiedById, Class_Enrolled__c, Name__c, Address__c, Phone__c, Email__c, School__c FROM Student__c where id =: studId];
        
        StudData std = new StudData();
        std.clsEnr = stud.Class_Enrolled__c;
        std.stname = stud.Name__c;
        std.addr = stud.Address__c;
        std.stPhone = stud.Phone__c;
        std.stEmail = stud.Email__c;
        std.stSchool = stud.School__c;
        return std;
    }

    @HttpPost
    global static Student__c addStudent(Integer classEnr, String studName, String addr, String phnum, String mailId, String schoolId) {

        Student__c std = new Student__c();
        std.Class_Enrolled__c = classEnr;
        std.Name__c = studName;
        std.Address__c = addr;
        std.Phone__c = phnum;
        std.Email__c = mailId;
        std.School__c = schoolId;

        insert std;
        return std;
       
        // "Class_Enrolled__c": 12,
        // "Name__c": "Sohan",
        // "Address__c": "Pune",
        // "Phone__c": "899393292",
        // "Email__c": "so@abc.com",
        // "School__c": "a085h00000IZZtRAAX"
    }
    
    global class StudData {
        Double clsEnr {get; set;}
        String stname {get; set;}
        String addr {get; set;}
        String stEmail {get; set;}
        String stPhone {get; set;}
        String stSchool {get; set;}
    }
    
}