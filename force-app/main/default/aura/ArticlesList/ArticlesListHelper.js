({
    getArticles : function(component) {
        let action = component.get("c.getArticlesList");
        let articleType = component.get('v.articleType');
        if(!!action) {
            action.setParams({
                "limiter": component.get('v.limiter'),
                "articleType": articleType
            });
            action.setCallback(this, function(r) {
                let state = r.getState();
                let limiter = [];
                if (state == 'SUCCESS') {
                    let res = r.getReturnValue();
                    if(articleType == 'Media') {
                        for (let i = 0; i < res.length; i++) {
                            if (i >= component.get('v.limiter'))
                                break; 
                            res[i].isSee = false;
                            limiter.push(res[i]); 
                        }
                    } else {
                        let reslimit = [];
                        for (let i = 0; i < res.length; i++){
                            if (res[i].crta__Start_Time__c != '' && res[i].crta__Start_Time__c != undefined)
                                res[i].crta__Start_Time__c = this.convertTime(res[i].crta__Start_Time__c);
                            
                            if (res[i].crta__End_Time__c != '' && res[i].crta__End_Time__c != undefined)
                                res[i].crta__End_Time__c = this.convertTime(res[i].crta__End_Time__c);
                            
                            if (res[i].crta__Date_de_publication__c != '' && res[i].crta__Date_de_publication__c != undefined)
                                res[i].crta__Date_de_publication__c = this.getSinceDays(res[i].crta__Date_de_publication__c);

                            if(articleType != 'Archives') {
                                if (i <= res.length)
                                    reslimit.push(res[i]);
                            }
                            else {
                                reslimit = res;
                            }
                        }
                        limiter = reslimit;
                    }
                    component.set("v.listArticles", limiter);
                } else {
                    let errs = r.getError();
                    for (let i = 0; i < errs.length; i++) {
                        console.error('Error loading article list: ' + errs[i].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    getDayName: function(date) {
        let dayNames = ["Lun.", "Mar.","Mer.","Jeu.","Ven.","Sam.","Dim."];
        let d = new Date($A.localizationService.formatDate(date, "MM/DD/YYYY"));
        let currDay = dayNames[d.getDay() - 1];
        
        return currDay;
    },

    getDate: function(date) {
        let d = new Date($A.localizationService.formatDate(date, "MM/DD/YYYY"));
        let dayDate = d.getDate();
        
        return dayDate;  
    },

    getMonthName: function(date) {
        let monthNames = ["jan.", "févr.", "mars", "avr.", "mai.", "juin",
          "juil.", "août", "sept.", "oct.", "nov.", "déc."];
        let d = new Date($A.localizationService.formatDate(date, "MM/DD/YYYY"));
        let currMonth = monthNames[d.getMonth()];
        
        return currMonth;
    },

    setDayFormat : function(currDate, type) {
        if (type != 'Event')
            return currDate;

        currDate = this.getDayName(currDate) + ' ' + this.getDate(currDate) + ' ' + this.getMonthName(currDate);
        return currDate;
    },

    getSinceDays : function(currDate) {
        let day, hour, minute, seconds;
        let day1 = new Date();
        let day2 = $A.localizationService.formatDate(currDate, "YYYY/MM/DD");
        day2 = new Date(day2);
        let diff = Math.abs(day1 - day2);
        seconds = Math.floor(diff / 1000);
        minute = Math.floor(seconds / 60);
        seconds = seconds % 60;
        hour = Math.floor(minute / 60);
        minute = minute % 60;
        day = Math.floor(hour / 24);
        
        if(day == 1) {
            currDate = $A.get('$Label.c.Yesterday');
        } else if (day > 1) {
            currDate = this.formatCustomLabel($A.get('$Label.c.Days_Ago'), day);
        } else {
            currDate = $A.get('$Label.c.Today');
        }
        return currDate;
    },

    convertTime : function(millisec) {
        let seconds = (millisec / 1000).toFixed(0);
        let minutes = Math.floor(seconds / 60);
        let hours = "";
        if (minutes > 59) {
            hours = Math.floor(minutes / 60);
            hours = (hours >= 10) ? hours : "0" + hours;
            minutes = minutes - (hours * 60);
            minutes = (minutes >= 10) ? minutes : "0" + minutes;
        }

        seconds = Math.floor(seconds % 60);
        seconds = (seconds >= 10) ? seconds : "0" + seconds;
        if (hours != "") {
            return hours + ":" + minutes;
        }
        return minutes;
    },

    formatCustomLabel: function (string, param) {
        return string.replace(/\{(\d+)\}/g, param); 
    }, 
})