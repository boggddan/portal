$(document).on("turbolinks:load",function(){$("#io_correction_products").length&&($("#main_menu li").removeClass("active"),$("#mm_instituiton_orders").addClass("active"),$("table").tableHeadFixer(),$("#date").data("old-value",$("#date").val()),$("h1").text($("h1").data("text")+" "+$("#date").val()),$("#table_io_correction_products tr td:nth-of-type(3) input").each(function(){var a=$(this);a.val();a.val()&&a.addClass(a.val()>0?"positive":"negative")}),$("#send_sa").click(function(){$("#dialog_wait").dialog("open"),$.ajax({url:$(this).data("ajax-path"),type:"POST",dataType:"script"})}),$("#date").datepicker({onSelect:function(){var a=$(this),t=a.val();if(t!=a.data("old-value")){var e=$("h1");e.text(e.data("text")+" "+t),$.ajax({url:a.data("ajax-path")+"&"+a.attr("name")+"="+t,type:"POST",dataType:"script"})}}}),$("#table_io_correction_products input").focus(function(){var a=$(this);a.data("old-value",a.val()).select(),$("#table_io_correction_products tr").removeClass("selected"),a.parents("tr").addClass("selected")}),$("#table_io_correction_products input").change(function(){var a=$(this),t=floatValue(a.data("old-value")),e=Math.trunc(1e3*floatValue(a.val()))/1e3;if(a.val(f3_to_s(e)),t!=e){a.data("old-value",e);var o=a.attr("name").split("_"),i=a,l=e,r=floatValue($("#table_io_correction_products #count_"+o[1]).html());switch(o[0]){case"diff":$("#table_io_correction_products #result_"+o[1]).val(r+l);break;case"result":l=e-r;var i=$("#table_io_correction_products #diff_"+o[1]);i.val(f3_to_s(l))}i.removeClass("positive negative"),e&&a.addClass(e>0?"positive":"negative"),$.ajax({url:i.data("ajax-path")+"&diff="+l,type:"POST",dataType:"script"})}}))});