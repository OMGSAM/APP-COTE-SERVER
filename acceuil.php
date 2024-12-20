<?php
session_start();
if (!isset($_SESSION['num_classe'])) {
    header("Location: login.php");
    exit();
}

require 'db.php';

$num_classe = $_SESSION['num_classe'];

$stmt = $pdo->prepare("SELECT * FROM Classe WHERE num_classe = :num_classe");
$stmt->execute(['num_classe' => $num_classe]);
$classe = $stmt->fetch();

echo "<h1>Bienvenue, Classe " . htmlspecialchars($classe['nom_classe']) . "</h1>";

$stmt = $pdo->prepare("SELECT * FROM Module WHERE num_classe = :num_classe");
$stmt->execute(['num_classe' => $num_classe]);
$modules = $stmt->fetchAll();

echo "<h2>Modules :</h2>";
echo "<ul>";
foreach ($modules as $module) {
    echo "<li>" . htmlspecialchars($module['nom_module']) . " (" . $module['masse_horaire_prevue'] . " heures)</li>";
}
echo "</ul>";
?>
<a href="logout.php">Se déconnecter</a>
