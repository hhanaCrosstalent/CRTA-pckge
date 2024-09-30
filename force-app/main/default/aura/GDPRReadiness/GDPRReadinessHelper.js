({
	save : function(component, helper, button) {
		const a = component.get('c.save');
		a.setParams({button: button});
		a.setCallback(this, function (r) {
			if (r.getState() === 'SUCCESS') {
				helper.showToast('success', 'Enregistrement', 'Enregistré avec succès.');
			} else {
				helper.showToast('error', 'Enregistrement', 'L\'enregistrement a échoué.');
			}
		});
		$A.enqueueAction(a);
	},
	showToast: function (type, title, message) {
		let toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	}
})