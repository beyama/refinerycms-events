$(function() {
  if($('#event_filter').size()) {
    $.datepicker.setDefaults( $.datepicker.regional[ '' ] );
    var dates = $('#start_at, #end_at').datepicker(
      $.extend({
        changeMonth: true,
        numberOfMonths: 3,
        onSelect: function( selectedDate ) {
          var option = this.id == "start_at" ? "minDate" : "maxDate",
              instance = $( this ).data("datepicker"),
              date = $.datepicker.parseDate(
                instance.settings.dateFormat ||
                $.datepicker._defaults.dateFormat,
                selectedDate, instance.settings );
          dates.not( this ).datepicker( "option", option, date );
        }
      }, $.datepicker.regional[$('#start_at').attr('locale')])
    );
  }
  
  var mapsCanvas = $('#event_map_canvas');
  if(mapsCanvas.size()) {
    var latlng = new google.maps.LatLng(mapsCanvas.attr('lat'), mapsCanvas.attr('lng'));
    var options = {
      zoom: 16,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(mapsCanvas[0], options);
    var marker = new google.maps.Marker({
      position: latlng, 
      map: map,
      title: mapsCanvas.attr('map_title')
    });
  }

  
});
