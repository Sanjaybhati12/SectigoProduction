public without sharing class DriverAccessNoSharing{
    
    public static List<SObject> fetchObjects(Schema.SObjectType sObjectType, String fieldList, String condition, String orderByFields, Integer numberOfRowsToReturn) {
        String queryStr;
        try{
            if(sObjectType == null){
                throw new CustomException.InputDataException('Object name cannot be blank.');
            }
            if(fieldList == null || fieldList.trim().equals('')){
                throw new CustomException.InputDataException('Field list cannot be blank.');
            }
            queryStr = 'SELECT ' + fieldList + ' FROM ' + sObjectType;
            if(condition != null && condition != ''){
                queryStr = queryStr + ' WHERE ' + condition;
            }
            if(orderByFields != null && orderByFields != ''){
                queryStr = queryStr + ' ORDER BY ' + orderByFields;
            }
            if(numberOfRowsToReturn == null || numberOfRowsToReturn <= 0){
                numberOfRowsToReturn = Limits.getLimitQueryRows() - Limits.getQueryRows() - 100;
            }
            queryStr = queryStr + ' LIMIT ' + String.valueOf(numberOfRowsToReturn);
            system.debug('queryStr -----> ' + queryStr);
            return Database.query(queryStr);
        }catch(Exception e){
            throw e;
        }
        //return null;
    }
}