document.addEventListener("DOMContentLoaded", inicio);
function inicio() {
    document.getElementById("boton").addEventListener("click", verificar); // llama a la función guardardatos al hacer clic en el botón "Guardar"
}
function verificar() {
    var nombre = document.getElementById("usuario").value;
    var contraseña = document.getElementById("contrasena").value;
    if(nombre == "" || contraseña == ""){
        alert("Por favor, complete todos los campos");
        return; // Detiene la ejecución si algún campo está vacío       
    }
    $.ajax({ 
        url:"../php/sesion.php",
        method:"POST",
        data:{nombre:nombre, contraseña:contraseña},
        success:function(respuesta){
            if(respuesta == "exito"){
                alert("Inicio de sesión exitoso");
                window.location.href = "registrospartidas.html"; // Redirige a la página de inicio después del inicio de sesión exitoso
            } else {
                window.alert("Error en el inicio de sesión: la contraseña o el ususario son incorrectos");
            }
        }
    });
}
