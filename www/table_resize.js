$(window).load(function() {
  $(".resizable").on("mresize", function() {
    var h = parseInt(($('#all_edges_data_div').css('height')).replace('px', '')) - 40;
    console.log(h);
    $('#all_edges_data_div .dataTables_scrollBody').css("height", h + "px").css("max-height", h + "px");
    $('#all_edges_data').dataTable().fnDraw(false);
  });
});