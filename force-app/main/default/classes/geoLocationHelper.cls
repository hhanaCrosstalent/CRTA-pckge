//Security isCreateable() isUpdateable() isDeletable() checked
/**
* Helper class to convert an address to a set of coordinates
* @author Crosstalent
* @group Divers
*getContactLocation & getJobOfferLocation commented By Hana.H on 21/05/24 to prevent prevent API requests limits (in org) from being exceeded
* @version 1.3
*/
public with sharing class geoLocationHelper {
    /**
* Updates a set of contacts to add their corresponding coordinates
* @param offerIds Ids of the contacts to update
*/
    /*@future(callout=true)  // future method needed to run callouts from Triggers
    public static void getContactLocation(Set<Id> contactIds){
        List<Contact> contacts = [SELECT MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet, Location__Latitude__s, Location__Longitude__s 
                                  FROM Contact 
                                  WHERE Id IN: contactIds];
        String apiKey = Geolocation__c.getInstance().API_key__c;
        
        if(contacts.size() + Limits.getDMLRows() > Limits.getLimitDMLRows()) {
            System.debug('Need to stop processing to avoid hitting a governor limit. Too many related contacts to update in this trigger');
            System.debug('Trying to update ' + contacts.size() + ' opportunities but governor limits will only allow ' + Limits.getLimitDMLRows());
            for (Contact c : contacts) {
                c.addError('You are attempting to update the addresses of too many contacts at once. Please try again with fewer contacts.');
            }
        } else {
            System.debug('Continue processing. Not going to hit DML governor limits');
            System.debug('Going to update ' + contacts.size() + ' contacts and governor limits will allow ' + Limits.getLimitDMLRows());
            for(Contact c: contacts) {
                // create an address string
                String address = '';
                String street = '';
                
                // create an address string
                if(c.MailingCity != null ) {
                    if(c.MailingCountry != null) {
                        if(c.MailingCountry =='France') {
                            address += 'CountryRegion=FR';
                        } else { 
                            address += 'CountryRegion=' + c.MailingCountry;
                        }
                    } else {
                        address += 'CountryRegion=FR'; // Si le pays n'est pas fournis, c'est la France
                    }
                    if(c.MailingPostalCode != null) {
                        address += '&postalcode=' + c.MailingPostalCode;
                    }
                    if(c.MailingCity != null) {
                        Address += '&locality=' + c.MailingCity;
                    }
                    if(c.MailingStreet != null) {
                        // Bing has some issues:
                        //     1. It wants %20 instead of spaces
                        //     2. It won't geocode PO Boxes to the city - so remove them
                        //     3. It doesn't like the # symbol in the address so remove them
                        //     4. It won't process an address than ends in a period
                        street = c.MailingStreet;
                        street = street.toUpperCase();
                        street = street.replace('P.O. BOX', '');
                        
                        street = street.replace('#', '');
                        
                        // Bing has problems with addresses that end in periods, so just remove them
                        if(street.endsWith('.') == true ) {
                            street = street.removeEnd('.');
                        }
                        address += '&addressLine=' + c.MailingStreet;
                    } // Street
                    
                    // remove any line breaks and space
                    address = address.replace('\n',' ');
                    address = address.replace('\r',' ');
                    address = address.replace(' ', '%20');
                    
                    // parse coordinates from response
                    JSONParser parser = getGeolocRequest(address, apiKey);
                    System.debug('Parser : '+parser);
                    Double lat = null;
                    Double lon = null;
                    while(parser.nextToken() != null) {
                        if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'coordinates')) {
                            // skip to the [
                            parser.nextToken();
                            // now get the first value
                            parser.nextToken(); 
                            c.Location__Latitude__s = parser.getDoubleValue();
                            // now get the 2nd value
                            parser.nextToken();
                            c.Location__Longitude__s = parser.getDoubleValue();
                        }
                    }
                }
            }
            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.Location__Latitude__s.isUpdateable()
                && Schema.sObjectType.Contact.fields.Location__Longitude__s.isUpdateable()
            ) {
                Database.SaveResult[] srList = Database.update(contacts, false);
                for(Database.SaveResult sr : srList) {
                    if(!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following geolocation error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Contact fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            } else {
                System.debug(System.Label.Permission);
            }
        }
    }*/
    
    /**
* Updates a set of job offers to add their corresponding coordinates
* @param offerIds Ids of the job offers to update
*/
    /*@future(callout=true)  // future method needed to run callouts from Triggers
    public static void getJobOfferLocation(Set<Id> offerIds){
        List<Offre_d_emploi__c> offers = [SELECT CT_Country__c, CT_Postal_code__c, CT_City__c, Location__Latitude__s, Location__Longitude__s 
                                          FROM Offre_d_emploi__c 
                                          WHERE Id =: offerIds];
        String apiKey = Geolocation__c.getInstance().API_key__c;
        System.debug('apiKey ' + apiKey);
        
        if (offers.size() + Limits.getDMLRows() > Limits.getLimitDMLRows()) {
            System.debug('Need to stop processing to avoid hitting a governor limit. Too many related offers to update in this trigger');
            System.debug('Trying to update ' + offers.size() + ' opportunities but governor limits will only allow ' + Limits.getLimitDMLRows());
            for(Offre_d_emploi__c o : offers) {
                o.addError('You are attempting to update the addresses of too many offers at once. Please try again with fewer offers.');
            }
        } else {
            System.debug('Continue processing. Not going to hit DML governor limits');
            System.debug('Going to update ' + offers.size() + ' offers and governor limits will allow ' + Limits.getLimitDMLRows());
            for(Offre_d_emploi__c o: offers) {
                // create an address string
                String address = '';
                // create an address string
                if(o.CT_Country__c != null && o.CT_Country__c !='France'  ) {
                    address += 'CountryRegion=' + o.CT_Country__c;
                } else {
                    address += 'CountryRegion=FR' ;
                }
                if(o.CT_Postal_code__c != null) {
                    address += '&postalcode=' + o.CT_Postal_code__c;
                }
                if(o.CT_City__c != null) {
                    address += '&locality=' + o.CT_City__c;
                }
                
                // remove any line breaks
                address = address.replace('\n',' ');
                address = address.replace('\r',' ');
                address = address.replace(' ','%20');
                
                // parse coordinates from response
                JSONParser parser = getGeolocRequest(address, apiKey);
                Double lat = null;
                Double lon = null;
                while(parser.nextToken() != null) {
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'coordinates')) {
                        // skip to the [
                        parser.nextToken();
                        // now get the first value
                        parser.nextToken(); 
                        o.Location__Latitude__s = parser.getDoubleValue();
                        // now get the 2nd value
                        parser.nextToken();
                        o.Location__Longitude__s = parser.getDoubleValue();
                    }
                }
            }
            
            if (
                Schema.sObjectType.Contact.isUpdateable()
                && Schema.sObjectType.Contact.fields.Location__Latitude__s.isUpdateable()
                && Schema.sObjectType.Contact.fields.Location__Longitude__s.isUpdateable()
            ) {
                Database.SaveResult[] srList = Database.update(offers, false);
                for(Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following geolocation error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Job offer fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            } else {
                System.debug(System.Label.Permission);
            }
        }
    }*/
    
    /**
* Queries bing map api to retrieves coordinates from an address
* @see https://msdn.microsoft.com/en-us/library/ff701714.aspx For the format
* 
* @param  String address       Fully formated address
* @param  String apiKey         Api key for Bing map
* 
* @return JSONParser              Parsed response json
*/
    /*public static JSONParser getGeolocRequest(String address, String apiKey) {
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dev.virtualearth.net/REST/v1/Locations?'+ address + '&key=' + apiKey) ; // + '&maxResults=1');
		req.setMethod('GET');
        req.setTimeout(100000);
        
        try{
            // callout
            System.debug('req ' + req);
            HttpResponse res = h.send(req);
            
            // parse coordinates from response
            System.debug('res ' + res);
            System.debug('res ' + res.getBody());
            return JSON.createParser(res.getBody());
        } catch (Exception e) {
            System.debug(e);
            String geoCodeResponse = '{"authenticationResultCode":"ValidCredentials","brandLogoUri":"logo_powered_by.png","copyright":"Copyright &copy; 2013 Microsoft and its suppliers. All rights reserved. This API cannot be accessed and the content and any results may not be used, reproduced or transmitted in any manner without express written permission from Microsoft Corporation.","resourceSets":[{"estimatedTotal":1,"resources":[{"__type":"Location:/v1","bbox":[48.865196228027344,2.1537489891052246,48.901958465576172,2.1990370750427246],"name":"Rueil-Malmaison, Hauts-de-Seine, France","point":{"type":"Point","coordinates":[48.890399932861328,2.1731500625610352]},"address":{"adminDistrict":"IdF","adminDistrict2":"Hauts-de-Seine","countryRegion":"France","formattedAddress":"Rueil-Malmaison, Hauts-de-Seine, France","locality":"Rueil-Malmaison"},"confidence":"High","entityType":"PopulatedPlace","geocodePoints":[{"type":"Point","coordinates":[48.890399932861328,2.1731500625610352],"calculationMethod":"Rooftop","usageTypes":["Display"]}],"matchCodes":["Good"]}]}],"statusCode":200,"statusDescription":"OK","traceId":"90bf543f7b0c4a5cb5e56065c00fed00|BL2M000063|02.00.183.2300|BL2MSNVM001814, BL2MSNVM002805, BL2IPEVM000085, 68.76, BL2MSNVM001294"}' ; 
            return JSON.createParser(geoCodeResponse);
        }
    }*/
}