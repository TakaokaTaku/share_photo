$("#post-img").bind("change", function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert("最大ファイルサイズは5MBです。小さいファイルの写真を選択してください。");
    $("#post-img").val("");
  }
});

$( document ).on('turbolinks:load', function() {
function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#img-preview').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
}
$("#post-img").change(function(){
  $('#img-preview').removeClass('hidden');
  $('.default-preview').addClass('hidden');
  readURL(this);
});
$(".reset").click(function(){
  $('#img-preview').addClass('hidden');
  $('.default-preview').removeClass('hidden');
  readURL(this);
});
});
