/**
 * @CtEngineV2Test.cls
 *
 * CtEngineV2 class test
 * @author Abdelkader Morjan 
 *HrFlow Connecteur @version 1.2 2021/08/07
 */
@IsTest
private class CtEngineV2Test {
/*
    @IsTest
    private static void insertAllFresh() {

        WebServiceObjects.Fields fields = new WebServiceObjects.Fields();
        fields.road = 'Rue de Paris';
        fields.state = 'Ile-de-France';
        fields.city_district = 'Quartier des roses';
        fields.state_district = 'Essonne';
        fields.postcode = '75012';
        fields.country = 'FRA';
        fields.city = 'Saclay';
        fields.text = 'Rue de Paris, 91400 Saclay, France';

        WebServiceObjects.Location myLocation = new WebServiceObjects.Location();
        myLocation.text = 'Paris Saclay';
        myLocation.lat = 48.737380000000002;
        myLocation.lng = 2.1785600000000001;
        myLocation.fields = fields;
        
        WebServiceObjects.Url u0 = new WebServiceObjects.Url();
        u0.type = 'facebook';
        u0.url = new String[] {'myfacebookMorjan'};
        WebServiceObjects.Url u1 = new WebServiceObjects.Url();
        u1.type = 'twitter';
        u1.url = new String[] {'twitterMorjan'};
        WebServiceObjects.Url u2 = new WebServiceObjects.Url();
        u2.type = 'github';
        u2.url = new String[] {'gitMorjan'};
        WebServiceObjects.Url u3 = new WebServiceObjects.Url();
        u3.type = 'linkedin';
        u3.url = new String[] {'myLinkedInMorjan'};
        WebServiceObjects.Url u4 = new WebServiceObjects.Url();
        u4.type = 'from_resume';
        u4.url = new String[] {'my Resume is very Good '};
        List<WebServiceObjects.Url> urls = new List<WebServiceObjects.Url>{u0, u1, u2, u3, u4};

        WebServiceObjects.Owner consentOwner = new WebServiceObjects.Owner();
        consentOwner.embedding = true;
        consentOwner.parsing = true;
        consentOwner.reasoning = true;
        consentOwner.revealing = true;
        consentOwner.scoring = true;
        consentOwner.searching = true;
        WebServiceObjects.Controller consentController = new WebServiceObjects.Controller();
        consentController.embedding = true;
        consentController.parsing = true;
        consentController.reasoning = true;
        consentController.revealing = true;
        consentController.scoring = true;
        consentController.searching = true;
        WebServiceObjects.ConsentAlgorithmic consentAlgorithmic = new WebServiceObjects.ConsentAlgorithmic();
        consentAlgorithmic.controller = consentController;
        consentAlgorithmic.owner = consentOwner;

        WebServiceObjects.Source mySource = new WebServiceObjects.Source();
        mySource.id = 'Python';
        mySource.name = 'AlerteEmploi';
        mySource.subtype = 'Python';
        mySource.type = 'API';

        WebServiceObjects.Info myInfo = new WebServiceObjects.Info();
        myInfo.first_name = 'Dorian';
        myInfo.last_name = 'Maier';
        myInfo.gender = 'M';
        myInfo.phone = '064598254';
        myInfo.summary = 'Je suis en test';
        myInfo.location = myLocation;
        myInfo.email = 'theodor@example.com';
        myInfo.urls = urls;

        WebServiceObjects.Education myEducations0 = new WebServiceObjects.Education();
        myEducations0.key = 'Master1';
        myEducations0.title = 'Master1';
        myEducations0.school = 'ENS';
        myEducations0.description = 'My diploma';
        myEducations0.date_start = Date.newInstance(2016, 9, 22);
        myEducations0.date_end = Date.newInstance(2018, 9, 22);
        WebServiceObjects.Pair hardSkills = new WebServiceObjects.Pair();
        hardSkills.name = 'tinker';
        hardSkills.value = 'very much so';
        myEducations0.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myEducations0.soft_skills = null;
        myEducations0.location = myLocation;
        WebServiceObjects.Education myEducations1 = new WebServiceObjects.Education();
        myEducations1.key = 'Master2';
        myEducations1.title = 'Master2';
        myEducations1.school = 'Plytechnique X';
        myEducations1.description = 'So Prood';
        myEducations1.date_start = Date.newInstance(2018, 9, 22);
        myEducations1.date_end = Date.newInstance(2019, 9, 22);
        myEducations1.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myEducations1.soft_skills = null;
        myEducations1.location = myLocation;
        List<WebServiceObjects.Education> myEducations = new List<WebServiceObjects.Education>{myEducations0, myEducations1};

        WebServiceObjects.Experience myExperiences0 = new WebServiceObjects.Experience();
        myExperiences0.key = 'Hfa54';
        myExperiences0.title = 'Chef de Projet';
        myExperiences0.company = 'Crosstalent';
        myExperiences0.description = 'Très belle expérience';
        myExperiences0.date_start = Date.newInstance(2011, 9, 22);
        myExperiences0.date_end = Date.newInstance(2015, 9, 22);
        myExperiences0.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myExperiences0.soft_skills = null;
        myExperiences0.location = myLocation;
        WebServiceObjects.Experience myExperiences1 = new WebServiceObjects.Experience();
        myExperiences1.key = 'Hfa54';
        myExperiences1.title = 'Directeur de Projets';
        myExperiences1.company = 'Crosstalent';
        myExperiences1.description = 'Très belle expérience';
        myExperiences1.date_start = Date.newInstance(2015, 9, 22);
        myExperiences1.date_end = Date.newInstance(2019, 9, 22);
        myExperiences1.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myExperiences1.soft_skills = null;
        myExperiences1.location = myLocation;
        List<WebServiceObjects.Experience> myExperiences = new List<WebServiceObjects.Experience>{myExperiences0, myExperiences1};

        WebServiceObjects.Attachment myAttachments0 = new WebServiceObjects.Attachment();
        myAttachments0.alt = 'my cv';
        myAttachments0.extension = 'pdf';
        myAttachments0.file_name = 'myCV';
        myAttachments0.file_size = 512;
        myAttachments0.original_file_name = 'myCVGood';
        myAttachments0.public_url = 'http://oryxc.com';
        myAttachments0.type = 'original';
        WebServiceObjects.Attachment myAttachments1 = new WebServiceObjects.Attachment();
        myAttachments1.alt = 'my cv';
        myAttachments1.extension = 'doc';
        myAttachments1.file_name = 'myCVProfile';
        myAttachments1.file_size = 512;
        myAttachments1.original_file_name = 'ProfileCV';
        myAttachments1.public_url = 'http://ct.com';
        myAttachments1.type = 'original';
        List<WebServiceObjects.Attachment> myAttachments = new List<WebServiceObjects.Attachment>{myAttachments0, myAttachments1};

        WebServiceObjects.Skill mySkills0 = new WebServiceObjects.Skill();
        mySkills0.type = 'hard';
        mySkills0.name = 'Travel';
        mySkills0.value = 'Senior';
        WebServiceObjects.Skill mySkills1 = new WebServiceObjects.Skill();
        mySkills1.type = 'hard';
        mySkills1.name = 'Python';
        mySkills1.value = 'Senior';
        List<WebServiceObjects.Skill> mySkills = new List<WebServiceObjects.Skill>{mySkills0, mySkills1};

        WebServiceObjects.Language myLanguages0 = new WebServiceObjects.Language();
        myLanguages0.name = 'German';
        myLanguages0.value = null;
        WebServiceObjects.Language myLanguages1 = new WebServiceObjects.Language();
        myLanguages1.name = 'English';
        myLanguages1.value = null;
        List<WebServiceObjects.Language> myLanguages = new List<WebServiceObjects.Language>{myLanguages0, myLanguages1};

        WebServiceObjects.Interest myInterests0 = new WebServiceObjects.Interest();
        myInterests0.name = '54erzer';
        myInterests0.value = 'Lecture Scientifique';
        WebServiceObjects.Interest myInterests1 = new WebServiceObjects.Interest();
        myInterests1.name = '54qs';
        myInterests1.value = 'Football';
        List<WebServiceObjects.Interest> myInterests = new List<WebServiceObjects.Interest>{myInterests0, myInterests1};

        WebServiceObjects.Label myLabels0 = new WebServiceObjects.Label();
        myLabels0.job_key = '45RT';
        myLabels0.stage = 'yes';
        WebServiceObjects.Label myLabels1 = new WebServiceObjects.Label();
        myLabels1.job_key = 'JobKey2';
        myLabels1.stage = 'yes';
        List<WebServiceObjects.Label> myLabels = new List<WebServiceObjects.Label>{myLabels0, myLabels1};

        WebServiceObjects.Tag myTag0 = new WebServiceObjects.Tag();
        myTag0.name = 'Hgy54';
        myTag0.value = 'referrer1';
        WebServiceObjects.Tag myTag1 = new WebServiceObjects.Tag();
        myTag1.name = 'TR4';
        myTag1.value = 'referrer2';
        List<WebServiceObjects.Tag> myTags = new List<WebServiceObjects.Tag>{myTag0, myTag1};

        WebServiceObjects.Metadata metadata0 = new WebServiceObjects.Metadata();
        metadata0.name = 'personal-email';
        metadata0.value = 'harry.potter@gmail.com';
        WebServiceObjects.Metadata metadata1 = new WebServiceObjects.Metadata();
        metadata1.name = '54sd';
        metadata1.value = '5';
        List<WebServiceObjects.Metadata> myMetadata = new List<WebServiceObjects.Metadata>{metadata0, metadata1};
        
        Master myMaster = new Master();
        myMaster.id = 'IIUV5454';
        myMaster.key = 'DECE785';
        myMaster.reference = 'kjkzeze575';
        myMaster.educations_duration = 5;
        myMaster.experiences_duration = 6l;
        myMaster.text = 'Mise à jour : 01';
        myMaster.text_language = 'France';
        myMaster.archive = Date.newInstance(1970, 1, 1);
        myMaster.consent_algorithmic = consentAlgorithmic;
        myMaster.source = mySource;
        myMaster.info = myInfo;
        myMaster.educations = myEducations;
        myMaster.experiences = myExperiences;
        myMaster.attachments = myAttachments;
        myMaster.skills = mySkills;
        myMaster.languages = myLanguages;
        myMaster.interests = myInterests;
        myMaster.labels = myLabels;
        myMaster.tags = myTags;
        myMaster.metadatas = myMetadata;

        Test.startTest();
        CtEngine engine = new CtEngine();
        Integer result = engine.upsertProfile(myMaster);
        Test.stopTest();

        List<Contact> contacts = [SELECT Id FROM Contact];
        List<crta__Diploma__c> diplomas = [SELECT Id FROM crta__Diploma__c];
        List<Experience__c> experiences = [SELECT Id FROM Experience__c];
        List<Attachment__c> attachments = [SELECT Id FROM Attachment__c];
        List<crta__Skill__c> skills = [SELECT Id FROM crta__Skill__c];
        List<crta__Contact_Skill_Profile_Line__c> skillLines = [SELECT Id FROM crta__Contact_Skill_Profile_Line__c];
        List<Language__c> languages = [SELECT Id FROM Language__c];
        List<Interest__c> interests = [SELECT Id FROM Interest__c];
        List<Tag__c> tags = [SELECT Id FROM Tag__c];
        List<Metadata__c> metadata = [SELECT Id FROM Metadata__c];
        List<PartyConsent> partyconsents = [SELECT Id FROM PartyConsent];

        System.assertEquals(2, contacts.size(), 'We have to find one existing and one new Contact.');
        System.assertEquals(3, diplomas.size(), 'We have to find 1 old and 2 new diplomas.');
        System.assertEquals(3, experiences.size(), 'We have to find 1 old and 2 new experiences.');
        System.assertEquals(3, attachments.size(), 'We have 2 added attachments, 1 existed for another Contact, i.e. 3.');
        System.assertEquals(2, skills.size(), 'We have 1 existing skills, 2 incoming, 1 of them exists, i.e. 2.');
        System.assertEquals(3, skillLines.size(), 'We have 1 existing skill line for another Contact, 2 incoming, i.e. 3.');
        System.assertEquals(3, languages.size(), '2 incoming languages, 1 existing, i.e. 3');
        System.assertEquals(3, interests.size(), '2 incoming interests, 1 existed before for another Contact.');
        System.assertEquals(3, tags.size(), '2 incoming tags, 1 existed before for another Contact.');
        System.assertEquals(3, metadata.size(), '2 incoming metadata, 1 existed before for another Contact.');
        System.assertEquals(1, partyconsents.size(), 'There is a single partyconsent, because there is a single Contact.');
    }

    @IsTest
    private static void updateAll() {

        WebServiceObjects.Fields fields = new WebServiceObjects.Fields();
        fields.road = 'Rue de Paris';
        fields.state = 'Ile-de-France';
        fields.city_district = 'Quartier des roses';
        fields.state_district = 'Essonne';
        fields.postcode = '75012';
        fields.country = 'FRA';
        fields.city = 'Saclay';
        fields.text = 'Rue de Paris, 91400 Saclay, France';

        WebServiceObjects.Location myLocation = new WebServiceObjects.Location();
        myLocation.text = 'Paris';
        myLocation.lat = 48.1111111111;
        myLocation.lng = 2.222222222222222;
        myLocation.fields = fields;

        WebServiceObjects.Url u0 = new WebServiceObjects.Url();
        u0.type = 'facebook';
        u0.url = new String[] {'myfacebookMorjan'};
        WebServiceObjects.Url u1 = new WebServiceObjects.Url();
        u1.type = 'twitter';
        u1.url = new String[] {'twitterMorjan'};
        WebServiceObjects.Url u2 = new WebServiceObjects.Url();
        u2.type = 'github';
        u2.url = new String[] {'gitMorjan'};
        WebServiceObjects.Url u3 = new WebServiceObjects.Url();
        u3.type = 'linkedin';
        u3.url = new String[] {'myLinkedInMorjan'};
        WebServiceObjects.Url u4 = new WebServiceObjects.Url();
        u4.type = 'from_resume';
        u4.url = new String[] {'my Resume is very Good '};
        List<WebServiceObjects.Url> urls = new List<WebServiceObjects.Url>{u0, u1, u2, u3, u4};

        WebServiceObjects.Owner consentOwner = new WebServiceObjects.Owner();
        consentOwner.embedding = true;
        consentOwner.parsing = true;
        consentOwner.reasoning = true;
        consentOwner.revealing = true;
        consentOwner.scoring = true;
        consentOwner.searching = true;
        WebServiceObjects.Controller consentController = new WebServiceObjects.Controller();
        consentController.embedding = true;
        consentController.parsing = true;
        consentController.reasoning = true;
        consentController.revealing = true;
        consentController.scoring = true;
        consentController.searching = true;
        WebServiceObjects.ConsentAlgorithmic consentAlgorithmic = new WebServiceObjects.ConsentAlgorithmic();
        consentAlgorithmic.controller = consentController;
        consentAlgorithmic.owner = consentOwner;

        WebServiceObjects.Source mySource = new WebServiceObjects.Source();
        mySource.id = 'Python';
        mySource.name = 'AlerteEmploi';
        mySource.subtype = 'Python';
        mySource.type = 'API';

        WebServiceObjects.Info myInfo = new WebServiceObjects.Info();
        myInfo.first_name = 'Dorian';
        myInfo.last_name = 'Horkheimer';
        myInfo.gender = 'M';
        myInfo.phone = '064598254';
        myInfo.summary = 'Je suis en test';
        myInfo.location = myLocation;
        // existing email
        myInfo.email = 'theodor.w.adorno@example.com';
        myInfo.urls = urls;

        WebServiceObjects.Education myEducations0 = new WebServiceObjects.Education();
        myEducations0.key = 'Master1';
        myEducations0.title = 'diploma title';
        myEducations0.school = 'diploma school';
        myEducations0.description = 'My diploma';
        myEducations0.date_start = Date.newInstance(1970, 1, 1);
        myEducations0.date_end = Date.newInstance(2018, 9, 22);
        WebServiceObjects.Pair hardSkills = new WebServiceObjects.Pair();
        hardSkills.name = 'tinker';
        hardSkills.value = 'very much so';
        myEducations0.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myEducations0.soft_skills = null;
        myEducations0.location = myLocation;
        WebServiceObjects.Education myEducations1 = new WebServiceObjects.Education();
        myEducations1.key = 'Master2';
        myEducations1.title = 'Master2';
        myEducations1.school = 'Plytechnique X';
        myEducations1.description = 'So Prood';
        myEducations1.date_start = Date.newInstance(2018, 9, 22);
        myEducations1.date_end = Date.newInstance(2019, 9, 22);
        myEducations1.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myEducations1.soft_skills = null;
        myEducations1.location = myLocation;
        List<WebServiceObjects.Education> myEducations = new List<WebServiceObjects.Education>{myEducations0, myEducations1};

        WebServiceObjects.Experience myExperiences0 = new WebServiceObjects.Experience();
        myExperiences0.key = 'Hfa54';
        myExperiences0.title = 'Chef de Projet';
        myExperiences0.company = 'Crosstalent';
        myExperiences0.description = 'Très belle expérience';
        myExperiences0.date_start = Date.newInstance(2011, 9, 22);
        myExperiences0.date_end = Date.newInstance(2015, 9, 22);

        myExperiences0.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myExperiences0.soft_skills = null;
        myExperiences0.location = myLocation;
        WebServiceObjects.Experience myExperiences1 = new WebServiceObjects.Experience();
        myExperiences1.key = 'Hfa54';
        myExperiences1.title = 'experience title';
        myExperiences1.company = 'experience company';
        myExperiences1.description = 'Très belle expérience';
        myExperiences1.date_start = Date.newInstance(1970, 1, 1);
        myExperiences1.date_end = Date.newInstance(2019, 9, 22);
        myExperiences1.hard_skills = new List<WebServiceObjects.Pair>{hardSkills};
        myExperiences1.soft_skills = null;
        myExperiences1.location = myLocation;
        List<WebServiceObjects.Experience> myExperiences = new List<WebServiceObjects.Experience>{myExperiences0, myExperiences1};

        WebServiceObjects.Attachment myAttachments0 = new WebServiceObjects.Attachment();
        myAttachments0.alt = 'my cv';
        myAttachments0.extension = 'pdf';
        myAttachments0.file_name = 'myCV';
        myAttachments0.file_size = 512;
        myAttachments0.original_file_name = 'myCVGood';
        myAttachments0.public_url = 'http://oryxc.com';
        myAttachments0.type = 'original';
        WebServiceObjects.Attachment myAttachments1 = new WebServiceObjects.Attachment();
        myAttachments1.alt = 'my cv';
        myAttachments1.extension = 'doc';
        myAttachments1.file_name = 'myCVProfile';
        myAttachments1.file_size = 512;
        myAttachments1.original_file_name = 'ProfileCV';
        myAttachments1.public_url = 'http://ct.com';
        myAttachments1.type = 'original';
        List<WebServiceObjects.Attachment> myAttachments = new List<WebServiceObjects.Attachment>{myAttachments0, myAttachments1};

        WebServiceObjects.Skill mySkills0 = new WebServiceObjects.Skill();
        mySkills0.type = 'hard';
        mySkills0.name = 'Travel';
        mySkills0.value = 'Senior';
        WebServiceObjects.Skill mySkills1 = new WebServiceObjects.Skill();
        mySkills1.type = 'hard';
        mySkills1.name = 'Python';
        mySkills1.value = 'Senior';
        List<WebServiceObjects.Skill> mySkills = new List<WebServiceObjects.Skill>{mySkills0, mySkills1};

        WebServiceObjects.Language myLanguages0 = new WebServiceObjects.Language();
        myLanguages0.name = 'German';
        myLanguages0.value = null;
        WebServiceObjects.Language myLanguages1 = new WebServiceObjects.Language();
        myLanguages1.name = 'English';
        myLanguages1.value = null;
        List<WebServiceObjects.Language> myLanguages = new List<WebServiceObjects.Language>{myLanguages0, myLanguages1};

        WebServiceObjects.Interest myInterests0 = new WebServiceObjects.Interest();
        myInterests0.name = 'Lecture Scientifique';
        myInterests0.value = '5';
        WebServiceObjects.Interest myInterests1 = new WebServiceObjects.Interest();
        myInterests1.name = 'Football';
        myInterests1.value = '3';
        List<WebServiceObjects.Interest> myInterests = new List<WebServiceObjects.Interest>{myInterests0, myInterests1};

        WebServiceObjects.Label myLabels0 = new WebServiceObjects.Label();
        myLabels0.job_key = 'JobKey1';
        myLabels0.stage = 'yes';
        WebServiceObjects.Label myLabels1 = new WebServiceObjects.Label();
        myLabels1.job_key = 'JobKey2';
        myLabels1.stage = 'no';
        List<WebServiceObjects.Label> myLabels = new List<WebServiceObjects.Label>{myLabels0, myLabels1};

        WebServiceObjects.Tag myTag0 = new WebServiceObjects.Tag();
        myTag0.name = 'referrer1';
        myTag0.value = '5';
        WebServiceObjects.Tag myTag1 = new WebServiceObjects.Tag();
        myTag1.name = 'referrer2';
        myTag1.value = '7';
        List<WebServiceObjects.Tag> myTags = new List<WebServiceObjects.Tag>{myTag0, myTag1};

        WebServiceObjects.Metadata metadata0 = new WebServiceObjects.Metadata();
        metadata0.name = 'personal-email';
        metadata0.value = 'harry.potter@gmail.com';
        WebServiceObjects.Metadata metadata1 = new WebServiceObjects.Metadata();
        metadata1.name = '54sd';
        metadata1.value = '5';
        List<WebServiceObjects.Metadata> myMetadata = new List<WebServiceObjects.Metadata>{metadata0, metadata1};
        
        Master myMaster = new Master();
        myMaster.id = 'IIUV5454';
        myMaster.key = 'DECE785';
        myMaster.reference = 'kjkzeze575';
        myMaster.educations_duration = 5;
        myMaster.experiences_duration = 6l;
        myMaster.text = 'Mise à jour : 01';
        myMaster.text_language = 'France';
        myMaster.archive = Date.newInstance(1970, 1, 1);
        myMaster.consent_algorithmic = consentAlgorithmic;
        myMaster.source = mySource;
        myMaster.info = myInfo;
        myMaster.educations = myEducations;
        myMaster.experiences = myExperiences;
        myMaster.attachments = myAttachments;
        myMaster.skills = mySkills;
        myMaster.languages = myLanguages;
        myMaster.interests = myInterests;
        myMaster.labels = myLabels;
        myMaster.tags = myTags;
        myMaster.metadatas = myMetadata;

        Test.startTest();
        CtEngine engine = new CtEngine();
        Integer result = engine.upsertProfile(myMaster);
        Test.stopTest();

        List<Contact> contacts = [SELECT LastName FROM Contact];
        List<crta__Diploma__c> diplomas = [SELECT Id FROM crta__Diploma__c];
        List<Experience__c> experiences = [SELECT Id FROM Experience__c];
        List<Attachment__c> attachments = [SELECT Id FROM Attachment__c];
        List<crta__Skill__c> skills = [SELECT Id FROM crta__Skill__c];
        List<crta__Contact_Skill_Profile_Line__c> skillLines = [SELECT Id FROM crta__Contact_Skill_Profile_Line__c];
        List<Language__c> languages = [SELECT Id FROM Language__c];
        List<Interest__c> interests = [SELECT Id FROM Interest__c];
        List<Tag__c> tags = [SELECT Id FROM Tag__c];
        List<Metadata__c> metadata = [SELECT Id FROM Metadata__c];
        List<PartyConsent> partyconsents = [SELECT Id FROM PartyConsent];

        System.assertEquals(1, contacts.size(), 'There is only one Contact, because the email matches.');
        System.assertEquals('Horkheimer', contacts[0].LastName, 'The Contact LastName must have been updated.');
        System.assertEquals(2, diplomas.size(), '1 old diploma that is updated by an incoming, 1 new diploma that is inserted.');
        System.assertEquals(2, experiences.size(), '1 old experience that is updated by an incoming, 1 new experience that is inserted.');
        //System.assertEquals(2, attachments.size(), 'We have 1 deleted and 2 added attachments, i.e. 2.');
        System.assertEquals(2, skills.size(), 'We have 1 existing skills, 2 incoming, 1 of them exists, i.e. 2.');
        System.assertEquals(2, skillLines.size(), 'We have 1 existing skill line for the Contact, which is updated, another is new, i.e. 2.');
        System.assertEquals(2, languages.size(), '2 incoming languages, 1 existed before for this Contact, i.e. 2.');
        System.assertEquals(2, interests.size(), '2 incoming interests, 1 existed before for this Contact, but all are deleted before created.');
        System.assertEquals(2, tags.size(), '2 incoming tags, 1 existed before for this Contact, but all are deleted before created.');
        System.assertEquals(2, metadata.size(), '2 incoming metadata, 1 existed before for this Contact, but all are deleted before created.');
        System.assertEquals(1, partyconsents.size(), 'There is a single partyconsent, because there is a single Contact.');
    }

    @TestSetup
    private static void testSetup() {

        Individual indi = new Individual(
            LastName = 'HRFlow'
        );
        insert indi;

        Contact c = new Contact(
            Email = 'theodor.w.adorno@example.com',
            LastName = 'Adorno'
        );
        insert c;

        crta__Diploma__c d = new crta__Diploma__c(
            crta__Employee__c = c.Id,
            crta__School_Name__c = 'diploma school',
            crta__Title__c = 'diploma title',
            Date_start__c = Date.newInstance(1970, 1, 1),
            Soft_Skill__c = 'diploma soft'
        );
        insert d;

        Experience__c exp = new Experience__c(
            Company__c = 'experience company',
            Contact__c = c.Id,
            MailingCity__c = 'experience city',
            StartDate__c = Date.newInstance(1970, 1, 1),
            Title__c = 'experience title'
        );
        insert exp;

        crta__Positionnement__c cand = new crta__Positionnement__c(
            crta__CT_Candidate__c = c.Id,
            crta__CT_Status__c = '10 CV Received'
        );
        insert cand;
        Attachment__c att = new Attachment__c(
            Candidature__c = cand.Id,
            Name = 'attachment name'
        );
        insert att;

        crta__Skill__c sk = new crta__Skill__c(
            Name = 'Travel'
        );
        insert sk;
        crta__Contact_Skill_Profile_Line__c skLine = new crta__Contact_Skill_Profile_Line__c(
            crta__Contact__c = c.Id,
            crta__Skill__c = sk.Id
        );
        insert skLine;

        Language__c lang = new Language__c(
            Contact__c = c.Id,
            Language_key__c = 'German',
            Language_value__c = null
        );
        insert lang;

        Interest__c inter = new Interest__c(
            Contact__c = c.Id,
            Interest_key__c = 'interest key',
            Interest_value__c = 'interest name'
        );
        insert inter;

        Tag__c t = new Tag__c(
            Contact__c = c.Id,
            Tag_key__c = 'tag key',
            Tag_value__c = 'tag name'
        );
        insert t;

        Metadata__c md = new Metadata__c(
            Contact__c = c.Id,
            Metadata_key__c = 'metadata key',
            Metadata_value__c = 'metadata value'
        );
        insert md;
    }
    */
}