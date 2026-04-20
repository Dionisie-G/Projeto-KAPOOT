/**
 * KAPOOT — Sistema de sessão e navegação partilhado
 * Incluído em todas as páginas como: <script src="kapoot-header.js"></script>
 *
 * FLUXO DE AUTENTICAÇÃO (PHP):
 *   login.php    → index.html?msg=login_ok&user=NOME   (sucesso)
 *                → login.html?msg=credenciais_erradas  (falha)
 *   logout.php   → index.html?msg=logout_ok
 *   register.php → login.html?msg=registo_ok           (sucesso)
 *                → register.html?msg=email_existe|user_existe|erro
 */

const Kapoot = {
  isLoggedIn: () => sessionStorage.getItem('kapoot_loggedin') === '1',
  getUser:    () => sessionStorage.getItem('kapoot_user') || '',
  login:  (user) => {
    sessionStorage.setItem('kapoot_loggedin', '1');
    sessionStorage.setItem('kapoot_user', user);
  },
  logout: () => {
    sessionStorage.removeItem('kapoot_loggedin');
    sessionStorage.removeItem('kapoot_user');
  }
};

/* ─── TOAST ─── */
let _kapootToastTimer = null;
function kapootToast(msg, dur = 3000) {
  const t = document.getElementById('kapoot-toast') || document.getElementById('toast');
  if (!t) return;
  t.textContent = msg;
  t.classList.add('show');
  clearTimeout(_kapootToastTimer);
  _kapootToastTimer = setTimeout(() => t.classList.remove('show'), dur);
}
// Alias para compatibilidade com código antigo
if (typeof window.mostrarToast === 'undefined') {
  window.mostrarToast = kapootToast;
}

/* ─── NAV ─── */
function kapootMarcarNavActivo() {
  const pagina = location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.kapoot-nav a').forEach(a => {
    const dest = a.getAttribute('href').split('/').pop();
    const isActive = dest === pagina && dest !== '#' && dest !== '';
    a.classList.toggle('active', isActive);
    if (isActive) a.setAttribute('aria-current', 'page');
    else          a.removeAttribute('aria-current');
  });
}

function kapootAtualizarNav() {
  const authLink   = document.getElementById('kpt-nav-auth');
  const perfilLink = document.getElementById('kpt-nav-perfil');
  if (!authLink) return;

  if (Kapoot.isLoggedIn()) {
    const nome = Kapoot.getUser();
    authLink.textContent = nome ? `Sair (${nome})` : 'Sair';
    authLink.href = '#';
    authLink.onclick = (e) => {
      e.preventDefault();
      if (!confirm('Tens a certeza que queres sair?')) return;
      Kapoot.logout();
      window.location.href = 'logout.php';
    };
    if (perfilLink) perfilLink.style.display = '';
  } else {
    authLink.textContent = 'Entrar';
    authLink.href = 'login.html';
    authLink.onclick = null;
    if (perfilLink) perfilLink.style.display = 'none';
  }
}

/* ─── Ler mensagens vindas do PHP via query string ─── */
function kapootProcessarParams() {
  const params = new URLSearchParams(location.search);
  const msg  = params.get('msg');
  const user = params.get('user');

  if (msg === 'login_ok') {
    Kapoot.login(user ? decodeURIComponent(user) : '');
    kapootToast(user ? `Bem-vindo de volta, ${decodeURIComponent(user)}! 👋` : 'Sessão iniciada!');
  } else if (msg === 'logout_ok') {
    Kapoot.logout();
    kapootToast('Sessão terminada. Até já! 👋');
  } else if (msg === 'registo_ok') {
    kapootToast('Conta criada com sucesso! Já podes entrar. ✅');
  } else if (msg === 'credenciais_erradas') {
    kapootToast('❌ Email ou palavra-passe incorretos.');
  } else if (msg === 'email_existe') {
    kapootToast('❌ Esse email já está registado.');
  } else if (msg === 'user_existe') {
    kapootToast('❌ Esse nome de utilizador já existe.');
  }

  if (msg) history.replaceState({}, '', location.pathname);
}

/* ─── Redirect após login (se havia destino guardado) ─── */
function kapootVerificarRedirect() {
  if (!Kapoot.isLoggedIn()) return;
  const destino = sessionStorage.getItem('kapoot_redirect');
  if (destino) {
    sessionStorage.removeItem('kapoot_redirect');
    kapootToast('A redirecionar… 🚀');
    setTimeout(() => { window.location.href = destino; }, 1200);
  }
}

/* ─── INIT ─── */
document.addEventListener('DOMContentLoaded', () => {
  kapootProcessarParams();
  kapootMarcarNavActivo();
  kapootAtualizarNav();
  kapootVerificarRedirect();
});
