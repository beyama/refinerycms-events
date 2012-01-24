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
    var list        = $('#categories_list')
        empty       = list.find('li.empty'),
        addCategory = $('#add_category'),
        template    = eval( addCategory.attr('template') );
        
    $('li a', list).live('click', function() {
      var parent  = $(this).parent(),
          destroy = parent.find("input[name='categories[][_destroy]']");

      if(destroy.length) {
        destroy.val(true);
        parent.addClass('destroy').hide();
      } else {
        $(this).parent().remove();
      }

      if(list.find('li[class!=destroy]').size() == 1)
        empty.show();
      return false;
    });
    
    addCategory.click(function() {
      var $this = $(this),
          lis   = $('li', list),
          html  = template.replace(/new_event_category/g, new Date().getTime());
      
      list.append(html);
      empty.hide();
      
      return false;
    });
  } 
});

EventPicker = {
  initialised: false,

  callback: null,

  init: function(callback) {

    if (!this.initialised) {
      this.callback = callback;
      this.initClose();
      this.initSelect();
      this.initInsert();
      this.initialised = true;
    }
  },

  initClose: function() {
    $('.form-actions #cancel_button').click(close_dialog);
  },

  initSelect: function() {
    var self = this;
    $('#records .record').live('click', function() {
      $('#records .selected').removeClass('selected');
      $(this).addClass('selected');
      return false;
    });
  },

  initInsert: function() {
    var self = this;
    $('.form-actions #submit_button').click(function(e) {
      e.preventDefault();
      var data = self.getSelectedData();

      if(data && typeof(self.callback) === 'function')
        self.callback(data);
      
      close_dialog();
      return false;
    });
  },

  getSelectedData: function() {
    var element = $('#records .selected');

    if(!element.size()) return null;

    return { 
      id: element.attr('id').replace('event_description_', ''), 
      name: element.find('.name').text()
    }
  }
};
