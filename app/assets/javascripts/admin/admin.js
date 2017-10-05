'use strict';

var modules = modules || {};

modules.admin = (function () {
var module = {}

// 選択されたフォルダデータ
module.selected_file_data = [];

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

// 初期処理
module.init = function() {
  var click_flag = false;
  // 最新への更新
  $('#fetch_recent_list').on('click', function(){
    if(!click_flag){
      click_flag = true;
      setTimeout(function() {
        click_flag = false;
      }, 10000);
      module.fetchTreeDataWithAjax();
    }else{
      alert('ツリー構築中...');
    }
  });

  var delete_flag = false;
  // 削除ボタン押下
  $('#obj_delete_btn').on('click', function(){
    if(!delete_flag){
      delete_flag = true;
      setTimeout(function() {
        delete_flag = false;
      }, 10000);
      module.deleteTreeObjectWithAjax(module.selected_file_data);
    }else{
      alert('削除中...');
    }
  });
}

// ツリーを作成する
module.makeJstree = function(dataTree) {
  $('#folder-tree').remove();
  $('#folder-tree-wrap').append('<div id="folder-tree"></div>');
  // FIXME: 最初は上階層しか表示せずに、下階層はAjaxで取得できるようにしたい
  // http://final.hateblo.jp/entry/2016/01/13/212400
  $('#folder-tree').jstree({
    'core' : {
      // ドラッグ＆ドロップ
      // 'check_callback' : true,
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
    // 'plugins' : ["checkbox", "wholerow", "dnd"],
  });

  $('#folder-tree').jstree("refresh");

  // 選択されたファイルのリスト保管する
  $('#folder-tree').on("changed.jstree", function(e, data) {
    module.selected_file_data = [];
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
      module.selected_file_data[i] = objTreeView.jstree(true).get_path(full_node, "/").replace(/ \(\d+\)\//g, '/').replace(/ \(\d+\)$/g, '');
    }
    // Convert the array to a JSON string so that we can pass the data back to the server 
    // once the user submits the form data
    // console.log(JSON.stringify(module.selected_file_data));
  });

  // // ドラッグドロップ
  // $('#folder-tree').on("move_node.jstree", function(e, n) {
  //   var message = '本当に移動しますか？'
  //                 + '旧フォルダ: ' + n.old_parent
  //                 + '新フォルダ: ' + n.parent;
  //   if(!confirm(message)){
  //     return false;
  //   }

  //   console.log("n.node:" + JSON.stringify(n.node));
  //   console.log("n.old_parent:" + n.old_parent);
  //   console.log("n.old_position:" + n.old_position);
  //   console.log("n.parent:" + n.parent);
  //   console.log("n.position:" + n.position);
  // });
}

// TODO: 余裕があるときに作成する
// ツリーデータを移動する。AJAX
module.moveTreeDataWithAjax = function(old_parent, new_parent) {
}

// ツリーデータをAJAXにより取得する
module.fetchTreeDataWithAjax = function() {
  var ajaxRequest = module.getAjaxTemplate();
  ajaxRequest['url'] = '/admin/fetch_tree_datas_ajax';
  ajaxRequest['headers']['x-csrf-token'] = module.getCsrfToken();

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
    // コンテナ情報を設定する
    var metadata = response.data.container_metadata;
    $('#info-name').text(metadata.name);
    $('#info-capacity').text(metadata.bytes);
    $('#info-item-num').text(metadata.count);
    $('#info-metadata').text(metadata.metadata);

    $('#cache-name').text(response.data.file_stamp);

    // ツリー再構築
    console.log('tree再構築');
    module.makeJstree(response.data.js_tree);

  }).fail(AJAX_FAIL);
}

// 対象のオブジェクトを削除する
module.deleteTreeObjectWithAjax = function(selected_file_data) {
  var data = { admin: {
    file_paths: selected_file_data,
  }};

  var ajaxRequest = module.getAjaxTemplate();
  ajaxRequest['type'] = 'post';
  ajaxRequest['url'] = '/admin/delete_objects_ajax';
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
    var err_message = "";
    if(response['data']['no_exist_objects'].length > 0){
      err_message = "存在しないパス: " + response['data']['no_exist_objects'].join(',')
    }
    var ignore_message = "";
    if(response['data']['ignore_objects'].length > 0){
      ignore_message += "無視したパス: " + response['data']['ignore_objects'].join(',')
    }
    if(err_message == ""){
      if(ignore_message != ""){
        alert(ignore_message);
      }
      alert("削除が成功しました。ツリーのリロードを行います。");
      module.fetchTreeDataWithAjax();
    }else{
      alert(message + ignore_message);
    }
  }).fail(AJAX_FAIL);
}

return module;
}());