/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/*
 * 
 * @returns {undefined}
 */
function tabular(e, obj) {
    tecla = (document.all) ? e.keyCode : e.which;
    if (tecla !== 13)
        return;
    frm = obj.form;
    for (i = 0; i < frm.elements.length; i++)
        if (frm.elements[i] === obj)
        {
            if (i === frm.elements.length - 1)
                i = -1;
            break
        }
    /*ACA ESTA EL CAMBIO*/
    if (frm.elements[i + 1].disabled === true)
        tabular(e, frm.elements[i + 1]);
    else
        frm.elements[i + 1].focus();
    return false;
}

function isNumberKey(evt, obj) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode === 13 || charCode > 31 && (charCode < 48 || charCode > 57)) {
        if (charCode === 13) {
            frm = obj.form;
            for (i = 0; i < frm.elements.length; i++)
                if (frm.elements[i] === obj)
                {
                    if (i === frm.elements.length - 1)
                        i = -1;
                    break
                }
            /*ACA ESTA EL CAMBIO*/
            if (frm.elements[i + 1].disabled === true)
                tabular(e, frm.elements[i + 1]);
            else
                frm.elements[i + 1].focus();
            return false;
        }
        return false;
    }
    return true;
}

$(document).ready(function () {
    $('#cla_pro').focus();

    $('#btn_descripcion').click(function () {
        var idUni=$('#uniO').val();
        var dir = '../Transferencias?que=desc&desPro=' + $('#des_pro').val()+'&uniO='+idUni;
        if ($('#des_pro').val() === "") {
            alert("Capture el Medicamento");
            $('#des_pro').focus();
        } else {
            $.ajax({
                url: dir,
                success: function (data) {
                    dameProducto(data);
                },
                error: function () {
                    alert("Ha ocurrido un error - clave");
                }
            });
            function dameProducto(data) {
                var json = JSON.parse(data);
                var cla = json[0].cla;
                var lote = json[0].lote;
                $("#cla_pro").val(cla);
                for (var i = 0; i < json.length; i++) {
                    if (cla === "null" || cla === "" || cla === "undefined") {
                        alert('Insumo fuera de Catálogo');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#lote").find('option').remove();
                        $("#lote").attr("disabled", true);
                        $("#origen").attr("disabled", true);
                        $("#des_pro").focus();
                    } else if (lote === "<option value='null'>null</option>") {
                        alert('Insumo Sin Lote');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#lote").find('option').remove();
                        $("#lote").attr("disabled", true);
                        $("#origen").attr("disabled", true);
                        $("#des_pro").focus();
                    } else {
                        $('#caduc').val(json[0].caduc);
                        $("#lote option").remove();
                        $('#lote').append(lote);
                        $("#lote").attr("disabled", false);
                        $("#origen").attr("disabled", false);
                        $("#lote").focus();
                    }
                }
            }
        }
    });

    $('#btn_clave').click(function () {
        var idUni=$('#uniO').val();
        var dir = '../Transferencias?que=clave&claPro=' + $('#cla_pro').val()+'&uniO='+idUni;
        if ($('#cla_pro').val() === "") {
            alert("Capture una clave");
            $('#cla_pro').focus();
        } else {
            $.ajax({
                url: dir,
                success: function (data) {
                    dameProducto(data);
                },
                error: function () {
                    alert("Ha ocurrido un error - clave");
                }
            });
            function dameProducto(data) {
                var json = JSON.parse(data);
                var descripcion = json[0].desc;
                var lote = json[0].lote;
                $("#des_pro").val(descripcion);
                for (var i = 0; i < json.length; i++) {
                    if (descripcion === "null" || descripcion === "" || descripcion === "undefined") {
                        alert('Clave fuera de Catálogo');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#lote").find('option').remove();
                        $("#lote").attr("disabled", true);
                        $("#origen").attr("disabled", true);
                        $("#cla_pro").focus();
                    } else if (lote === "<option value='null'>null</option>") {
                        alert('Insumo Sin Lote');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#lote").find('option').remove();
                        $("#lote").attr("disabled", true);
                        $("#origen").attr("disabled", true);
                        $("#cla_pro").focus();
                    } else {
                        $('#caduc').val(json[0].caduc);
                        $("#lote option").remove();
                        $('#lote').append(lote);
                        $("#lote").attr("disabled", false);
                        $("#origen").attr("disabled", false);
                        $("#lote").focus();
                    }
                }
            }
        }
    });

    $('#lote').change(function () {
        var lote = $('#lote').val();
        var dir = '../Transferencias?que=lote&lote='+lote;
        $.ajax({
            url: dir,
            success: function (data) {
                var json = JSON.parse(data);
                $('#caduc').val(json[0].caduc);
            },
            error: function () {
                $('#caduc').val("Error");
            }
        });
    });
    $('#origen').change(function () {
        var origen = $('#origen').val();
        var lote = $('#lote').val();
        var uni=$('#uniO').val();
        if(origen===""){
            alert("Seleccione un Origen");
            $('#origen').focus();
            return false;
        }
        var dir = '../Transferencias?que=origen&origen='+origen+'&detPro='+lote+'&uni='+uni;
        $.ajax({
            url: dir,
            success: function (data) {
                var json = JSON.parse(data);
                $('#exis').val(json[0].exis);
                $('#cant').attr("disabled", false);
                $('#uni').attr("disabled", false);
                $('#justi').attr("disabled", false);
                $('#btnEnviar').attr("disabled", false);
            },
            error: function () {
                $('#exis').val("Error");
            }
        });
    });
    $('#btnEnviar').click(function(){
        var cant=0;
        var exis=0;
        cant=$('#cant').val();
        exis=$('#exis').val();
       if($('#justi').val()==="" ||$('#uni').val()===""||$('#cant').val()===""){
           alert("Hay Campos Vacios, Favor Verificar");
           return false;
       }
       if(parseInt(cant)>parseInt(exis)){
            alert("Cantidad Mayor que Existencias");
            return false;
       }
    });
});
