<?php
    $nombre = $_POST['nombre'];
    $contrasena = $_POST['contrasena'];
    $email = $_POST['email'];
    $estadoUsuario = "activo";

    $pdo = new PDO("mysql:host=localhost;dbname=proyectp_roll", "root", "", [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

    // Comprobar si ya existe el usuario o el email
    $sql = $pdo->prepare("SELECT nombre, correo FROM usuario WHERE nombre = ? OR correo = ?");
    $sql->execute([$nombre, $email]);
    $cuenta = $sql->fetch(PDO::FETCH_ASSOC);

    if ($cuenta) {
        echo json_encode(["estado" => "existe"]);
    } else {
        // Guardar la contraseña con hash seguro
        $contrasenaHash = password_hash($contrasena, PASSWORD_DEFAULT);

        $insert = $pdo->prepare("INSERT INTO usuario (nombre, correo, estado, contrasena) VALUES (?, ?, ?, ?)");
        $insert->execute([$nombre, $email, $estadoUsuario, $contrasenaHash]);
        echo json_encode(["estado" => "cuenta_creada"]);
    }
?>
