import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'resumo_vistorias_screen.dart';

class VistoriaScreen extends StatefulWidget {
  const VistoriaScreen({super.key});

  @override
  _VistoriaScreenState createState() => _VistoriaScreenState();
}

class _VistoriaScreenState extends State<VistoriaScreen> {
  List<File?> _imageFiles = List.filled(4, null);
  Position? _position;
  final picker = ImagePicker();
  final TextEditingController nomeTrechoController = TextEditingController();
  final TextEditingController perimetroController = TextEditingController();
  final TextEditingController pontaAController = TextEditingController();
  final TextEditingController pontaBController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController alteamentoController = TextEditingController();
  final TextEditingController pontosPEADController = TextEditingController();
  final TextEditingController cruzamentoController = TextEditingController();
  final TextEditingController caixaEmendaController = TextEditingController();
  final TextEditingController degradacaoController = TextEditingController();
  final TextEditingController caixaSubterraneaController = TextEditingController();
  final TextEditingController caboFOController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  List<Map<String, dynamic>> vistoriasList = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFiles[index] = File(pickedFile.path);
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização está desabilitado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização permanentemente negada.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
    });
    return position;
  }

  void _submitVistoria() {
    if (_formIsValid()) {
      Map<String, dynamic> vistoria = {
        "nomeTrecho": nomeTrechoController.text,
        "perimetro": perimetroController.text,
        "pontaA": pontaAController.text,
        "pontaB": pontaBController.text,
        "volume": volumeController.text,
        "alteamento": alteamentoController.text,
        "pontosPEAD": pontosPEADController.text,
        "cruzamento": cruzamentoController.text,
        "caixaEmenda": caixaEmendaController.text,
        "degradacao": degradacaoController.text,
        "caixaSubterranea": caixaSubterraneaController.text,
        "caboFO": caboFOController.text,
        "observacoes": observacoesController.text,
        "geolocalizacao": _position != null
            ? "${_position!.latitude}, ${_position!.longitude}"
            : "Sem localização",
        "fotos": _imageFiles.map((file) => file?.path).toList(),
      };

      setState(() {
        vistoriasList.add(vistoria);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResumoVistoriasScreen(vistorias: vistoriasList)),
      );

      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vistoria salva com sucesso!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage ?? 'Preencha todos os campos obrigatórios!')));
    }
  }

  bool _formIsValid() {
    _errorMessage = null;

    if (nomeTrechoController.text.isEmpty || perimetroController.text.isEmpty) {
      _errorMessage = 'Nome do Trecho e Perímetro são obrigatórios!';
      return false;
    }
    if (_imageFiles.every((file) => file == null)) {
      _errorMessage = 'É necessário carregar pelo menos uma imagem!';
      return false;
    }

    return true;
  }

  void _clearForm() {
    nomeTrechoController.clear();
    perimetroController.clear();
    pontaAController.clear();
    pontaBController.clear();
    volumeController.clear();
    alteamentoController.clear();
    pontosPEADController.clear();
    cruzamentoController.clear();
    caixaEmendaController.clear();
    degradacaoController.clear();
    caixaSubterraneaController.clear();
    caboFOController.clear();
    observacoesController.clear();
    _imageFiles = List.filled(4, null);
    setState(() {
      _errorMessage = null; // Limpa a mensagem de erro
    });
  }

  Widget _buildImagePicker(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imageFiles[index] != null
            ? (kIsWeb 
                ? Image.memory(_imageFiles[index]!.readAsBytesSync()) 
                : Image.file(_imageFiles[index]!)) // Ajustando para diferentes plataformas
            : const Text('Nenhuma imagem carregada'),
        ElevatedButton.icon(
          onPressed: () => _pickImage(index),
          icon: const Icon(Icons.photo_camera),
          label: const Text('Carregar Foto'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('Vistoria de Rede de Telefonia'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navegação',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Resumo das Vistorias'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResumoVistoriasScreen(vistorias: vistoriasList)),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Carregar Fotos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (int i = 0; i < _imageFiles.length; i++) _buildImagePicker(i),
            const SizedBox(height: 20),
            const Text('Geolocalização:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              _position != null
                  ? "${_position!.latitude}, ${_position!.longitude}"
                  : "Aguardando localização...",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildTextField(nomeTrechoController, 'Nome do Trecho', Icons.map),
            const SizedBox(height: 10),
            _buildTextField(perimetroController, 'Perímetro', Icons.assessment),
            const SizedBox(height: 10),
            _buildTextField(pontaAController, 'Ponta A', Icons.arrow_forward),
            const SizedBox(height: 10),
            _buildTextField(pontaBController, 'Ponta B', Icons.arrow_back),
            const SizedBox(height: 10),
            _buildTextField(volumeController, 'Volume (qtde)', Icons.format_list_numbered),
            const SizedBox(height: 10),
            _buildTextField(alteamentoController, 'Alteamento', Icons.height),
            const SizedBox(height: 10),
            _buildTextField(pontosPEADController, 'Pontos PEAD', Icons.location_city),
            const SizedBox(height: 10),
            _buildTextField(cruzamentoController, 'Cruzamento', Icons.merge_type),
            const SizedBox(height: 10),
            _buildTextField(caixaEmendaController, 'Caixa de Emenda', Icons.business),
            const SizedBox(height: 10),
            _buildTextField(degradacaoController, 'Degradação', Icons.warning),
            const SizedBox(height: 10),
            _buildTextField(caixaSubterraneaController, 'Caixa Subterrânea', Icons.business_center),
            const SizedBox(height: 10),
            _buildTextField(caboFOController, 'Cabo FO', Icons.power),
            const SizedBox(height: 10),
            _buildTextField(observacoesController, 'Observações', Icons.note),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitVistoria,
              child: const Text('Salvar Vistoria'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
