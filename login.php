<?php
/**
 * KAPOOT — Login
 * Recebe POST do formulário login.html (campos: email, password, remember)
 * Sucesso → index.html?msg=login_ok&user=NOME
 * Falha   → login.html?msg=credenciais_erradas
 */
require_once __DIR__ . '/api/db.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: login.html');
    exit;
}

$email = trim($_POST['email']    ?? '');
$senha =       $_POST['password'] ?? '';

if ($email === '' || $senha === '') {
    header('Location: login.html?msg=credenciais_erradas');
    exit;
}

try {
    $pdo = db();

    // Aceita email OU nome de utilizador
    $stmt = $pdo->prepare(
        'SELECT id, nome, email, password FROM utilizadores
         WHERE email = :e OR nome = :e LIMIT 1'
    );
    $stmt->execute([':e' => $email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($senha, $user['password'])) {
        header('Location: login.html?msg=credenciais_erradas');
        exit;
    }

    // Cria sessão PHP
    $_SESSION['utilizador_id'] = (int)$user['id'];
    $_SESSION['nome']          = $user['nome'];
    $_SESSION['email']         = $user['email'];

    if (!empty($_POST['remember'])) {
        session_set_cookie_params(30 * 24 * 3600); // 30 dias
        session_regenerate_id(true);
    }

    header('Location: index.html?msg=login_ok&user=' . urlencode($user['nome']));
    exit;

} catch (PDOException $e) {
    error_log('KAPOOT login error: ' . $e->getMessage());
    header('Location: login.html?msg=credenciais_erradas');
    exit;
}
