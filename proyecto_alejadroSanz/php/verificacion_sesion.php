<?php
    session_start();
    if(!isset($_SESSION['nombre'])){
        echo json_encode(["estado" => "error","mensage"=>"No hay sesión activa"]);
    }
    try{
    $nombre = $_SESSION['nombre'];
    $pdo = new PDO("mysql:host=localhost;dbname=proyectp_roll", "root", "", [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $sql = $pdo->prepare("UPDATE usuario SET ultima_actividad = NOW() WHERE idUsuario = ?");
    $sql->execute([$_SESSION['idUsuario']]);
    $cuenta = $sql->fetch(PDO::FETCH_ASSOC);
    echo json_encode(["estado" => "ok"]);
    }catch(PDOException $e){
         echo json_encode(["estado" => "error","mensage"=>"Error de base de datos"]);
    }
    
?>
