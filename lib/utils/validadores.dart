String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu nome completo';
  }

  if (value.trim().length < 3) {
    return 'O nome deve ter pelo menos 3 caracteres';
  }

  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu e-mail';
  }

  final email = value.trim();

  if (email.split('@').length != 2) {
    return 'Informe um e-mail válido';
  }

  final partes = email.split('@');
  final usuario = partes[0];
  final dominio = partes[1].toLowerCase();

  if (usuario.isEmpty ||
      dominio.isEmpty ||
      !dominio.contains('.') ||
      !(dominio.endsWith('.com') || dominio.endsWith('.com.br'))) {
    return 'Utilize um e-mail com domínio .com ou .com.br';
  }

  if (dominio.startsWith('.') || dominio.contains('..')) {
    return 'Informe um domínio válido';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }

  return null;
}
