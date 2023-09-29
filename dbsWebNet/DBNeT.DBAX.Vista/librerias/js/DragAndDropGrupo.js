function pageLoad() {
    $(function () {
        $("#catalog").accordion();
        $("#catalog li").draggable({
            appendTo: "body",
            helper: "clone"
        });
        $("#bodyCP_cart ol").droppable({
            activeClass: "ui-state-default",
            hoverClass: "ui-state-hover",
            accept: ":not(.ui-sortable-helper)",
            drop: function (event, ui) {

//                //alert("TEXTBOX: " + document.getElementById("bodyCP_tb_Resultados").value);
//                //alert($(this).find(".placeholder").attr('id'));
//                //alert("INDICE: " + document.getElementById("bodyCP_tb_Resultados").value.indexOf($(this).find(".placeholder").attr('id')));
//                var vStart = document.getElementById("bodyCP_tb_Resultados").value.indexOf($(this).find(".placeholder").attr('id'));
//                var vEsVacio = 1;
//                var vLoContiene = 0;

//                if (document.getElementById("bodyCP_tb_Resultados").value != 0) {
//                    vEsVacio = 0;
//                }

//                if (vStart == -1 && vEsVacio != 0) {
//                    vLoContiene = 1;
//                    vStart = document.getElementById("bodyCP_tb_Resultados").value.length;
//                } else if (vStart != -1) {
//                    vLoContiene = 1;
//                }

//                //alert("Inicio " + vStart);
//                var vFinal = document.getElementById("bodyCP_tb_Resultados").value.indexOf("/", vStart);
//                /*if (vFinal == -1) {
//                vFinal = 0;
//                }*/
//                //alert("Fin " + vFinal);
//                if (vEsVacio == 1) {
//                    //alert("El textbox esta vacio");
//                    document.getElementById("bodyCP_tb_Resultados").value = $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '/';
//                } else if (vEsVacio == 0 && vLoContiene == 0) {
//                    //alert("El textbox NO esta vacio pero no contiene la cadena");
//                    document.getElementById("bodyCP_tb_Resultados").value += $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '/';
//                } else if (vEsVacio == 0 && vLoContiene == 1) {
//                    //alert("El textbox NO esta vacio Y no contiene la cadena");
//                    document.getElementById("bodyCP_tb_Resultados").value = document.getElementById("bodyCP_tb_Resultados").value.replace(document.getElementById("bodyCP_tb_Resultados").value.substring(vStart, vFinal + 1), "") + $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '/';
//                }

                //alert(document.getElementById("bodyCP_tb_Resultados").value.replace(document.getElementById("bodyCP_tb_Resultados").value.substring(vStart, vFinal + 1), "") + $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '/');
                document.getElementById("bodyCP_tb_Resultados").value = document.getElementById("bodyCP_tb_Resultados").value + $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '/';
                var tmp = $(this).find(".placeholder").attr('id');
                //$(this).empty();
                $("<li id=\"" + tmp + "\" class=\"placeholder\"></li>").text(ui.draggable.text()).prependTo(this);
            }
        }).sortable({
            items: "li:not(.placeholder)",
            sort: function () {
                // gets added unintentionally by droppable interacting with sortable
                // using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
                $(this).removeClass("ui-state-default");
            }
        });
    });
}