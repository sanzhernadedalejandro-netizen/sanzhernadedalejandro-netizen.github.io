<?php
$usuario=$_POST["idUser"];
$pdo = new PDO("mysql:host=localhost;dbname=proyectp_roll", "root", "", [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$sql= $pdo->prepare("SELECT * from usuario_partidas where id_usuario=?");
$sql->execute([$usuario]);
$partida=$sql->fetch(PDO::FETCH_ASSOC);
echo json_encode($partida);
?>