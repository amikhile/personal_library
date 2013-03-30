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
                "url":"/filters/kmedia_catalogs.json?filter_id="+document.getElementById('filters').getAttribute("value"),
                "data": function (n) {
                    return { catalog_id:n.attr ? n.attr("id") : ""};
                    },
                "success": function (new_data) {
                    return new_data;
                },
                "correct_state" : true
            }
        },
        "themes":{
            "theme":"apple",
            "icons":false,
            "dots":false
        },
        "plugins":[ "themes", "json_data", "ui", "checkbox"],
        "checkbox": { "override_ui" : true}
    })

    $('[data-behaviour~=datepicker]').datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true});
});


