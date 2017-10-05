'use strict';

var modules = modules || {};

modules.admin = (function () {
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
  alert('AJAXの接続が失敗しました。');
}

// CSRFトークンを取得
module.getCsrfToken = function() {
  return $('meta[name="csrf-token"]').attr('content');
}

module.init = function() {
}

// ツリーを作成する
module.makeJstree = function(dataTree) {
  // FIXME: 最初は上階層しか表示せずに、下階層はAjaxで取得できるようにしたい
  // http://final.hateblo.jp/entry/2016/01/13/212400
  $('#folder-tree').jstree({
    'core' : {
      'themes': {'stripes':true},
      // 'data' : [
      //    { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
      //    { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
      //    { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
      //    { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
      //    { "id" : "ajson6", "parent" : "#", "text" : "Origin" },
      //    { "id" : "ajson7", "parent" : "ajson6", "text" : "file" },
      //    { "id" : "ajson8", "parent" : "ajson7", "text" : "file" },
      // ]
      'data': dataTree,
    },
    'plugins' : ["checkbox", "wholerow"],
  });

  // 選択されたファイルのリスト保管する
  var selected_file_data = [];
  $('#folder-tree').on("changed.jstree", function (e, data) {
    selected_file_data = [];
    // object that represents the DIV for the jsTree
    var objTreeView = $("#folder-tree");
    // returns a list of <li> ID's that have been sected by the user
    var selectedNodes = objTreeView.jstree(true).get_selected();
    // This is the best way to loop object in javascript
    for (var i = 0; i < selectedNodes.length; i++) {
      // get the actual node object from the <li> ID
      var full_node = objTreeView.jstree(true).get_node(selectedNodes[i]);
      // Get the full path of the selected node and put it into an array
      // 下記のようにフォルダ名後ろのファイル数は削除する。
      // development* (1)/lens-manage (1)/production/DKC (1)/DKC_16150.jpg
      // development* (1)
      // FIXME: フォルダのみのパスは除外する必要がある。
      selected_file_data[i] = objTreeView.jstree(true).get_path(full_node, "/").replace(/ \(\d+\)\//g, '/').replace(/ \(\d+\)$/g, '');
    }
    // Convert the array to a JSON string so that we can pass the data back to the server 
    // once the user submits the form data
    // console.log(JSON.stringify(selected_file_data));
  });

  // 選択された
  $('#obj_delete_btn').on('click', function(){
    module.clickDeleteBtn(selected_file_data);
    // console.log(JSON.stringify(selected_file_data));
  });
}

// 対象のオブジェクトを削除する
module.clickDeleteBtn = function(selected_file_data) {
  var data = { admin: {
    file_paths: selected_file_data,
  }};

  var ajaxRequest = module.getAjaxTemplate();
  ajaxRequest['type'] = 'post';
  ajaxRequest['url'] = '/admin/delete_objects';
  ajaxRequest['headers']['x-csrf-token'] = module.getCsrfToken();
  ajaxRequest['data'] = JSON.stringify(data);

  $.ajax(ajaxRequest
  ).done(function(response, textStatus, jqXHR) {
    if(response == null){
      alert('AJAXの接続が失敗しました。');
      console.log(jqXHR);
      return;
    }
    if(response['errors'] != null){
      alert(response['errors'].join(','));
      console.log(jqXHR);
      return;
    }
    var message = "";
    if(response['data']['no_exist_objects'].length > 0){
      message += "存在しないパス: " + response['data']['no_exist_objects'].join(',')
    }
    if(response['data']['ignore_objects'].length > 0){
      message += "無視したパス: " + response['data']['ignore_objects'].join(',')
    }
    if(message == ""){
      alert("削除が成功しました。OKを押下するとリロードを行います。");
      location.href = $('#fetch_recent_list').attr("href");
    }else{
      alert(message);
    }
  }).fail(AJAX_FAIL);
}

return module;
}());