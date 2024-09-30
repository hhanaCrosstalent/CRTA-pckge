({
    doInit : function(component) {
        let label = component.get("v.titleLink");
        component.set('v.titleLinkInitial', label);
  if (label.length > 19) {
    let text = label.slice(0, 19) + '...';
      component.set("v.titleLink", text);
      component.set("v.labelTrancated",true);
  }
        
        let customLabel = $A.getReference('$Label.c.'+label);
        component.set("v.titleLinkTmp", customLabel);
        if (component.get('v.link').includes('lightning')) {
            component.set('v.inSalesforce', true);
        } else {
            component.set('v.inSalesforce', false);
        }
        /*window.setTimeout(
            $A.getCallback(function() {
                if(component.get("v.titleLinkTmp") != undefined) {
                    if(!component.get("v.titleLinkTmp").startsWith('$')) {
                    component.set("v.titleLink", customLabel);
                	}
                }
            }), 2000
        );*/
    },
    openLink: function (component) {
        window.open(component.get("v.link"), '_blank');
    }
    //$Label.c.Label
    //$Label.c.Link
    //$Label.c.Icon
    //$Label.c.Icon_Description
    //$Label.c.Text_Color
    //$Label.c.Icons_Color
    //$Label.c.Background_Color
})