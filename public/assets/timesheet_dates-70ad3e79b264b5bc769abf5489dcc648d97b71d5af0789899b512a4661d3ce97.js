$(document).on("turbolinks:load",function(){$("#timesheet_dates").length&&(filterGroupTimesheet=function(){var a=$("#group_timesheet"),t=a.val(),e=a.children("option:selected").data("field");t?a.removeClass("placeholder"):a.addClass("placeholder");var d=a.data("ajax-path")+a.data("param-name")+"="+e+"&"+a.data("param-id")+"="+t;$.ajax({url:d,type:"get",dataType:"script"})},timesheetDatesUpdate=function(a,t){var e=$("#table_timesheet_dates .table"),d=e.data("path-update")+a+"&"+e.data("param-name")+"="+t;$.ajax({url:d,type:"post",dataType:"script"})},$("#main_menu li").removeClass("active"),$("#mm_timesheets").addClass("active"),$("#date").data("old-value",$("#date").val()),$("h1").text($("h1").data("text")+" "+$("#date").val()),$("#group_timesheet").length&&filterGroupTimesheet(),$("#send_sa").click(function(){$("#dialog_wait").dialog("open"),$.ajax({url:$(this).data("ajax-path"),type:"post",dataType:"script"})}),$("#date").datepicker({onSelect:function(){var a=$(this),t=a.val();if(t!=a.data("old-value")){var e=$("h1");e.text(e.data("text")+" "+t),$.ajax({url:a.data("ajax-path")+"&"+a.attr("name")+"="+t,type:"POST",dataType:"script"})}}}),$("#date_eb, #date_ee").datepicker(),$("#create").click(function(){$("#dialog_wait").dialog("open");var a=$(this),t=$("#date_eb"),e=$("#date_ee"),d=$("#date"),i=a.data("ajax-path")+"?"+t.attr("name")+"="+t.val()+"&"+e.attr("name")+"="+e.val()+"&"+d.attr("name")+"="+d.val();$.ajax({url:i,type:"POST",dataType:"script"})}),$("#group_timesheet").change(function(){filterGroupTimesheet()}),$("#create").click(function(){$("#dialog_wait").dialog("open");var a=$(this),t=$("#date_eb"),e=$("#date_ee"),d=$("#date"),i=a.data("ajax-path")+"?"+t.attr("name")+"="+t.val()+"&"+e.attr("name")+"="+e.val()+"&"+d.attr("name")+"="+d.val();$.ajax({url:i,type:"POST",dataType:"script"})}))});