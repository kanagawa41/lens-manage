var Admin = function() {
  this.dataTree = null
}

Admin.init = function() {
  this.initElements();
}

Admin.initElements = function() {
  dataTree = this.dataTree;
console.log(dataTree);
  $('#jstree_demo_div').jstree({ 'core' : {
    // 'data' : [
    //    { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
    //    { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
    //    { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
    //    { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
    //    { "id" : "ajson5", "parent" : "ajson2", "text" : "Child 2" },
    //    { "id" : "ajson6", "parent" : "#", "text" : "Origin" },
    //    { "id" : "ajson7", "parent" : "ajson6", "text" : "file" },
    //    { "id" : "ajson8", "parent" : "ajson7", "text" : "file" },
    // ]
    'data' : 
      dataTree
  } });
}