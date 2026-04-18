document.addEventListener("DOMContentLoaded", inicio);
function inicio() {
    verificacionSesion(function(estado) {
        if (estado == "ok") {
            mostrarPartidas();
            document.getElementById("Cpartoda").addEventListener("click", crearPartida);
            document.getElementById("inciar").addEventListener("click", inicioPartida);
            document.getElementById("eliminar").addEventListener("click", eliminarPartida);
        } else {
            window.location.href = "../index.html";
        }
    });
}
function crearPartida() {
    window.location.href = "crearPartida.html";

}
function incioPatida(){


}
function eliminarPartida(){

} 
function verifacacionSesion(callback){
    $.ajax({
        url:"../php/verificacion_sesion.php",
        method: "GET",
        success:function(respuesta){
            var resutado=JSON.parse(respuesta);
            callback(resutado.estado);
            //return respuesta["estado"];
        },
        error: function() {
            callback("error");
        }
    });
}
function idUsuario(){

}

function mostrarPartidas(){

}