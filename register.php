<?php
/**
 * KAPOOT — Registo
 * Recebe POST do formulário register.html (nome, email, usuario, senha, confirmarSenha, termos)
 * Sucesso → login.html?msg=registo_ok
 * Falha   → register.html?msg=email_existe | user_existe | erro
 */
require_once __DIR__ . '/api/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: register.html');
    exit;
}

$nome    = trim($_POST['nome']            ?? '');
$email   = trim($_POST['email']           ?? '');
$usuario = trim($_POST['usuario']         ?? '');
$senha   =      $_POST['senha']           ?? '';
$confirm =      $_POST['confirmarSenha']  ?? '';
$termos  = !empty($_POST['termos']);

if ($nome === '' || $email === '' || $usuario === '' || $senha === '' || !$termos) {
    header('Location: register.html?msg=erro');
    exit;
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    header('Location: register.html?msg=erro');
    exit;
}
if (strlen($usuario) < 4 || strlen($senha) < 8 || $senha !== $confirm) {
    header('Location: register.html?msg=erro');
    exit;
}

try {
    $pdo = db();

    $st = $pdo->prepare('SELECT id FROM utilizadores WHERE email = ? LIMIT 1');
    $st->execute([$email]);
    if ($st->fetch()) {
        header('Location: register.html?msg=email_existe');
        exit;
    }

    $st = $pdo->prepare('SELECT id FROM utilizadores WHERE nome = ? LIMIT 1');
    $st->execute([$usuario]);
    if ($st->fetch()) {
        header('Location: register.html?msg=user_existe');
        exit;
    }

    $hash = password_hash($senha, PASSWORD_BCRYPT);
    $st = $pdo->prepare(
        'INSERT INTO utilizadores (nome, email, password) VALUES (?, ?, ?)'
    );
    $st->execute([$usuario, $email, $hash]);

    header('Location: login.html?msg=registo_ok');
    exit;

} catch (PDOException $e) {
    error_log('KAPOOT register error: ' . $e->getMessage());
    header('Location: register.html?msg=erro');
    exit;
}
