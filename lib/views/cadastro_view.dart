import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _viewModel = AuthViewModel();

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final erro = await _viewModel.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      tema: _viewModel.temaSelecionado,
      notificacoes: _viewModel.notificacoesAtivas,
    );

    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário cadastrado com sucesso!'),
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: _viewModel.usuarioAutenticado!.nome,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Criar conta'),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 64,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Crie sua conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: validarNome,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: validarEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: validarSenha,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Preferências iniciais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile<String>(
                        title: const Text('Tema claro'),
                        value: 'Claro',
                        groupValue: _viewModel.temaSelecionado,
                        onChanged: (valor) {
                          if (valor == null) return;
                          _viewModel.selecionarTema(valor);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Tema escuro'),
                        value: 'Escuro',
                        groupValue: _viewModel.temaSelecionado,
                        onChanged: (valor) {
                          if (valor == null) return;
                          _viewModel.selecionarTema(valor);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Receber notificações'),
                        subtitle: const Text(
                          'Avisos sobre novos usuários cadastrados.',
                        ),
                        value: _viewModel.notificacoesAtivas,
                        onChanged: _viewModel.alterarNotificacoes,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed:
                            _viewModel.carregando ? null : _cadastrar,
                        child: _viewModel.carregando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Cadastrar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Voltar para o login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
