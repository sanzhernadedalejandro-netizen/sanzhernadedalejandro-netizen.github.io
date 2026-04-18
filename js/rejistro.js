document.addEventListener("DOMContentLoaded", inicio);

function inicio() {
    document.getElementById("boton").addEventListener("click", verificar);
}

function verificar() {
    var nombre = document.getElementById("nombre").value;
    var contrasena = document.getElementById("contrasena").value;
    var email = document.getElementById("email").value;
    var vcontrasena = document.getElementById("vcontrasena").value;

    // Limpiar errores anteriores
    document.getElementById("errorUsuario").textContent = "";
    document.getElementById("errorEmail").textContent = "";
    document.getElementById("errorContrasena").textContent = "";
    document.getElementById("errorVerificarContrasena").textContent = "";

    var hayError = false;

    if (nombre == "" || contrasena == "" || email == "" || vcontrasena == "") {
        window.alert("Por favor, complete todos los campos");
        return;
    }

    if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{2,50}$/.test(nombre)) {
        document.getElementById("errorUsuario").textContent = "El nombre solo puede contener letras y espacios (2-50 caracteres)";
        hayError = true;
    }

    if (/[;'"\\/<>{}()\[\]|`+=\-]|(\bOR\b|\bAND\b|\bSELECT\b|\bDROP\b|\bINSERT\b|\bDELETE\b|\bUPDATE\b|\bUNION\b)/i.test(contrasena)) {
        document.getElementById("errorContrasena").textContent = "La contraseña contiene caracteres no permitidos";
        hayError = true;
    } else if (!/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[.]).{8,64}$/.test(contrasena)) {
        document.getElementById("errorContrasena").textContent = "La contraseña no cumple los requisitos: mínimo 8 caracteres, una mayúscula, una minúscula, un número y un punto (.)";
        hayError = true;
    }

    if (contrasena != vcontrasena) {
        document.getElementById("errorVerificarContrasena").textContent = "Las contraseñas no coinciden";
        hayError = true;
    }

    if (hayError) return;

    $.ajax({
        url: "../php/registro.php",
        method: "POST",
        data: { nombre: nombre, contrasena: contrasena, email: email },
        success: function (respuesta) {
            var res = JSON.parse(respuesta);
            if (res.estado == "cuenta_creada") {
                window.alert("Registro exitoso");
                window.location.href = "registroPartidas.html";
            } else if (res.estado == "existe") {
                window.alert("Ya existe una cuenta con ese nombre o email");
            } else {
                window.alert("Error en el registro");
            }
        },
        error: function () {
            window.alert("Error de conexión con el servidor");
        }
    });
}
