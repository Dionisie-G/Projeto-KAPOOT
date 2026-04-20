# KAPOOT — Projeto Completo

Plataforma de quizzes com **HTML + CSS + JS** no frontend e **PHP + MySQL** no backend.

## 📁 Estrutura

```
kapoot/
├── kapoot.sql              ← importa no phpMyAdmin primeiro
│
├── index.html              ← página inicial
├── login.html              ← entrar
├── register.html           ← criar conta
├── profile.html            ← perfil do utilizador
├── quiz.html               ← jogar quiz
├── create_quiz.html        ← criar quiz
├── ranking.html            ← leaderboard
│
├── kapoot-header.js        ← lógica de sessão partilhada (carregado em todos os HTML)
│
├── login.php               ← processa POST do login
├── register.php            ← processa POST do registo
├── logout.php              ← destrói sessão
│
└── api/
    ├── db.php                    ← LIGAÇÃO À BD (edita credenciais aqui)
    ├── stats.php                 ← estatísticas da homepage
    ├── profile.php               ← carregar perfil
    ├── profile_update.php        ← guardar alterações do perfil
    ├── profile_delete.php        ← apagar conta
    ├── atividade.php             ← histórico de partidas
    ├── ranking.php               ← ranking top N
    ├── guardar_resultado.php     ← gravar pontos após quiz
    └── criar_quiz.php            ← gravar quiz + perguntas + respostas
```

## ⚙️ Instalação (XAMPP / WAMP / Laragon)

1. **Copia a pasta `kapoot/`** para `htdocs/` (XAMPP) ou `www/` (WAMP/Laragon)
2. **Arranca o Apache e o MySQL** no painel do XAMPP
3. **Importa a BD**:
   - Abre `http://localhost/phpmyadmin`
   - Clica em "Importar"
   - Seleciona o `kapoot.sql` → Executar
4. **Configura as credenciais da BD**:
   - Abre `kapoot/api/db.php`
   - Por defeito: `DB_USER = 'root'`, `DB_PASS = ''` (funciona no XAMPP sem alterar nada)
5. **Acede no browser**: `http://localhost/kapoot/index.html`

## 🔐 Como funciona a autenticação

1. Utilizador preenche `register.html` → POST para **`register.php`** → grava em `utilizadores` → redireciona para `login.html?msg=registo_ok`
2. Utilizador preenche `login.html` → POST para **`login.php`** → verifica password com `password_verify()` → cria `$_SESSION` → redireciona para `index.html?msg=login_ok&user=NOME`
3. O **`kapoot-header.js`** lê o `msg` da URL e guarda `sessionStorage` no browser
4. Páginas protegidas (`profile.html`, `create_quiz.html`) verificam `Kapoot.isLoggedIn()` e redirecionam para login se falhar
5. Endpoints `api/*.php` verificam `$_SESSION['utilizador_id']` no servidor (defesa em profundidade)

## 🔗 Tudo está interligado

| Ficheiro | Liga a | Como |
|----------|--------|------|
| Todos os HTML | `index.html` | Logo clicável |
| `login.html` | `login.php` → `index.html` | Form submit |
| `register.html` | `register.php` → `login.html` | Form submit |
| `index.html` | `quiz.html` / `login.html` | Botão "Começar Quiz" |
| `quiz.html` | `api/guardar_resultado.php` | Ao terminar quiz |
| `profile.html` | `api/profile*.php` | Fetch dinâmico |
| `ranking.html` | `api/ranking.php` | Fetch dinâmico |
| `create_quiz.html` | `api/criar_quiz.php` | Ao finalizar |
| `index.html` | `api/stats.php` | Mostra contadores reais |

## 🎨 Header Unificado

Todas as 7 páginas têm o **mesmo header** (o do `profile.html` com o logo animado KA+POOT+ponto pulsante). A navegação é:

- **Início** · **Ranking** · **Jogar** · **Criar Quiz** · **Perfil** (só se logado) · **Entrar** / **Sair**

A página atual fica automaticamente destacada a amarelo.

## 🧪 Como testar

1. Abre `http://localhost/kapoot/register.html` e cria uma conta
2. Entra em `login.html`
3. Vai ao `profile.html` → vê dados reais da BD
4. Joga um quiz em `quiz.html` → pontos guardados na BD
5. Vai a `ranking.html` → aparece na lista
6. Cria um quiz em `create_quiz.html` → fica guardado

## 📝 Notas técnicas

- **Passwords**: guardadas com `password_hash(PASSWORD_BCRYPT)`, nunca em texto puro
- **SQL Injection**: todas as queries usam `PDO prepared statements`
- **Sessões**: PHP `$_SESSION` + `sessionStorage` no cliente (sincronizados via query string)
- **XSS**: dados da BD são escapados no JS antes de renderizar
- **MyISAM**: as tabelas usam MyISAM (como no teu `kapoot.sql` original)

© 2026 KAPOOT
