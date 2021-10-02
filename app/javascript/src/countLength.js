$(function (){
  // 処理（ページが読み込まれた時、フォームに残り何文字入力できるかを数えて表示する）
  //フォームに入力されている文字数を数える
  //\nは"改行"に変換して2文字にする。オプションフラグgで文字列の最後まで\nを探し変換する
  let contentLength = $(".js-text").text().replace(/\n/g, "改行").length;
  
  // データ属性を使用して最大文字数を取得する
  let maxLength = $('.js-text-count').data('maxlength');

  //残りの入力できる文字数を計算
  let limitLength = maxLength - contentLength;
  //文字数がオーバーしていたら文字色を赤にする
  if (contentLength > maxLength) {
    $(".js-text-count").css("color","red");
  }
  //残りの入力できる文字数を表示
  $(".js-text-count").text( "残り" + limitLength + "文字");

  $(".js-text").on("keyup", function() {
    // 処理（キーボードを押した時、フォームに残り何文字入力できるかを数えて表示する）
    //フォームのvalueの文字数を数える
    let contentLength = $(this).val().replace(/\n/g, "改行").length;
    let limitLength = maxLength - contentLength;

    if (contentLength > maxLength) {
      $(".js-text-count").css("color","red");
    } else {
      $(".js-text-count").css("color","black");
    }
    $(".js-text-count").text( "残り" + limitLength + "文字");
  });
});
