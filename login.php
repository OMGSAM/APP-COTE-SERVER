<?php
session_start();
require 'db.php';

$num_classe = $_POST['num_classe'];
$motdepasse = $_POST['motdepasse'];

$stmt = $pdo->prepare("SELECT * FROM Classe WHERE num_classe = :num_classe AND motdepasse = :motdepasse");
$stmt->execute(['num_classe' => $num_classe, 'motdepasse' => $motdepasse]);
$classe = $stmt->fetch();

if ($classe) {
    $_SESSION['num_classe'] = $classe['num_classe'];
    header("Location: accueil.php");
    exit();
} else {
    echo "Numéro de classe ou mot de passe incorrect.";
}
?>
