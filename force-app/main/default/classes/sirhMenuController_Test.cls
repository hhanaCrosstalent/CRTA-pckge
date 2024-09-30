@IsTest
private class sirhMenuController_Test {

    @IsTest
    private static void sirhMenuController() {
        Timesheet__c timesheetOptions = new Timesheet__c(
                UseMetadata__c=true,
                StartHour__c = '07:00',
                EndHour__c = '19:00',
                EndHourMorning__c = '12:00',
                StartHourAfternoon__c = '13:00'
                );
        insert timesheetOptions;

        Contact c = new Contact(Lastname = 'zaza');
        insert c; 

        Contact c2 = new Contact(lastname='toto', Responsable_RH__c = c.Id, reportsToId = c.Id);
        insert c2; 
		
        System.assert(c != null);
        System.assert(c2 != null);
        
        Type_d_absence__c leaveType = new Type_d_absence__c(
                Name='Congés payés', 
                Notifier_manager__c=true
                );
        insert leaveType;
		System.assert(leaveType != null);
        
        final
        String image = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRo'
            + 'fHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj'
            + 'IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAEsASwDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcIC'
            + 'QoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3'
            + 'ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8j'
            + 'JytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBA'
            + 'cFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVV'
            + 'ldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk'
            + '5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwCeS4nE8pBUIl0YwphTaV3AYBx19RnPIPrjRM4Opi1TT12AZdzGeATgHOPY/wCIwRX'
            + 'ojeHtBErFra1Eilc5lOQWYqv5sCB7irX/AAjmn/8APov/AH9euirVhNLljYxpwcb3dzzBLgOxDaS6qACWMf1yAMZJGB25zxnjKxStJ5'
            + '2dIKeXIIxuUfPltu4cfd6nPpXpJ0bR1lEZjgEhk8oKZ2yX27tuM9dvzY9OakbQtNU7WgjB4GDMw69O9Y3Nrdzy5LxjAsh0ORSSw8tlG'
            + '4YUt6Y5OAPcnpip4ZnksHlGnCOYrKUDRDAwxCgjOSSMHj36cV6UPD2muMrbIwyRkTP1HB70x9B0qNgrwRKTgYMzDqcDv60tOoX7HnFr'
            + 'dyzSmGXTGjZVGZTGAjHaCcde5x6cHn1u3DCC2WSOzWR2PKYxjj2B/wA9MnAPfDw3p4/5dF/7+vTRoemSSPGIYmdMblEzZXPTIzxRoNS'
            + 'aPLZvDdpL4qh1doYiiwlTHsH+sB4b34J/IVbgCnU2R0jkt54zJBtiH7rYQrBj/tE5X1Ab0r0dfD2myorrbIykBlYTPz7jmnDw3p46Wi'
            + 'f9/XpddAu3uebQPMuwtZxndLtI8krsGAffdjkbuBUz3bos23TGcozAYTAbAJB6Hg4A47+nGfRB4dsB/wAuq/8Af16cNAsh0tl/7+tQV'
            + 'Gdjz6SdYXAezG0ypGH28HccZ6e4/wA9WX8ksUStDZc/NkGHzCcEAcKeM5znPQdM16J/YNl/z7L/AN/Wo/sGz/59l/7+tSsX7RHnFwr7'
            + 'wtYlJQjAgaTa2cZ6DgenfPYDJgtWkld1msEQKZMN5WN4DYXAPTI9a9O/sGy/wCfZf8Av41NPh2wPW1T/v69UnYylZ7HnUyrHJCqWcbq'
            + '5wzbfudOenv/AJGSMa18J2tjr+p6pDFDvuIx9nQpxE2Du46ckA59yK9d/wCEc0//AJ9V/wC/r0f8I3p5IP2Rcj/pq9O6IseMaNe3t2t'
            + '27/ZLkQ2u8LHEOJTnC8cnp269q17mZ7Q7P7Ja6YKCXhjAUnIHAJ46k9+nWvTk8L6XHu2WMS7jk7ZGGT607/hHNP8A+fRf+/r1UpJu6F'
            + 'GLSszzN5ESXZ/ZxK79pZY84Hr06f8A1vfEKXW9I2/sdwXcLt8vBUbiNxyAMYGeueR616l/wjen/wDPov8A39ej/hG9P/59F/7+vU3Ks'
            + 'eYyTIjMBphYBioIjPrjPTp34zxjGecJbymWAO+l+Wwl8sqyAFhx8w9s+vpXp/8Awjen/wDPov8A39f/ABo/4RvT/wDn0X/v6/8AjRcL'
            + 'HmkLLMATYKgyAd0Z9cdwOP8AOKkeKM3IgNlE0LL8zlRjvxjH+fyz6P8A8I3p/wDz6L/39f8Axo/4RvT/APn0X/v6/wDjRcLHhM+gQ+D'
            + 'tC1q+s1j8+W6VonCDMcRdQIxuDAYywzj09Kl0LUrm9Oo7XjufLFqY0eKOUw+YSHBMQXfgc9unbmvbZfCmkzoUlsIpFYYKvIxB78imwe'
            + 'ENGtd32fTYIt33vLZlz9cUXQrO9zzIXbiFy2hy+YoB2qqnccAnB+px+tW4fLlHNht/eFOUAwMZyc4+nGfy5r0j/hG9P/59F/7+v/jR/'
            + 'wAI3p//AD6L/wB/X/xouOx5ZaSTNZRyXWnIsxRWZRDjliRjA3EYwPXryB0CxXI/crNpu0uqEuYsAFjjHTgg9vTvXqX/AAjen/8APov/'
            + 'AH9f/Gj/AIRvT/8An0X/AL+v/jRdBY8uknItpZE0vDKrFQ0ZOSGIHAGeRz+P41aSIefKHtY/LDKEPljkY57+vsK9H/4RvT/+fRf+/r/'
            + '40f8ACN6f/wA+i/8Af1/8aLhY82eCGaaS2lsIWtyhyzICG6fLjHv/AJ5xr+DfDFj4E8HQN5NtPcXdy80rSKpeWPDFFVjjaQihucqDvz'
            + 'gEsOxbwzpzAg2i4P8A02f/ABrU2Sei/n/9ak2CObnv4PJ1Bkt7OBrdkQB7QTFCWYcqjZctgAKuOSBknIF7Qwl9p++8srQTqwVmjg2qx'
            + '2gkAHJG0kocnqp6dBrbJPRfz/8ArUbJPRfz/wDrUhnNpoluNPa0fVblmeOFHnCMJCY5Wk3BuzEseefWqMnhDT5LOCzE0MFvDbmFUt7Z'
            + '1DAsxaMgsT5Lbhuj3fNtXlcCrLzanNbgJbJbuwjyTKGZMld+BjGVBbB7kDjFIl/eLPawyWLgTMAzGRSyDy2YlguQMMAvBxlhg003ayF'
            + 'ypO/9f1qMvPCWj3dgLQtHGnmmfK2xPz/ZjbhsnJyAQ2SScgc961TpulZtmVEQ2mfs8aQkRx8AIAuOAoVeBgcVWnuZUnhgjhkYy5JlGN'
            + 'kYGM59znjg8im3H2z7XbGBl8hQ/nKSMtx8uOOufcd+tDbtYdy4bCw+1CdZWDgqQxjJYbQgHJ6nCsP+Bt6nMY02xWDyklVV2oNn2c7Pl'
            + 'cv930JY8ZrMa41h7ZNtqkU2GU7mVxu3bVY8j5cHeQOeMdet2Ke6cEvbLH0IDSZ4JOc4HUDHtk4z3oYFk2NmWDCYDEYTAgOCAB19QMYA'
            + '7BnH8XEqwWpuDNNKHbYox5LcOGLbhnPcnHpWRFPqaXUscloZIvO+WUyqPkKk8KBnghV55+YnOBRaXmqTSf6Tpy26BnXHnhyQCu1gR6g'
            + 'sce35roOxfj06yjt44RKnyHORbkZ4A/XGG/vAkcZrUt57a3gWISE4J52HJyc5PqfU9zzXNR32rkKX0mMDzGVsXQJ2jOGA24OQBgZHLc'
            + '4wTWkHJ6gj60WsI2Pt1v8A3z/3wf8ACj7db/3z/wB8H/Cubt5nd4MyXWSvziSLaudvrtGOfeoGudVhF2EszOyFnhLTIokHBCDjjuCW6'
            + 'dec8RTqKoroqcXHc6v7db/3z/3wf8KPt1v/AHz/AN8H/CuZNxqInh/0QFSSsgWYbV+UndkjJ5CrjA+8Tzinx3N88tur2KojxlpmM4Pl'
            + 'thcKAB82SWGePu+4qxWOj+3W/wDfP/fB/wAKPt1v/fP/AHwf8K5e1utSMsUdxYbUdpS8vmr+7Af92MDrlefbHNacZXzB5hAXuScUCNX'
            + '7db/3z/3wf8KPt1v/AHz/AN8H/CuY1H+04raBbGSO4mEn72QbVDKFY9DnvtGO/qvUMS91WS3Rm0wQyFIXZPPVsEn94mfVR36HNA2rK5'
            + '1X263/AL5/74P+FH263/vn/vg/4Vys1/qyWLSxaQslwNuIPtSrnKgn5sY4JI99ue4qOS51tTdeVZRPtU+RvlABOXweOenl8HHfmmlcL'
            + 'HXfbrf++f8Avg/4Ufbrf++f++D/AIVypXVH1CcmVktg6GEIUO5dvzA5XI+b3z7ipVn1CGO3ja189mVBJIJl+U/xE8DgcYwOT1C9aQjp'
            + 'ft1v/fP/AHwf8KPt1v8A3z/3wf8ACsG3nmkLrLbyRFMDcxXD8dRgk4+uKndd8SFLhInV9zBhneuPu4zxz39qGBr/AG63/vn/AL4P+FH'
            + '263/vn/vg/wCFYLS3QulVYYjAfvSGUhhwei7cHnHcdfas5LjW4tNxJZrPcLG2StwquzZbaB8u3+7ycdenahK4HX/brf8Avn/vg/4Ufb'
            + 'rf++f++D/hXO29zfSSnzrJIYt2AfO3NjGckAY68Yz1z1HJsb2NyIzII1aFyHboGyuD+p4oA2vt1v8A3z/3wf8ACj7db/3z/wB8H/CuU'
            + 'uJ9Ub7FPbRbk8l3niDKpZtoKqNw7nI6jHfNQWkmvNqgNyipZgKpX5TniQM3BzyVjI9nIIz90Gkdl9ut/wC+f++D/hR9ut/75/74P+Fc'
            + 'hb3etw20KT6d582yUySCdAAyn5F6DO4d8DGOQOlLb32spp8DXOlb7jyAZVSdAfMDAEAdORlhzjjHvQFtLnXfbrf++f8Avg/4Ufbrf++'
            + 'f++D/AIVyRu9ZE0rf2cpT7KjognXmbJ3Jn6Y5xjj3rQtZLl4AbqNI5tzZVG3ADJxz34x6fQdKAsbv263/AL5/74P+FH263/vn/vg/4V'
            + 'kSLiVZEuEKFAphAyQ3OWzn8MYqhFc3/m7JLYNmQ9HAKIRkEjnJz8vH1oEdN9ut/wC+f++D/hR9ut/75/74P+Fc0LvUWkjA09VRlcuWn'
            + 'AKkHCjgHO4c9sYp7z3iSuEtfMTPynzQOMemPXPr/QNK7sJuyueBf8Lm8Wetj/34/wDr1Zsfir451S4+z6fZw3c+0t5dvZtI2B1OAScV'
            + '5rXp3wJ/5H+X/rwk/wDQkrplGKV7HS4xSvYv/wDCZfFX/oWrv/wUy1HP46+KFrbyXFxoE8MMal3kk0uVVVR1JJ4Ar3S4ujNqMmlpPNa'
            + 'zG2E0UyopDfMQ23cCCVwuRjjevrWV4glup/hlq8t9EkV22kTmZIzlQ/lNnByeM9OaxUlfYyUl2PF7f4lfEK7gWe20wTQt92SOwdlP0I'
            + 'qX/hYPxJ/6Az/+C6St/wAGvJH4AsnhTfKsMhRcZydzYGBVbw5rPii71NLfVdKkhtiGLTPavHjuBk8e3SrbinsN27GT/wALC+JP/QGf/'
            + 'wAF0lQR/E/x9LdSWsdgj3MQzJCti5dR7jOR1FejQvdNPOs0EUcKsBC6ylmcY5JG0bfzNcno3/JUPEP/AFwi/wDQUoVuwK3YzP8AhYXx'
            + 'J/6Az/8Aguko/wCFg/En/oDP/wCC6St/xBqOuWl+y6baXEsSW6yL5ds0gkcvgqSAcfLz17e9dMf60rrsF12PO/8AhYPxI/6Az/8Aguk'
            + 'o/wCFg/Ej/oDP/wCC6Su21Od4ETy3IdshU4AduOMll7bjjIzg+hqe1k86zEgk8xTna+3G4ZOD78Y5HB696V12Hddjg/8AhYHxI/6Az/'
            + '8Aguko/wCFgfEj/oDP/wCC6Su31dp00yU20jRzfKFKqCckgYA9TnFQ6C141lIL2SR5lkIxIu1lGAcH88/jRddik49jjLT4i/ELUJpob'
            + 'PS/tMsBxMkNg7tGefvAdOh6+lXP+Ew+Kf8A0Ll1/wCCqWuq+FI/4qzxt/18w/zlrr9SvdYi8SW8FsJPsTNGHxbSMME/N8wjKj8WGPak'
            + '5JPYJyjF2sePXnj74j6dbG5vtHe1gUgGWfTpEUE9OTxWb/wuDxX62P8A34/+vXr3xeGfhtqA/wBuH/0YtfNISqjytbGlKMZq9juf+Fw'
            + 'eK/Wy/wC/H/16P+Fv+K/71j/34/8Ar1w+ylCVXLHsbexh2O3/AOFweK/71j/34/8Ar0n/AAuDxX62P/fj/wCvXEbKaUp8sewexh2PRb'
            + 'b4k+Pr2ETWunrPETjfFYuy5+oqX/hP/iP/ANAd/wDwXSVufDwY8HW3/XST/wBCNathearLf3EN7pgigWRhHNHKGBAAxkcHB9fwIFQ3F'
            + 'PY5pcqdrHHf8J/8R/8AoDv/AOC6Sl/4T/4j/wDQHf8A8F0leid6xLy/1qDVhHBpQnsgRl1kAYjGcjPHrx/s9fmFF12M3bsct/wn/wAR'
            + 'v+gO/P8A1DpKX/hPviN/0B3/APBdJXoLfeT6/wBDVHVrrULa3P8AZtgLqbaT80gVV4492JPYfiRxRzR7EnFS/EP4hQxPLLpZjjQFmd7'
            + 'BwFA6knsKZb/Efx/dwLPbacJ4mztkisXZTjg4Irs9cMjeEtSaZBHIbGUsgbcFOw5Ge9UPAP8AyJOn/wDbT/0Y1O8bXsIwP+E++I3/AE'
            + 'B3/wDBdJVS7+KXjawdUvLaC3ZhlVmtGQkevJrr9EudXm1CRL9ZRCIyV327oM5GOSijpnvXG/Fb/kIad/1yf+Ypx5W7WAhPxi8Vetj/A'
            + 'N+P/r0h+MXiv1sf+/H/ANeuCNIRWns49h2O+/4XH4r9bH/vx/8AXpP+FyeK/Wx/78f/AF64EjFNNP2cewWO/Pxl8Wetj/34P+NJ/wAL'
            + 'l8V+tj/34/8Ar1wB6U2j2cewrC10PgvXNa8P6+LvQbQXd60TR+SYWl3KcE/KvPYV1x+HlqIDII8kY5+cLk543Z9j+VdB8J9LtLDxjcv'
            + 'Hb7JFsnGSSSPnT1qHOLTsbuaaKr/Eb4mSgCTwijBSGG7SpzgjofvVX1Tx38StW0m806fwu6w3ULwSNHpk4YKwIOMk84Ne3SapBFceQy'
            + '3O7IG5baRk5/2gu39eKt76x512MuZdj5s0nU/HmjaZDYW/hq6aGEEKZNPmLckntj1q7/wk3xC/6Fif/wAF0/8AjX0Nvo3+9P2nkPn8j'
            + '55/4Sb4hf8AQsT/APgun/xrLtbnxzaa7d6unhy9NxdKFkVtPl24GMYHXsO9fTiBpC2HVQoBJIzUgt5CMiVCD/s//Xo9p5Bz+R85/wDC'
            + 'TfEL/oWJ/wDwXT/40f8ACTfEH/oWJ/8AwXT/AONfRn2eT/nqn/fP/wBej7PL/wA9F/75/wDr0vaLsHOux86DxN8Qhz/wjM4/7h0/+NL'
            + '/AMJJ8QCMHwzNz/1Dpv8AGvor7NL/AM9F/wC+f/r0fZpf+ei/98//AF6Oddhqoux87jxL8QAf+RanH/cOm/xp3/CSePz18Nz/APgvm/'
            + 'xr6G+zy/8APRf++f8A69H2eX/nov8A3z/9elz+RXtl/KfOXh/WPHfhzUNSvbPw7cvJqLq8wm0+UgEFiNuMY+8a6EfEX4k/9Cx/5TZ//'
            + 'iq9s+zy/wDPRf8Avn/69H2aX/nov/fP/wBelzeQnVT1cT5/8ReJfH3ifRpNLvvDsyW8jKzGHT5gxwcjkk9wK40eFdf/AOgFqf8A4Byf'
            + '4V9ZfZ5f+ei/98//AF6Ps8v/AD0X/vn/AOvTU7bFRr8qskfJ48K6/wD9ALU//AST/Cl/4RXXv+gHqf8A4CSf4V9X/Z5f+ei/98//AF6'
            + 'Ps8v/AD0X/vn/AOvRzsr60+x8nnwrr/8A0A9T/wDAST/CoZ/DmtW0LzT6PqEUSDLPJbOqqPckV9Y7Jsn94nBI+4f8agvQwsbhZCrBo2'
            + 'H3cdqOdh9afY+ZdH8ZaromnrZWqWzQqxYeYhJGeexFXj8Stc/542P/AH7b/wCKr2KL4PeEGiVja3OSP+fhqd/wpzwef+XW5/8AAhqfN'
            + 'Ebq0n0PGf8AhZeuZ/1Nj/37b/4qj/hZmuf88bH/AL9t/wDFV7L/AMKa8HH/AJdLn/wJaj/hTPg3/n0uf/AlqfPHsQ6lPseMH4l64cHy'
            + 'LHjkfu2/+Ko/4Wbrv/PCx/79t/8AFV7N/wAKZ8G/8+lz/wCBLUf8KY8Gf8+lz/4EtT54diHKHY8SvfiHrN9Y3FpLFZrHPG0bFY2BwRg'
            + '4+aoNJ8c6toumRWFtHatDFu2mRGJ5JJ6Edya9z/4Ux4M/587n/wACWo/4Uv4M/wCfS5/8CWp+0h2JvE8Z/wCFna7/AM8bH/v23/xVYG'
            + 'v+Ir3xFPFLerCpiUqoiUgcn3Jr6F/4Uv4M/wCfO5/8CWo/4Ut4L/587n/wJahVILZCuj5iIptfT3/ClvBf/Pnc/wDgS1H/AApXwX/z5'
            + '3P/AIEvVe2iF0fL5pDX1B/wpTwV/wA+dz/4EvR/wpPwV/z5XP8A4EvR7aIXR8unpSV9Rf8ACkvBP/Plc/8AgU/+NH/CkvBP/Plc/wDg'
            + 'U/8AjR7aIXRxbeJ7f7L5IhlwG39AMnHfn/8AVz6mrfw4laTxbdytjc9o7HHqZErwnFenfAu3a48cXqK4QjTXOSuf+WkXuKcqSjFtGjg'
            + 'kme9Ekoy7hg57U/fU39mS/wDPyn/fo/8AxVH9mS/8/Kf9+j/8VXKYkO+jfU39mS/8/Kf9+j/8VR/Zkv8Az8p/36P/AMVQAxDHJDNHJM'
            + 'kZYDaWPcc56j9CD6Edahns4pYpEXUbdGcAFguegx/e7HBHcY6nJqz/AGZL/wA/Kf8Afo//ABVH9mS/8/Kf9+j/APFUARSWlpIjJ9rtw'
            + 'DznjIbawz19Tn659eNH7Xbf8/EX/fYqn/Zkv/Pyn/fo/wDxVH9mS/8APyn/AH6P/wAVQBc+123/AD8Rf99ij7Xbf8/EX/fYqn/Zkv8A'
            + 'z8p/36P/AMVR/Zkv/Pyn/fo//FUAXPtdt/z8Rf8AfYo+123/AD8Rf99iqf8AZkv/AD8p/wB+j/8AFUf2ZL/z8p/36P8A8VQBc+123/P'
            + 'xF/32KPtdt/z8Rf8AfYqn/Zkv/Pyn/fo//FUf2ZL/AM/Kf9+j/wDFUAXPtdt/z8Rf99ij7Xbf8/EX/fYqn/Zkv/Pyn/fo/wDxVH9mS/'
            + '8APyn/AH6P/wAVQBc+123/AD8Rf99ij7Xbf8/EX/fYqn/Zkv8Az8p/36P/AMVR/Zkv/Pyn/fo//FUAQ332G+t5baa8KIzZJhumhfhs8'
            + 'MjBh07HkU2+niltJfKkRx5bZ2sD2qf+y5f+flP+/R/+KqK602VLOdvtCECNjjy/b/eoA1IP9Qn0qSo4P9Qn0qSgAooooAKKKKACiiig'
            + 'AooooAKKKKACiiigAooooA+Ha9V+AP8AyPl9/wBgyT/0bFXlmK9T+AX/ACPl9/2DJP8A0bFXdV+BnRP4WfRtFFFcJzhRRRQAUUUUAFF'
            + 'FFABRRRQAUUUUAFFFFABRRRQAUUUUAFQX3/Hhc/8AXJv5Gp6gvv8Ajwuf+uTfyNAD4P8AUJ9KkqOD/UJ9KkoAKKKKACiiigAooooAKK'
            + 'KKACiiigAooooAKKKKAPiGvU/gGP8Aiu73/sGSf+jYq8uAr1L4Cf8AI93v/YMk/wDRsVd1R+4zol8LPoqiiiuE5wooooAKKKKACq1tf'
            + 'wXZHk+cQy7gzQuqkexIAqzWHFpFwmmm1IXcYRGWN3I69uikYHTt0oA3Ka0iIyKxwXO1R6nBP8gaw7/RxFa3L2kESEpIAsa4JUpgKAB/'
            + 'e5xUn9joWDSWlqkYkLGKPJAUoVbHy9SccAdh3oA15ZUgheaRtscalmOM4A5NKjhwSucA45BH86y4LO4m0W5SVs3V1GwLONv8O1SRjI4'
            + 'AJHYk1FJo0zXUcw8osku8Fm6DcD0KnnjsV9yewBsxyJKu5DkZIz7g4P6inVU0+1NnB5AiiSMO7Dyz6tkcYHY/pVugAooooAKKKKACoL'
            + '7/AI8Ln/rk38jU9QX3/Hhc/wDXJv5GgB8H+oT6VJUcH+oT6VJQAUUUUAFFFFABRRRQAUUVXkvYY5GRi+VKhiEJCk9MnGO4+maALFFQP'
            + 'eW8ZcGZCyMquoOSpYgLkDpnNO+1W+JT58WIf9Z84+T6+lAEtFQR3lvLcNbxzI0qorlQc/Keh/z6j1oF7algouYSSwUDzB1IyB9SKAJ6'
            + 'KhN3bKJS1xEBF/rMuPk+vpSSXtrFt8y5hTcNy7pAMj1+lAHxWBXqfwGH/FdXv/YMk/8ARsVeWivUvgN/yPV7/wBg2T/0bFXZU+FnRL4'
            + 'WfRFFFFcZzhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFQX3/Hhc/wDXJv5Gp6gvv+PC5/65N/I0APg/1CfSpKjg/wBQn0'
            + 'qSgAooooAKKKKACiiigArOudPlmumlV41JZSsoBWSMAdOPvg88HgZ79K0aKAMYaIyuSGXIcMHZ3JI81XPBOF6dup546UkGiPAQQ6s0Z'
            + 'G1nkdt+H3cgnC9OwPPPtW1RQBTtrWSG6aVvKCtAkZEY2hSpY8D0+b9KqjSCLcIPKDiONAwHdX3H8/51rUUAYiaG0aMu4OQMK7TSbm+c'
            + 'Nnr8p46gHnn2qKbQZ5fL3G3kZU2lmMidzxhGAOBxnFdBRQnbYN9z4lUV6n8B/wDker3/ALBsn/oyKvLVr1L4D/8AI9Xv/YNk/wDRsVd'
            + 'lT4WauWh9D0UUVxmQUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABUF9/x4XP/AFyb+RqeoL7/AI8Ln/rk38jQA+D/AFCfSp'
            + 'Kjg/1CfSpKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD4tF3J/dh/78p/hXpfwIYt47vicZOmyHgY/wCWsVeWivUfgP8A8j1e/'
            + 'wDYMk/9GxV2VF7rBM+iKKKK4wCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKgvv+PC5/65N/I1PUF9/wAeFz/1yb+RoAfB'
            + '/qE+lSVHB/qE+lSUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAHxOK9R+A//ACPV7/2DZP8A0bFXmGK9Q+BA/wCK5vf+wbJ/6Ni'
            + 'r0Kq9xmFOd2fQ1FFFeebhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFQX3/Hhc/9cm/kanqC+/48Ln/rk38jQA+D/UJ9Kk'
            + 'qOD/UJ9KkoAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAPjEx16X8C1x45vP+wbJ/6Mirz0pXpHwQXb42vP+wc//oyOvUrxtTZ5W'
            + 'Gqc00e+0UUV5Z6oUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABUF9/x4XP/AFyb+RqeoL7/AI8Ln/rk38jQA+D/AFCfSpKj'
            + 'g/1CfSpKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD5FaL2r0P4LLt8a3f/AGDn/wDRkdcTJFXefBxNvjK7/wCwe/8A6Mjr28V'
            + 'G1JnzmAqXrJHuNFFFeIfRhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFQX3/AB4XP/XJv5Gp6gvv+PC5/wCuTfyNAD4P9Q'
            + 'n0qSo4P9Qn0qSgAooooAKKKKACiiigAooooAKKKKACiiigAooooA+XZEruPhGm3xhdf9eD/wDoyOuP2ZOa7X4UDHi+5/68H/8ARkde9'
            + 'jP4TPlssT9qmey0UUV4J9SFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVBff8AHhc/9cm/kanqC+/48Ln/AK5N/I0APg/1'
            + 'CfSpKjg/1CfSpKACiiigAooooAKKKKACiiigAooooAKKKKACiiigD5qOAK7L4Vf8jdc/9eL/APoyOuKLV2nwpOfF1z/14v8A+jI69jE'
            + 'yvTZ4mCpcs0z2SiiivHPbCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKgvv+PC5/65N/I1PUF9/x4XP/AFyb+RoAfB/qE+'
            + 'lSVHB/qE+lSUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAHzCXrt/hMc+L7n/rwf8A9GR15/5ld78Imz4wuv8Arwf/ANGR16NaV'
            + '4M5qNK2p7VRRRXnHSFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVBff8eFz/1yb+RqeoL7/jwuf+uTfyNAD4P9Qn0qSo4P'
            + '9Qn0qSgAooooAKKKKACiiigAooooAKKKKACiiigAooooA+UA9eg/B458Y3X/AF4P/wCjI683V69F+DZz4yuv+we//oyOuuo/dZajaJ7'
            + 'jRRRXIQFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVBff8eFz/1yb+RqeoL7/jwuf+uTfyNAD4P9Qn0qSo4P9Qn0qSgAoo'
            + 'ooAKKKKACiiigAooooAKKKKACiiigAooooA+QFkPpXo3wblK+Mrs7f+Ye/U/8ATSOvNFavQ/g8/wDxV91/14P/AOjI666nws3fws95+'
            + '0n+4P8Avr/61H2k/wBwf99f/WrkdY137LqD21vqlqlwkLSPbSMgYIFY5XJGXyM8/KFBzjINVl8Q6jFZWuoTBfscm7eMKXCCYKsnUKQU'
            + 'PJDY+YMoIBzyWMDt/tJ/uD/vr/61H2k/3B/31/8AWqkJMgH1pfMoAufaT/cH/fX/ANaj7Sf7g/76/wDrVT8yjzKALn2k/wBwf99f/Wo'
            + '+0n+4P++v/rVT8yjzKALn2k/3B/31/wDWo+0n+4P++v8A61U/Mo8ygC59pP8AcH/fX/1qPtJ/uD/vr/61cv4tEknh64eO6ng8sBiIWC'
            + '7+RwxxnH0Iz0ORkVp3kxRE2yupLYCxgFnODwM9PX8PSjoLrY1ftJ/uD/vr/wCtR9pP9wf99f8A1qx5pJ1skVpwtzs6qQAzAc9Qfr+FQ'
            + 'ahqMkenLJD5is8ZcSCMnbgZ5GDgn39/SgZv/aT/AHB/31/9aj7Sf7g/76/+tWNfXUkYV43UII3kZS21jjHqD6/yq75lAFz7Sf7g/wC+'
            + 'v/rUfaT/AHB/31/9aqTOxU7SA2OCRkA1jy3t2lqr+cWKrPuK7ASVbAJB7Adce1AHS/aT/cH/AH1/9aoby4JsbgbRzG3f2+lZaS3L3LC'
            + 'OfcoDbtyDYp/hA7kjvz6/gJNJJpMxlfe+JFLYxnBI/pQBvQf6hPpUlRwf6hPpUlABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB8'
            + 'aq1dp8M9ZsdG8UyzahcJbxS2rxLI/Chtytye3Cmk0aOC88QWEc9naNH5j5QW6ANiGRhkAc8qp/CuyntNPV4FGkaWBI+0/6FH/dY+ntW'
            + '8qqatYvm0sdX/wm3hv/AKDdl/39FL/wmvhv/oN2X/f0VxWpaXYRWryx2NmrADGLSLHX/drz/Wbpk0y5eOC1RkClSltGCPnUdh6E1l7p'
            + 'Oh7r/wAJr4c/6DVl/wB/RR/wmnhz/oNWX/f0V8+T6lND4fS4SK184yBd5t0PGGPce1U01u82KSLU5/6dIv8A4mnBRlsKcox3Po//AIT'
            + 'Tw5/0GrP/AL+il/4TPw7/ANBmz/7+CvItDWK90mG4ntrUyMWBIgQdGI9PatIWdp/z6W3/AH5T/CocoJ2dykrq6PS/+Ez8O/8AQZs/+/'
            + 'go/wCEz8O/9Bmz/wC/grxnXLtdNZDBZ2RG4KQ9upBzW7a2trNawytZ2u50DHEC4yR9KUatOSurmlahKlJRl1V/vPSf+Ez8O/8AQZs/+'
            + '/go/wCEz8O/9Bmz/wC/grzv7DZ/8+dt/wB+U/wrV8PeFNO8QG7WbNv5EiKpt4YgWBGTncjfpiri6cnbUy5Wbep+KLW5kC2PibQobYoA'
            + '8d3aNOWbJ5yJUGOnGO3X0tW/ivQ2tI01LW9Kubhc7njTy0PPGFZmI4x3P9K+btQ1W8jv540dAqSMoAiToD9Krf2xff8APVf+/a/4VX7'
            + 'vzJ1PqE+LvDLIEOq2JQYwpcYGKc3jHw4ylW1iyIPBBkHNfLn9sXv/AD1X/v2v+FH9sX3/AD1X/v2v+FP935i94+om8X+G3xu1eybacj'
            + 'Lg4PrSt4v8Nv8Ae1aybgjlweD1FfLn9sX3/PVf+/a/4Uo1m+/56r/37X/Cj915i94+ox4w8OgkjV7MEnJw45pp8WeG2AB1SyOG3D5hw'
            + 'fX618xLrN9/z1X/AL9r/hTxrF9/z1X/AL9r/hT/AHXn+Ae8fTK+KfDKyGRdSsQ553AjP50y68YeH47GfZqds3yNhI2yScdh6181f2xf'
            + 'f89V/wC/a/4Uo1m+/wCey/8Aftf8KP3Pn+A/ePao/i7rSRqv2Cw4H91//iqd/wALg1r/AJ8LD/vl/wD4qvFP7av/APnsP+/a/wCFL/b'
            + 'V/wD89l/79r/hXX7fC/8APsjln3Pav+Fwa1/z4WH/AHy//wAVSf8AC4da/wCfDT/++X/+Krxf+2b/AP57L/37X/Cgaxff89V/79r/AI'
            + 'Uvb4X/AJ9j5Z9z2j/hcOtf8+Gn/wDfL/8AxVJ/wuLWv+fDT/8Avl//AIqvGf7Yvv8Anqv/AH7X/Cj+173/AJ6r/wB+1/wpe2w3/PsaU'
            + 'u57N/wuLWv+fDT/APvl/wD4qk/4XHrf/QP0/wD75f8A+Krxr+173/nqv/ftf8KX+173/nov/ftf8KXtsP8AyDs+57J/wuPWv+gfp/8A'
            + '3y//AMVSj4xa1/z4af8A98v/APFV41/a97/z0X/v2v8AhR/a97/z1X/v2v8AhR7bD/yCtLuezj4wa0f+XCw/75f/AOKp4+Lusn/lxsP'
            + '++X/+KrxX+2L7/nqv/ftf8KX+2b8f8th/37X/AApe2w/8hSue1/8AC29Z/wCfGw/75f8A+Kpf+Ftaz/z42H/fL/8AxVeJ/wBtah/z3H'
            + '/ftf8ACk/tvUP+e4/74X/CpdWh/IaJx6o9sPxb1n/nxsP++X/+Kpv/AAt3Wf8AnxsP++X/APiq8UOt6h/z3H/fC/4U3+29Q/57j/vhf'
            + '8Kn2lL+UfNDsf/Z';
        String timesheet = '{"start":"2015-03-25", "end":"2015-04-07", "contact":"'+c.id+'"}';
        String leave = '{"start":"2015-03-25T11:48", "end":"2015-04-01T00:00", "type":"'
                        +leaveType.Id+'", "contact":"'+c.id+'"}';
        String leaveDateFull = '{"start":"2015-03-25", "end":"2015-03-25", "type":"'
                        +leaveType.Id+'", "startPeriod":"Journée complète","endPeriod":"Journée complète", "contact":"'
                        +c.id+'"}';
        String leaveDateMorning = '{"start":"2015-03-25", "end":"2015-03-25", "type":"'
                        +leaveType.Id+'", "startPeriod":"Matin", "endPeriod":"Matin", "contact":"'+c.id+'"}';
        String leaveDateAfternoon = '{"start":"2015-03-25", "end":"2015-03-25", "type":"'
                        +leaveType.Id+'", "startPeriod":"Après-midi","endPeriod":"Après-midi", "contact":"'+c.id+'"}';
        String leaveDateTwoDays = '{"start":"2015-03-25", "end":"2015-03-27", "type":"'
                        +leaveType.Id+'", "startPeriod":"Après-midi","endPeriod":"Après-midi", "contact":"'+c.id+'"}';
        String expenses = '{"comment":"Test", "start":"2015-03-25", "end":"2015-04-14", "contact":"'+c.id+'"}';

        sirhMenuController.base64upload(image, c.Id);
        sirhMenuController.base64upload(image, c.Id);
        sirhMenuController.createWeek(timesheet);
        sirhMenuController.createLeave(leave);
        sirhMenuController.createLeaveDate(leaveDateFull);
        sirhMenuController.createLeaveDate(leaveDateMorning);
        sirhMenuController.createLeaveDate(leaveDateAfternoon);
        sirhMenuController.createLeaveDate(leaveDateTwoDays);
        sirhMenuController.createExpenses(expenses);

        PageReference pg = Page.VisualisationProfil;
        pg.getParameters().put('id', c.Id);
        Test.setCurrentPage(pg);

        sirhMenuController controller=new sirhMenuController();
        controller.getLeaveTypes(); 
        controller.getLeavePeriods(); 
        controller.getPageLabel();
    }

}