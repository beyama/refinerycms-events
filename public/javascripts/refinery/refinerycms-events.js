function remove_event(link) {
  var $link = $(link);
      $link.prev("input[type=hidden]").val("1");
  $link.closest(".fields").hide();
}

function add_event(link, content) {
  var new_id = new Date().getTime(),
      regexp = new RegExp("new_event", "g")
  $(link).before(content.replace(regexp, new_id));
}

$(function() {
  var form = $('#eventform');
  
  if(form.size()) {
    page_options.init(false, '', '');
    
    $('.different_location_add').live('click', function() {
      var self = $(this),
          box  = self.parent().find('.different_location');
      self.toggle();
      $(box).removeClass('hidden').find('input[type=hidden]').val(false);
      return false;
    });
    
    $('.different_location_remove').live('click', function() {
      var self = $(this),
          box = self.parent(),
          add = box.parent().find('.different_location_add');
      box.addClass('hidden').find('input[type=hidden]').val(true);
      add.toggle();
      return false;
    });
    
  }
});