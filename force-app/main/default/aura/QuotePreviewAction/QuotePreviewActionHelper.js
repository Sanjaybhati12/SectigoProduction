({
    navigateToURL : function( url ) {
        
        return $A.get( "e.force:navigateToURL" ).setParams(
            {
                "url" : url
            }
        );
        
    },
	
	
    previewDocument : function( cmp, evt, helper ) {

        let prevDocPage = `${ cmp.get( "v.prevDocPage" ) }${ cmp.get( "v.recordId" ) }`;
        
        this.navigateToURL( prevDocPage ).fire();
        
    }
})