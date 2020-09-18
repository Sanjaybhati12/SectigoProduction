({
    MAX_FILE_SIZE: 4500000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 950000, /* Use a multiple of 4 */
    
    save: function (component,event,helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        console.log('file=============='+JSON.stringify(file.name));
        console.log('file=============='+JSON.stringify(file));
        
        component.set("v.fileName", file.name);
        if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file.size);
            return;
        }
        
        var fr = new FileReader();
        
        var self = this;
        fr.onload = function () {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
            self.upload(component,event,helper, file, fileContents);
        };
        
        fr.readAsDataURL(file);
    },
    upload: function (component,event,helper, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        
        // start with the initial chunk
        this.uploadChunk(component,event,helper, file, fileContents, fromPos, toPos, '');
    },
    uploadChunk: function (component,event,helper, file, fileContents, fromPos, toPos, attachId) {
        console.log('uploadChunk');
        var action = component.get("c.saveTheChunk");
        var chunk = fileContents.substring(fromPos, toPos);
        
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk),
            contentType: file.type,
            fileId: attachId
        });
        
        var self = this;
        action.setCallback(this, function (a) {
            
            console.log('uploadChunk: Callback');
            attachId = a.getReturnValue();
            
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
            
            if (fromPos < toPos) {
                self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);
            } else {
                this.getContacts(component,event,helper);
                console.log('uploadChunk: done');
                
                self.showToast('Upload Complete', 'You file has successfully uploaded, please upload another now.', 'success', null);
                self.getcontentDocId(attachId,component);
            }
        });
        
        $A.getCallback(function () {
            $A.enqueueAction(action);
        })();
    },
    showToast: function (title, message, type, icon) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: '2000',
            key: icon,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    getcontentDocId: function (contentversionId,component) {
        
        var recID = component.get("v.recordId");
        //var   recID='0011N00001RqYUCQA3';
        var action = component.get("c.getContentversion");
        action.setParams({
            contentversionId: contentversionId,
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            console.log(JSON.stringify(data));
            
            if(  data.length>0){
                component.set("v.fileName", data.PathOnClient );
                component.set("v.contentDocLinkId", data.ContentDocumentId );
                //component.set("v.uploadButtonShowHide", false);
                
            }
            console.log('line 106 ',JSON.stringify(data) );
            var contList = component.get("v.contentDocumentList");
            var obj={
                "name": data.PathOnClient.replace('/',''),
                "contentDocLinkId": data.ContentDocumentId
            }
            contList.push(obj);console.log('obj',JSON.stringify(obj) );
            component.set("v.contentDocumentList", contList );
            // console.log(JSON.stringify(data));
        });
        $A.enqueueAction(action);
    },
    getContacts:function(component,event,helper){
        var recID = component.get("v.recordId");
        
        var action = component.get("c.getAccountContacts");
        action.setParams({
            recordId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            console.log(JSON.stringify(data));
            console.log(data!=null);
            if(data!=null){
                if(data.contactList!=null){
                    component.set("v.contactList", data.contactList);
                    
                }
                component.set("v.onBOardDate", data.contactList[0].Account.CreatedDate );
                component.set("v.portalAccessDate", data.portalAccessDate);
                component.set("v.serviceAccManager", data.contactList[0].Account.Service_Account_Manager__r.Name);
                component.set("v.totalPrimerAmount", data.totalQuoteAmount);
                component.set("v.isEnterprisePreimer", data.contactList[0].Account.Enterprise_Premier__c);
                
                function isEmpty(obj) {
                    for(var key in obj) {
                        if(obj.hasOwnProperty(key))
                            return false;
                    }
                    return true;
                }
                
                var myObj = data.cv; // Empty Object
                if(  !isEmpty(myObj)){
                    var tempList;
                    tempList = Object.entries(myObj);
                    var list = [];
                    tempList.forEach(([key, value]) => {
                        let name=value.PathOnClient;
                        var obj={
                        "name": name.substr(1, name.length),
                        "contentDocLinkId": value.ContentDocumentId
                    }
                                     list.push(obj);
                });
                console.log(JSON.stringify(list));
                component.set("v.contentDocumentList", list );
                /*let name=data.cv.PathOnClient;
                    if(name){
                        component.set("v.fileName", name.substr(1, name.length));
                    }
                    
                    component.set("v.contentDocLinkId", data.cv.ContentDocumentId );
                    //component.set("v.uploadButtonShowHide", false);*/
            }
        }
                           
                           // console.log(JSON.stringify(data));
                           });
        $A.enqueueAction(action);
    },
   
})