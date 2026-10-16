import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NovaReceitaPage extends StatefulWidget {
  const NovaReceitaPage({super.key});

  @override
  State<NovaReceitaPage> createState() => _NovaReceitaPageState();
}

class _NovaReceitaPageState extends State<NovaReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _modoFazerController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _custoController = TextEditingController();

  String _tipoSelecionado = 'SALGADA';
  final List<String> _tiposDisponiveis = ['SALGADA', 'DOCE', 'BEBIDA'];

  bool _enviando = false;

  Future<void> _salvarReceita() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    final novaReceita = {
      'nome': _nomeController.text.trim(),
      'tipo': _tipoSelecionado,
      'ingredientes': _ingredientesController.text.trim(),
      'modoFazer': _modoFazerController.text.trim(),
      'img': _imgController.text.trim(),
      'custoAproximado':
          double.tryParse(_custoController.text.replaceAll(',', '.')) ?? 0.0,
    };

    try {
      final response = await http.post(
        Uri.parse('https://receitasapi-b-2025.vercel.app/receitas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(novaReceita),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro de conexão: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Nova Receita',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nomeController,
                label: 'Nome da Receita',
                icon: Icons.restaurant_menu,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.category, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                ),
                items: _tiposDisponiveis.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _tipoSelecionado = novoValor;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _ingredientesController,
                label: 'Ingredientes',
                icon: Icons.list_alt,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _modoFazerController,
                label: 'Modo de Fazer',
                icon: Icons.kitchen,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imgController,
                label: 'URL da Imagem (img)',
                icon: Icons.image_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _custoController,
                label: 'Custo Aproximado R\$',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _enviando ? null : _salvarReceita,
                  child: _enviando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
