import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart'; // Para compartilhar dados exportados

class ResumoVistoriasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> vistorias;

  const ResumoVistoriasScreen({super.key, required this.vistorias});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo das Vistorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _exportarDados(context);
            },
          ),
        ],
      ),
      body: vistorias.isEmpty
          ? const Center(child: Text('Nenhuma vistoria registrada.'))
          : ListView.builder(
              itemCount: vistorias.length,
              itemBuilder: (context, index) {
                final vistoria = vistorias[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      vistoria['nomeTrecho'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Localização: ${vistoria['geolocalizacao']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesVistoriaScreen(vistoria: vistoria),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _exportarDados(BuildContext context) async {
    if (vistorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhuma vistoria para exportar.')));
      return;
    }

    String dados = '';
    for (var vistoria in vistorias) {
      dados +=
          'Nome do Trecho: ${vistoria['nomeTrecho']}\n'
          'Geolocalização: ${vistoria['geolocalizacao']}\n\n';
    }

    // Salvar o arquivo
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/vistorias.txt');
    await file.writeAsString(dados);
    
    // Compartilhar o arquivo
    Share.shareFiles([file.path], text: 'Vistorias exportadas');
  }
}

class DetalhesVistoriaScreen extends StatelessWidget {
  final Map<String, dynamic> vistoria;

  const DetalhesVistoriaScreen({super.key, required this.vistoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vistoria['nomeTrecho']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Trecho: ${vistoria['nomeTrecho']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Perímetro: ${vistoria['perimetro']}'),
            Text('Ponta A: ${vistoria['pontaA']}'),
            Text('Ponta B: ${vistoria['pontaB']}'),
            Text('Volume: ${vistoria['volume']}'),
            Text('Alteamento: ${vistoria['alteamento']}'),
            Text('Pontos PEAD: ${vistoria['pontosPEAD']}'),
            Text('Cruzamento: ${vistoria['cruzamento']}'),
            Text('Caixa de Emenda: ${vistoria['caixaEmenda']}'),
            Text('Degradação: ${vistoria['degradacao']}'),
            Text('Caixa Subterrânea: ${vistoria['caixaSubterranea']}'),
            Text('Cabo FO: ${vistoria['caboFO']}'),
            Text('Observações: ${vistoria['observacoes']}'),
            const SizedBox(height: 20),
            const Text('Fotos:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (var foto in vistoria['fotos'])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.file(File(foto)),
              ),
            const SizedBox(height: 20),
            Text('Geolocalização: ${vistoria['geolocalizacao']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
