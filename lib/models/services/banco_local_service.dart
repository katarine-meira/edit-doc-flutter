import '../usuario.dart';

class BancoDadosLocal {
  static final List<Usuario> _usuarios = [];

  // Cadastra um usuário. Retorna false se o e-mail já existir.
  static Future<bool> insert(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final existe = _usuarios.any(
      (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
    );

    if (existe) return false;

    _usuarios.add(usuario);
    return true;
  }

  // Retorna uma cópia da lista de usuários.
  static Future<List<Usuario>> query() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Usuario>.from(_usuarios);
  }

  // Confere e-mail e senha.
  static Future<Usuario?> login(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() == email.toLowerCase() &&
          usuario.senha == senha) {
        return usuario;
      }
    }

    return null;
  }
}
