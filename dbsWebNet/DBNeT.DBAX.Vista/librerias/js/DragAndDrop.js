/// <reference path="../jquery/1.9.0/jquery-1.9.0.js" />

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
                var vStart = document.getElementById("bodyCP_tb_Resultados").value.indexOf($(this).find(".placeholder").attr('id'));
                var vEsVacio = 1;
                var vLoContiene = 0;
                var vVariable = $(this).find(".placeholder").attr('id').substring(0, 6);

                if (document.getElementById("bodyCP_tb_Resultados").value != 0) {
                    vEsVacio = 0;
                }

                if (vStart == -1 && vEsVacio != 0) { //Esta vacio - 1ra variable
                    vLoContiene = 1;
                    vStart = document.getElementById("bodyCP_tb_Resultados").value.length;
                } else if (vStart != -1) { 
                    vLoContiene = 1;
                }

                var vFinal = document.getElementById("bodyCP_tb_Resultados").value.indexOf("/", vStart);

                //document.getElementById("ConceptoVariable" + vVariable).value = "[" + document.getElementById("bodyCP_tb_" + ui.draggable.attr('id')).innerText + "]";
                $("#ConceptoVariable" + vVariable).html = "[" + document.getElementById("bodyCP_tb_" + ui.draggable.attr('id')).innerText + "]";

                if (vEsVacio == 1) {
                    //alert("El textbox esta vacio");
                    document.getElementById("bodyCP_tb_Resultados").value = $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '|' + document.getElementById("bodyCP_select_" + $(this).find(".placeholder").attr('id').toString().replace("bodyCP_", "")).value + '/';
                } else if (vEsVacio == 0 && vLoContiene == 0) {
                    //alert("El textbox NO esta vacio pero no contiene la cadena");
                    document.getElementById("bodyCP_tb_Resultados").value += $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '|' + document.getElementById("bodyCP_select_" + $(this).find(".placeholder").attr('id').toString().replace("bodyCP_", "")).value + '/';
                } else if (vEsVacio == 0 && vLoContiene == 1) {
                    //alert("El textbox NO esta vacio Y contiene la cadena");
                    document.getElementById("bodyCP_tb_Resultados").value = document.getElementById("bodyCP_tb_Resultados").value.replace(document.getElementById("bodyCP_tb_Resultados").value.substring(vStart, vFinal + 1), "") + $(this).find(".placeholder").attr('id') + '|' + ui.draggable.attr('id') + '|' + document.getElementById("bodyCP_select_" + $(this).find(".placeholder").attr('id').toString().replace("bodyCP_", "")).value + '/';
                }

                var tmp = $(this).find(".placeholder").attr('id');
                $(this).empty();
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

function actualizaPeriodo(idContenedor, variable) {
    cadenaParcial = document.getElementById('bodyCP_tb_Resultados').value.substring(document.getElementById('bodyCP_tb_Resultados').value.indexOf(idContenedor), document.getElementById('bodyCP_tb_Resultados').value.indexOf('/', document.getElementById('bodyCP_tb_Resultados').value.indexOf(idContenedor)))
    //alert(cadenaParcial);
    //inicio = cadenaParcial.lastIndexOf('|');
    inicio = cadenaParcial.lastIndexOf('|', cadenaParcial.lastIndexOf('|', cadenaParcial.lastIndexOf('|') - 1) - 1);
    //alert(inicio);
    final = cadenaParcial.length;
    //alert(final);
    contextoAntiguo = cadenaParcial.substring(inicio + 1, final);
    //alert(contextoAntiguo);
    contextoNuevo = document.getElementById("bodyCP_select_" + variable).value;
    //alert(contextoNuevo);
    cadenaNueva = cadenaParcial.replace(contextoAntiguo, contextoNuevo);
    //alert(cadenaNueva);
    if (cadenaParcial.length > 0) {
        document.getElementById("bodyCP_tb_Resultados").value = document.getElementById("bodyCP_tb_Resultados").value.replace(cadenaParcial, cadenaNueva);
    }
}