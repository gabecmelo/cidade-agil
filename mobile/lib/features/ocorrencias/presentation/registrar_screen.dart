import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_errors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/category_chip.dart';
import '../data/ocorrencia_models.dart';
import '../data/ocorrencia_repository.dart';
import '../providers/ocorrencias_provider.dart';

class RegistrarScreen extends ConsumerStatefulWidget {
  const RegistrarScreen({super.key});

  @override
  ConsumerState<RegistrarScreen> createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends ConsumerState<RegistrarScreen> {
  CategoriaDart? _categoria;
  XFile? _foto;
  Position? _posicao;
  final _descricaoCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _detectarLocalizacao();
  }

  @override
  void dispose() {
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _detectarLocalizacao() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) setState(() => _posicao = pos);
    } catch (_) {}
  }

  Future<void> _tirarFoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1280,
    );
    if (file != null && mounted) setState(() => _foto = file);
  }

  Future<void> _enviar() async {
    if (_categoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria.')),
      );
      return;
    }
    if (_foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire uma foto do problema.')),
      );
      return;
    }
    if (_posicao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização não disponível. Tente novamente.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final bytes = await _foto!.readAsBytes();
      final b64 = base64Encode(bytes);

      final resultado = await OcorrenciaRepository.instance.registrar(
        RegistrarOcorrenciaRequest(
          categoria: _categoria!,
          descricao: _descricaoCtrl.text.trim().isEmpty
              ? 'Sem descrição adicional.'
              : _descricaoCtrl.text.trim(),
          fotoBase64: b64,
          latitude: _posicao!.latitude,
          longitude: _posicao!.longitude,
        ),
      );

      ref.invalidate(ocorrenciasListProvider);
      if (!mounted) return;
      context.go('/registrar/sucesso/${resultado.id}');
    } on AppError catch (e) {
      if (!mounted) return;
      final msg = e.code == 'foto_muito_grande'
          ? 'Foto muito grande, refaça a foto.'
          : e.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Nova ocorrência'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Categoria'),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1,
                children: CategoriaDart.values
                    .map((cat) => CategoryChip(
                          categoria: cat,
                          selected: _categoria == cat,
                          onTap: () => setState(() => _categoria = cat),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _label('Foto'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _tirarFoto,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFCBD2DC),
                      width: 2,
                      style: _foto == null ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                  child: _foto == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Symbols.photo_camera, size: 36, color: Color(0xFF6B7383)),
                            SizedBox(height: 6),
                            Text(
                              'Toque para capturar foto',
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7383)),
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(File(_foto!.path), fit: BoxFit.cover),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _tirarFoto,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Refazer foto',
                                    style: TextStyle(color: Colors.white, fontSize: 11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              // Linha GPS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.my_location,
                      size: 18,
                      color: _posicao != null ? const Color(0xFF16A34A) : const Color(0xFF6B7383),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _posicao != null
                          ? 'Localização capturada: ${_posicao!.latitude.toStringAsFixed(4)}, ${_posicao!.longitude.toStringAsFixed(4)}'
                          : 'Detectando localização…',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF384151)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _label('Descrição'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoCtrl,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Descreva o problema (opcional)',
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Enviar',
                icon: Symbols.send,
                onPressed: _enviar,
                loading: _loading,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600,
          letterSpacing: 0.08, color: Color(0xFF6B7383),
        ),
      );
}
