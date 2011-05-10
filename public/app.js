$(function() {
  $('a.example').click(function() { $('input[name="what"]').val($(this).text()); });
});
