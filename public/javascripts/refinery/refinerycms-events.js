function remove_event(link) {
  var $link = $(link);
      $link.prev("input[type=hidden]").val("1");
  $link.closest(".eventbox").hide();
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
  
  if($('#categories_form').size()) {
    var list = $('#categories_list')
        input = $('#new_category'),
        empty = list.find('li.empty'),
        addCategory = $('#add_category'),
        template = eval( addCategory.attr('template') );
        
    $('li a', list).live('click', function() {
      $(this).parent().remove();
      if(list.find('li').size() == 1)
        empty.show();
      return false;
    });
    
    addCategory.click(function() {
      var $this = $(this),
          lis = $('li', list),
          val = input.val().trim();
      
      if(val.length == 0)
        return false;
        
      input.val('');
      
      var html = template.replace(/new_category/g, val),
          val  = val.toLowerCase();
      
      for(var i=0; i < lis.size(); i++) {
        var li = $(lis[i]),
            li_val = li.find('input').val();
        console.log(li_val)
        
        if(li_val) {
          li_val = li_val.toLowerCase();
          if(li_val > val) {          
            li.before(html);
            return false;
          } else if(li_val == val) {
            return false;
          }
        }
      }
      list.append(html);
      empty.hide();
      
      return false;
    });
  } 
});