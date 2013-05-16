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
    if ($("#catalogs")) {
        $("#set_theme1").click(function () {
            $("#catalogs").jstree("set_theme", "apple");
        });
        $("#set_theme2").click(function () {
            $("#catalogs").jstree("set_theme", "default");
        });
        $("#catalogs").jstree({
            "json_data":{
                "ajax":{
                    "url":"/filters/kmedia_catalogs.json?filter_id=" + $('#filters').attr("value"),
                    "data":function (n) {
                        return { catalog_id:n.attr ? n.attr("id") : ""};
                    },
                    "success":function (new_data) {
                        return new_data;
                    },
                    "correct_state":true
                }
            },
            "themes":{
                "theme":"apple",
                "icons":false,
                "dots":false
            },
            "plugins":[ "themes", "json_data", "ui", "checkbox"],
            "checkbox":{ "override_ui":true}
        })
    }

    $('[data-behaviour~=datepicker]').datepicker({"format":"yyyy-mm-dd", "weekStart":1, "autoclose":true});


    $("#check_all").click(function (event) {
        var selected = this.checked;
        // Iterate each checkbox
        $('.checkbox_column input').prop('checked', selected);
    });


    function getChecked() {
        var checked = $('.checkbox_column input:checked');
        var checked_ids = [];
        checked.each(function () {
            checked_ids.push(this.value);
        });
        var joined = checked_ids.join(",");
        return joined;
    }

    $("#submit_delete").click(function (event) {
        document.getElementById("selected_files_for_delete").value = getChecked();
    });

    $("#submit_archive").click(function (event) {
        document.getElementById("selected_files_for_archive").value = getChecked();
    });


    $('.add_to_label a').on('click', function() {
        var label = this.getAttribute("label");
        $.ajax({
            type:    "GET",
            url:     this.getAttribute("url"),
            data:    {"selected_files":  getChecked()},

            error:   function(jqXHR, textStatus, errorThrown) {
                $('#notice').html('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button>Internal server error</div>');
            },
            success: function(data, textStatus, jqXHR) {
                var checked = $('.checkbox_column input:checked');
                checked.each(function () {
                    $($(this).parent().siblings()[0]).append('&nbsp;<span class="label">'+label+'</span>');
                    $(this).prop("checked", false);
                });


            }
        });
    });


});


