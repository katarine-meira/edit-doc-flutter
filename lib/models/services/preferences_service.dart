import 'package:flutter/material.dart';

class PreferencesService {
  static final Map<String, dynamic> _dados = {};

  static final ValueNotifier<ThemeMode> temaAtual =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> carregarTema() async {
    final temaSalvo = _dados['tema'] ?? 'Claro';
    temaAtual.value =
        temaSalvo == 'Escuro' ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> salvarTema(String tema) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _dados['tema'] = tema;
    temaAtual.value =
        tema == 'Escuro' ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<String> buscarTema() async {
    return _dados['tema'] ?? 'Claro';
  }

  static Future<void> salvarNotificacoes(bool ativadas) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _dados['notificacoes'] = ativadas;
  }

  static Future<bool> buscarNotificacoes() async {
    return _dados['notificacoes'] ?? true;
  }

  static Future<int?> buscarUltimoTotalUsuarios() async {
    return _dados['ultimoTotalUsuarios'] as int?;
  }

  static Future<void> salvarUltimoTotalUsuarios(int total) async {
    _dados['ultimoTotalUsuarios'] = total;
  }
}
