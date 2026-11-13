import 'package:flutter/foundation.dart';
import '../models/documento.dart';

// As operações de CRUD serão adicionadas quando a persistência dos documentos for implementada.
class DocumentosViewModel extends ChangeNotifier {
  final List<Documento> _documentos = [];

  List<Documento> get documentos => List.unmodifiable(_documentos);
}
