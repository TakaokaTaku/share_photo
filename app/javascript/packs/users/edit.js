$("#user_picture").bind("change", function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert("最大ファイルサイズは5MBです。小さいファイルの写真を選択してください。");
    $("#user_picture").val("");
  }
});
