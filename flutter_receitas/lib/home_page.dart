import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'splash_page.dart';
import 'nova_receita_page.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  List<dynamic> receitas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarReceitas();
  }

  Future<void> _buscarReceitas() async {
    setState(() => carregando = true);

    try {
      final response = await http.get(
        Uri.parse('https://receitasapi-b-2025.vercel.app/receitas'),
      );

      if (response.statusCode == 200) {
        setState(() {
          receitas = jsonDecode(response.body);
          carregando = false;
        });
      } else {
        setState(() => carregando = false);
      }
    } catch (e) {
      setState(() => carregando = false);
    }
  }

  Future<void> _deletarReceita(String id, int index) async {
    try {
      final response = await http.delete(
        Uri.parse('https://receitasapi-b-2025.vercel.app/receitas/$id'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          receitas.removeAt(index);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita removida com sucesso!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir receita.')),
        );
      }
    }
  }

  Future<void> _abrirNovaReceita() async {
    final salvou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const NovaReceitaPage()),
    );

    if (salvou == true) {
      _buscarReceitas();
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashPage()),
      );
    } else if (index == 2) {
      _abrirNovaReceita();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Receitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : receitas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma receita encontrada.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              color: Colors.orange,
              onRefresh: _buscarReceitas,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: receitas.length,
                itemBuilder: (context, index) {
                  final receita = receitas[index];

                  final String imageUrl =
                      receita['img'] ??
                      receita['url'] ??
                      receita['imagem'] ??
                      '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalhesPage(
                                receita: {
                                  'nome': receita['nome']?.toString() ?? '',
                                  'descricao':
                                      receita['ingredientes']?.toString() ?? '',
                                  'preparo':
                                      receita['modoFazer']?.toString() ?? '',
                                  'custo':
                                      receita['custoAproximado']?.toString() ??
                                      receita['custo']?.toString() ??
                                      '0.00',
                                  'url': imageUrl,
                                },
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.orange.shade50,
                                        child: const Icon(
                                          Icons.restaurant,
                                          color: Colors.orange,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      receita['nome']?.toString() ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      receita['ingredientes']?.toString() ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.orangeAccent,
                                ),
                                onPressed: () {
                                  final id = receita['_id'] ?? receita['id'];

                                  if (id != null) {
                                    _deletarReceita(id.toString(), index);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: 'Splash'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova',
          ),
        ],
      ),
    );
  }
}
