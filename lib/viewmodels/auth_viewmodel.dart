import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool _carregando = false;
  Usuario? _usuarioAutenticado;
  String _temaSelecionado = 'Claro';
  bool _notificacoesAtivas = true;

  bool get carregando => _carregando;
  Usuario? get usuarioAutenticado => _usuarioAutenticado;
  String get temaSelecionado => _temaSelecionado;
  bool get notificacoesAtivas => _notificacoesAtivas;

  void selecionarTema(String tema) {
    _temaSelecionado = tema;
    notifyListeners();
  }

  void alterarNotificacoes(bool ativadas) {
    _notificacoesAtivas = ativadas;
    notifyListeners();
  }

  void _alterarCarregamento(bool valor) {
    _carregando = valor;
    notifyListeners();
  }

  // Retorna null quando o login é realizado com sucesso.
  Future<String?> fazerLogin(String email, String senha) async {
    _alterarCarregamento(true);

    try {
      _usuarioAutenticado = await BancoDadosLocal.login(
        email.trim(),
        senha,
      );

      if (_usuarioAutenticado == null) {
        return 'E-mail ou senha incorretos.';
      }

      return null;
    } finally {
      _alterarCarregamento(false);
    }
  }

  // Retorna null quando o cadastro é realizado com sucesso.
  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String tema,
    required bool notificacoes,
  }) async {
    _alterarCarregamento(true);

    try {
      final usuario = Usuario(
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
      );

      final cadastrado = await BancoDadosLocal.insert(usuario);

      if (!cadastrado) {
        return 'Este e-mail já está cadastrado!';
      }

      await PreferencesService.salvarTema(tema);
      await PreferencesService.salvarNotificacoes(notificacoes);

      _usuarioAutenticado = usuario;
      return null;
    } finally {
      _alterarCarregamento(false);
    }
  }
}
