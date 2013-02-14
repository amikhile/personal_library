//= require jquery
//= require modernizr.custom
//= require jquery_ujs
//= require_self
//= require_tree ./common
//= require_tree ./user
//= require bootstrap
//= require bootstrap-editable
//= require jquery.jstree


$(document).ready(function () {
    $('.editable a').editable();
});


$(document).ready(function () {
    $("#set_theme1").click(function () {
        $("#catalogs").jstree("set_theme", "apple");
    });
    $("#set_theme2").click(function () {
        $("#catalogs").jstree("set_theme", "default");
    });
    $("#catalogs").jstree({
        "json_data":{
            "ajax":{
                "url":"/filters/kmedia_catalogs.json",
                "data": function (n) {
                    return { catalog_id:n.attr ? n.attr("id") : ""};
                    }

}
        },
        "themes":{
            "theme":"apple",
            "icons":false,
            "dots":false
        },
        "plugins":[ "themes", "json_data", "ui", "checkbox"]
   }).bind("check_node.jstree", function(e,data) {
            var checked_ids = [];
            $("#catalogs").jstree("get_checked",null,true).each(function(){
                checked_ids.push(this.id);
            });
            document.getElementById('selected_catalogs').value = checked_ids.join(",");
    }).bind("uncheck_node.jstree", function(e,data) {
        var checked_ids = [];
        $("#catalogs").jstree("get_checked",null,true).each(function(){
            checked_ids.push(this.id);
        });
        document.getElementById('selected_catalogs').value = checked_ids.join(",");
    });
});


