// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require chartist
//= require select2
//= require jqcloud-1.0.4
//= require fb_comment
//= require adminlte
//= require owl.carousel
//= require_tree .
$(document).ready(function() {

  var agent = $(".agent-carousel");
  var issue = $(".issue-carousel");

  agent.owlCarousel({
    items : 4
  });
  $("#agent .next").click(function(){
   agent.trigger('owl.next');
  })
  $("#agent .prev").click(function(){
   agent.trigger('owl.prev');
  })

  issue.owlCarousel({
    itemsCustom : [
        [0, 1],
        [670, 2],
        [1200, 3]
      ],
  });
  $("#hot-issues .next").click(function(){
   issue.trigger('owl.next');
  })
  $("#hot-issues .prev").click(function(){
   issue.trigger('owl.prev');
  })

});
