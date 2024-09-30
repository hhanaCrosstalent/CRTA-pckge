({
    periodCalculHelper: function(component) {
        let action = component.get("c.calculDates");
        action.setParams({ recordId: component.get("v.recordId") });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                if (returnValue !== '1') { // '1' indique une opération réussie sans erreurs
                    // Affiche un toast d'erreur avec le message retourné par l'Apex
                    this.showToast("Erreur", returnValue, "error", component);
                } else {
                    // Affiche un toast de succès si le retour est '1'
                    this.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.Calculations_Done'), "success", component);
                    $A.get('e.force:refreshView').fire();
                }
            } else if (state === "ERROR") {
                // Gère les erreurs systèmes ou les exceptions non attrapées
                let errors = response.getError();
                let message = "Erreur inconnue"; // Message par défaut
                if (errors && errors[0] && errors[0].message) {
                    message = errors[0].message;
                }
                // Affiche un toast d'erreur avec le message système
                this.showToast("Erreur", message, "error", component);
            }
        });

        $A.enqueueAction(action);
    },

    showToast: function(title, message, type, component) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type,
            mode: 'dismissible',
            duration: '15000'
        });
        toastEvent.fire();
    }
})