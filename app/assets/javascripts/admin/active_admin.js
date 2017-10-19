'use strict';

var modules = modules || {};

modules.activeAdmin = (function () {
var module = {}

// AJAXのリクエストパラメータのひな形
module.getAjaxTemplate = function() {
  return {
    type: 'get',
    url: '',
    crossDomain: true,
    timeout: 1000 * 60 * 5, // 5分
    cache: false,
    data: {
    },
    crossDomain: true,
    headers: {
      'content-type' : 'application/json; charset=UTF-8'
    },
  };
}

// AJAXの接続失敗の処理
var AJAX_FAIL = function(XMLHttpRequest, textStatus, errorThrown ) {
  toastr.error('AJAXの接続が失敗しました。', '実行失敗', {timeOut: 0});
  console.log(XMLHttpRequest);
}

// CSRFトークンを取得
module.getCsrfToken = function() {
  return $('meta[name="csrf-token"]').attr('content');
}

// 初期処理
module.init = function() {
}

var execute_flag = false;
var _action_name = '';

module.taskExecute = function(action_name, url) {
  _action_name = action_name;

  // ボタン押下
  if(execute_flag){
    return;
  }else{
    if(!window.confirm(_action_name + 'を実行しますか？')){
      return;
    }

    execute_flag = true;
    setTimeout(function() {
      execute_flag = false;
    }, 10000);

    toastr.info(_action_name + '中...', '', {timeOut: 0});
  }

  var ajaxRequest = module.getAjaxTemplate();
  ajaxRequest['url'] = url;
  ajaxRequest['headers']['x-csrf-token'] = module.getCsrfToken();

  $.ajax(ajaxRequest
  ).done(function(response, textStatus, jqXHR) {
    if(response == null){
      toastr.error('レスポンスが存在しません。', '実行失敗', {timeOut: 0});
      console.log(jqXHR);
      return;
    }
    if(response['errors'] != null){
      toastr.error(response['errors'].join(','), '実行失敗', {timeOut: 0});
      console.log(jqXHR);
      return;
    }

    if(response['data']['response'] == "ok"){
      toastr.success(_action_name + 'が完了しました。', '実行成功', {timeOut: 0});
    }else{
      toastr.error('意図しないパラメータです。', '実行失敗', {timeOut: 0});
    }
  }).fail(AJAX_FAIL);
  return false;
}

// タグのリセット
module.resetTags = function(action_name) {
  module.taskExecute(action_name, '/admin/reset_tags_ajax');
}

// ワードランキングのリセット
module.reset_word_ranking = function(action_name) {
  module.taskExecute(action_name, '/admin/reset_word_ranking');
}

return module;
}());
