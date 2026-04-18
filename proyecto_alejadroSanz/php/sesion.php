<?php
    session_start();

    $nombre = $_POST['nombre'];
    $contrasena = $_POST['contrasena'];

    $pdo = new PDO("mysql:host=localhost;dbname=proyectp_roll", "root", "", [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

    // Buscar usuario por nombre
    $sql = $pdo->prepare("SELECT idUsuario, nombre, contrasena FROM usuario WHERE nombre = ?");
    $sql->execute([$nombre]);
    $cuenta = $sql->fetch(PDO::FETCH_ASSOC);

    if ($cuenta && password_verify($contrasena, $cuenta['contrasena'])) {
        // Guardar datos de sesión
        $_SESSION['idUsuario'] = $cuenta['idUsuario'];
        $_SESSION['nombre'] = $cuenta['nombre'];

        // Actualizar estado a activo
        $modificar = $pdo->prepare("UPDATE usuario SET estado='activo' WHERE idUsuario = ?");
        $modificar->execute([$cuenta['idUsuario']]);

        echo json_encode(["estado" => "exito"]);
    } else {
        echo json_encode(["estado" => "error"]);
    }
?>
