'use strict';

var modules = modules || {};

modules.lensLists = (function () {
var module = {}

module.init = function() {
  $('#detail_search').on('click', function(){
    $('#modal_box').modal('show');
  });

  // 詳細で検索
  $('#detail_search_btn').on('click', function(){
    $('#search_exec').click();
  });

  // 条件のリセット
  $('#detail_reset_btn').on('click', function(){
    $('#min_price').val('');
    $('#max_price').val('');
    $('#tag').val(null).trigger("change");
  });

  $('#tag').select2({
    width: 500,
    allowClear: true
  });
}

return module;
}());
