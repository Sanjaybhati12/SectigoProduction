public class Service{
    
    public static String shortenID(String idValue) {
        String[] keys = idValue.left(15).split('');
        while(keys.size() > 5 && keys[5] == '0') {
            keys.remove(5);
        }
        return String.join(keys,'');
    }

    public static String getThreadId(Id caseId) {
        return 'ref:_' + shortenId(UserInfo.getOrganizationId()) +
            '._'    + shortenId(caseId) +  ':ref';
    }
    
    public static String formatCaseComment(String htmlString){//format the content we are recieving from Email
        if(String.isBlank(htmlString)){
            return htmlString;
        }
        String finalHtmlString = htmlString;        
        Map<String, String> removeContent = new Map<String, String>();
        removeContent.put('<div class="gmail_extra"', '');
        removeContent.put('<div style="display:none">*****Write After this Line*****</div>', '');
        removeContent.put('<img src="" ', '</img>');
        String x = '';
        do{
            for(String startString : removeContent.keyset()){
                String endString = removeContent.get(startString);
                if(String.isNotBlank(htmlString) && htmlString.indexOf(startString)!=-1 && (String.isEmpty(endString) || htmlString.indexOf(endString)!=-1)){
                    Integer startIndex = htmlString.indexOf(startString);
                    finalHtmlString = htmlString.subString(0, startIndex);
                    Integer endIndex = 0;
                    if(String.isNotEmpty(endString)){
                        endIndex = htmlString.indexOf(endString)+(endString.indexOf('</img>')!=-1?endString.length():0);
                        finalHtmlString += htmlString.subString(endIndex, htmlString.length());
                    }
                }
                htmlString = finalHtmlString;
            }
        }while(htmlString.indexOf('<img src="" ')!=-1);
        
        
        if(finalHtmlString.length()>32000){
         finalHtmlString=finalHtmlString.substring(0,31999);
        }
                
        return finalHtmlString;
    } 

}