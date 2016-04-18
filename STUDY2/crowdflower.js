
require(['jquery-noconflict'], function($) {
 //Ensure MooTools is where it must be
  Window.implement('$', function(el, nc){
    return document.id(el, nc, this.document);
  });

  var $ = window.jQuery;
 
    $("div.html-element-wrapper").randomize("div.member"); 
 
(function($) {

$.fn.randomize = function(childElem) {
  return this.each(function() {
      var $this = $(this);
      var elems = $this.children(childElem);

      elems.sort(function() { return (Math.round(Math.random())-0.5); });  

      $this.remove(childElem);  

      for(var i=0; i < elems.length; i++)
        $this.append(elems[i]);      

  });    
}
})(jQuery);

});  
 
 

 
 