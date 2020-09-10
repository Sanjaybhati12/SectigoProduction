({
    navigateToURL : function( url ) {
        
        return $A.get( "e.force:navigateToURL" ).setParams(
            {
                "url" : url
            }
        );
        
    },
	
    generateDocument : function( cmp, evt, helper ) {
        
        let genDocPage = `${ cmp.get( "v.genDocPage" ) }${ cmp.get( "v.recordId" ) }`;
        
        this.navigateToURL( genDocPage ).fire();
        
    },
	
    previewDocument : function( cmp, evt, helper ) {

        let prevDocPage = `${ cmp.get( "v.prevDocPage" ) }${ cmp.get( "v.recordId" ) }`;
        
        this.navigateToURL( prevDocPage ).fire();
        
    }
})