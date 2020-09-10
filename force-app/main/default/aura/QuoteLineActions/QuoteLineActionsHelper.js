({
    navigateToURL : function( url ) {
        
        return $A.get( "e.force:navigateToURL" ).setParams(
            {
                "url" : url
            }
        );
        
    },
    
    editLines : function( cmp, evt, helper ) {
        
        let editLinesPage = `${ cmp.get( "v.editLinesPage" ) }${ cmp.get( "v.recordId" ) }`;
        
        this.navigateToURL( editLinesPage ).fire();
        
    }
})