public Class TaskWebformHandler{
    public static void RecordTypeChangeToWebform(List<Task> newTaskList){
        Id webformRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WebForms').getRecordTypeId();
        Set<String> typeSet = new Set<String>();
        for(String st : Label.TaskHubspotRecordType.split(',')){
            typeSet.add(st);
        }
        system.debug('typeList 2 >>'+typeSet);
        for(Task tas : newTaskList){
            system.debug('tas.type >'+tas.type);
            system.debug('tas.type >'+typeSet.contains(tas.type));
            if(typeSet.contains(tas.type) && tas.RecordtypeId != webformRecordTypeId ){
                tas.RecordTypeId = webformRecordTypeId ;
            }
        }
    }
}