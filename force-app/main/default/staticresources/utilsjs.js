(function (fallback) {   //Workaround for console.log() calls crashing on IE7 

    fallback = fallback || function () { };

    // function to trap most of the console functions from the FireBug Console API. 
    var trap = function () {
        // create an Array from the arguments Object           
        var args = Array.prototype.slice.call(arguments);
        // console.raw captures the raw args, without converting toString
        console.raw.push(args);
        var message = args.join(' ');
        console.messages.push(message);
        fallback(message);
    };

    // redefine console
    if (typeof console === 'undefined') {
        console = {
            messages: [],
            raw: [],
            dump: function() { return console.messages.join('\n'); },
            log: trap,
            debug: trap,
            info: trap,
            warn: trap,
            error: trap,
            assert: trap,
            clear: function() { 
                  console.messages.length = 0; 
                  console.raw.length = 0 ;
            },
            dir: trap,
            dirxml: trap,
            trace: trap,
            group: trap,
            groupCollapsed: trap,
            groupEnd: trap,
            time: trap,
            timeEnd: trap,
            timeStamp: trap,
            profile: trap,
            profileEnd: trap,
            count: trap,
            exception: trap,
            table: trap
        };
    }

})(null); // to define a fallback function, replace null with the name of the function (ex: alert)

function decodeHTML(text) {
  var decoded = jQuery('<div/>').html(text).html();
  return decoded;
}

function cleanSoapArray(array) {
  for (var i = array.length - 1; i >= 0; i--) {
    if(array[i] == null || array[i] == '') array[i] = 'null';
  }

  return array;
}

function addToElement (element, values) {
      if(typeof values == 'undefined') values = '';
      element.html(values);
}

function fold (id) {
      var blockToFold = jQuery(document.getElementById(id));
      var status = blockToFold.attr('data-fold');
      (status == 'false') ? blockToFold.find('[data-foldable="true"]').slideUp() : blockToFold.find('[data-foldable="true"]').slideDown();
      (status == 'false') ? blockToFold.attr('data-fold', 'true') : blockToFold.attr('data-fold', 'false');
}

function openMenu (menu) {
      jQuery('#'+menu).toggleClass('active');
}