import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.nomeUsuario});

  final String nomeUsuario;

  List<Usuario> _usuarios = [];
  bool _carregandoUsuarios = false;
  String _temaSelecionado = 'Claro';
  bool _notificacoesAtivas = true;

  List<Usuario> get usuarios => List.unmodifiable(_usuarios);
  bool get carregandoUsuarios => _carregandoUsuarios;
  String get temaSelecionado => _temaSelecionado;
  bool get notificacoesAtivas => _notificacoesAtivas;

  Future<void> carregarPreferencias() async {
    _temaSelecionado = await PreferencesService.buscarTema();
    _notificacoesAtivas =
        await PreferencesService.buscarNotificacoes();
    notifyListeners();
  }

  Future<String?> verificarNovosUsuarios() async {
    final notificacoesAtivas =
        await PreferencesService.buscarNotificacoes();
    final usuariosAtuais = await BancoDadosLocal.query();
    final totalAtual = usuariosAtuais.length;
    final totalAnterior =
        await PreferencesService.buscarUltimoTotalUsuarios();

    if (totalAnterior == null) {
      await PreferencesService.salvarUltimoTotalUsuarios(totalAtual);
      return null;
    }

    final novosUsuarios = totalAtual - totalAnterior;
    String? mensagem;

    if (notificacoesAtivas && novosUsuarios > 0) {
      mensagem = novosUsuarios == 1
          ? 'Você tem 1 novo usuário cadastrado!'
          : 'Você tem $novosUsuarios novos usuários cadastrados!';
    }

    await PreferencesService.salvarUltimoTotalUsuarios(totalAtual);
    return mensagem;
  }

  Future<void> carregarUsuarios() async {
    _carregandoUsuarios = true;
    notifyListeners();

    try {
      _usuarios = await BancoDadosLocal.query();
    } finally {
      _carregandoUsuarios = false;
      notifyListeners();
    }
  }

  Future<String> buscarTema() => PreferencesService.buscarTema();

  Future<bool> buscarNotificacoes() =>
      PreferencesService.buscarNotificacoes();

  Future<void> alterarTema(String tema) async {
    _temaSelecionado = tema;
    notifyListeners();
    await PreferencesService.salvarTema(tema);
  }

  Future<void> alterarNotificacoes(bool ativadas) async {
    _notificacoesAtivas = ativadas;
    notifyListeners();
    await PreferencesService.salvarNotificacoes(ativadas);
  }
}
