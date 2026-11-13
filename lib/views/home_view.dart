import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inicializado) return;
    _inicializado = true;

    final argumentos = ModalRoute.of(context)?.settings.arguments;
    final nome = argumentos is String ? argumentos : 'Usuário';

    _viewModel = HomeViewModel(nomeUsuario: nome);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mensagem = await _viewModel.verificarNovosUsuarios();
      if (!mounted || mensagem == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Future<void> _mostrarPreferencias() async {
    await _viewModel.carregarPreferencias();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return AlertDialog(
              title: const Text('Minhas preferências'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Escolha o tema:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text('Claro'),
                    value: 'Claro',
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (valor) {
                      if (valor != null) _viewModel.alterarTema(valor);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Escuro'),
                    value: 'Escuro',
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (valor) {
                      if (valor != null) _viewModel.alterarTema(valor);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Notificações'),
                    subtitle: const Text('Avisar sobre novos usuários.'),
                    value: _viewModel.notificacoesAtivas,
                    onChanged: _viewModel.alterarNotificacoes,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarUsuarios() async {
    await _viewModel.carregarUsuarios();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            final List<Usuario> usuarios = _viewModel.usuarios;

            return AlertDialog(
              title: const Text('Todos os usuários'),
              content: SizedBox(
                width: 400,
                child: _viewModel.carregandoUsuarios
                    ? const Center(child: CircularProgressIndicator())
                    : usuarios.isEmpty
                        ? const Text('Nenhum usuário cadastrado ainda.')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = usuarios[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    usuario.nome[0].toUpperCase(),
                                  ),
                                ),
                                title: Text(usuario.nome),
                                subtitle: Text(usuario.email),
                              );
                            },
                          ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCard({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoClicar,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: aoClicar,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icone,
                size: 42,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descricao,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_inicializado) _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // didChangeDependencies é executado antes do primeiro build.
    if (!_inicializado) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocuFlow'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Olá, ${_viewModel.nomeUsuario}!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bem-vindo ao DocuFlow. '
                      'Gerencie suas preferências e usuários.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Acesso rápido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCard(
                              icone: Icons.settings_outlined,
                              titulo: 'Minhas preferências',
                              descricao:
                                  'Altere o tema e configure suas notificações.',
                              aoClicar: _mostrarPreferencias,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCard(
                              icone: Icons.people_outline,
                              titulo: 'Todos os usuários',
                              descricao:
                                  'Visualize os usuários cadastrados no DocuFlow.',
                              aoClicar: _mostrarUsuarios,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildCard(
                            icone: Icons.settings_outlined,
                            titulo: 'Minhas preferências',
                            descricao:
                                'Altere o tema e configure suas notificações.',
                            aoClicar: _mostrarPreferencias,
                          ),
                          const SizedBox(height: 16),
                          _buildCard(
                            icone: Icons.people_outline,
                            titulo: 'Todos os usuários',
                            descricao:
                                'Visualize os usuários cadastrados no DocuFlow.',
                            aoClicar: _mostrarUsuarios,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Desenvolvido por Katarine Oliveira',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
