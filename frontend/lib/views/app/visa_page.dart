import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/models/create_visa_request.dart';
import 'package:overstay_frontend/models/visa_respons.dart';
import 'package:overstay_frontend/models/visa_type_response.dart';
import 'package:overstay_frontend/models/update_visa_request.dart';
import 'package:overstay_frontend/services/providers.dart';

class VisaPage extends ConsumerStatefulWidget {
  const VisaPage({super.key});

  @override
  ConsumerState<VisaPage> createState() => _VisaPageState();
}

class _VisaPageState extends ConsumerState<VisaPage> {
  List<VisaTypeResponse> visaTypes = [];
  VisaTypeResponse? selectedVisaType;

  // Tekstcontrollere til at håndtere tekstfelter
  final TextEditingController arrivalDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  String? currentVisaId;

  // NY ÆNDRING
  List<VisaResponse> previousVisas = []; // Liste til tidligere inaktive visa

  // Hent og vis data når siden loader
  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    await _loadVisaTypes(); //henter dropdown data for visa types
    await _loadCurrentVisa(); // udfylder felterne hvis der allerede eksisterer en data
    await _loadAllVisas(); // henter alle visaer
  }

  // Hent visa typer fra API (Dropdown)
  Future<void> _loadVisaTypes() async {
    final api = ref.read(visaApiServiceProvider);
    try {
      visaTypes = await api.getVisaTypes();
      debugPrint('Visa types loaded: ${visaTypes.length}');
      if (mounted) setState(() {});
    } catch (e, st) {
      // Håndter fejl her, f.eks. vis en fejlmeddelelse
      debugPrint('Failed loading visa types: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load visa types')),
      );
    }
  }

  // Hent brugerens aktuelle visa fra API
  Future<void> _loadCurrentVisa() async {
    final visa = await ref.read(currentVisaProvider.future);
    if (visa == null) {
      _resetVisaForm();
      return;
    }
    // find matchende visatype i listen
    final vt = visaTypes.firstWhereOrNull((v) => v.id == visa.visaType.id);
    setState(() {
      currentVisaId = visa.id;
      selectedVisaType = vt;
      arrivalDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(visa.arrivalDate);
      expiryDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(visa.expireDate);
    });
  }

  // NY ÆNDRING HENT ALLE visa inklusiv de inaktive Visa
  Future<void> _loadAllVisas() async {
    final api = ref.read(visaApiServiceProvider);
    try {
      final allVisas = await api.getAllVisas();
      // Filtrer inaktive visa ud
      previousVisas = allVisas.where((v) => v.id != currentVisaId).toList();
      debugPrint('All visas loaded: ${previousVisas.length}');
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Failed loading all visas: $e');
      previousVisas = [];
      if (mounted) setState(() {});
    }
  }

  // NY ÆNDRING - Opret nyt tomt visa (form reset)
  void _createNewVisa() {
    setState(() {
      selectedVisaType = null;
      arrivalDateController.clear();
      expiryDateController.clear();
      currentVisaId = null;
    });
  }

  // NY ÆNDRING ---- Klik på et tidligere inaktivt visa for at se detaljerne ---
  void _selectPreviousVisa(VisaResponse visa) {
    final vt = visaTypes.firstWhereOrNull((v) => v.id == visa.visaType.id);
    setState(() {
      currentVisaId = visa.id;
      selectedVisaType = vt;
      arrivalDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(visa.arrivalDate);
      expiryDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(visa.expireDate);
    });
  }

  void _resetVisaForm() {
    setState(() {
      selectedVisaType = null;
      arrivalDateController.clear();
      expiryDateController.clear();
      currentVisaId = null;
    });
  }

  //------------------ UI BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Venstre side (gradient + form)
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF99D98C),
                  Color(0xFF76C893),
                  Color(0xFF52B69A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: _buildVisaForm(context),
          ),
        ),

        // Højre side (billede) + tidligere inaktive visa
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/passport.png', width: 200),
                const SizedBox(height: 40),
                // NYT --------------- nice to have: tidligere inaktive visa
                if (previousVisas.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Previous Visas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: previousVisas.length,
                              itemBuilder: (context, index) {
                                final v = previousVisas[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(v.visaType.name ?? 'Visa'),
                                    subtitle: Text(
                                      'Arrival: ${DateFormat('yyyy-MM-dd').format(v.arrivalDate)}\n'
                                      'Expiry: ${DateFormat('yyyy-MM-dd').format(v.expireDate)}',
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () => _selectPreviousVisa(v),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisaForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Visa" overskrift
          const Text(
            'Visa',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // "Check visatype" + dropdown
          const Text(
            'Check visa-type',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<VisaTypeResponse>(
            decoration: _whiteInputDecoration,
            value:
                selectedVisaType == null
                    ? null
                    : visaTypes.firstWhereOrNull(
                      (v) => v.id == selectedVisaType!.id,
                    ),
            hint: const Text('Select a visa type'),
            items:
                visaTypes.map((visaType) {
                  return DropdownMenuItem(
                    value: visaType,
                    child: Text(visaType.name ?? '(no name)'),
                  );
                }).toList(),
            onChanged:
                (newValue) => setState(() => selectedVisaType = newValue),
          ),
          const SizedBox(height: 16),

          // "Arrival date" + text field - input
          const Text(
            'Arrival date',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: arrivalDateController,
            readOnly: true,
            decoration: _whiteInputDecoration.copyWith(hintText: 'yyyy-mm-dd'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                arrivalDateController.text =
                    picked.toIso8601String().split('T').first; // yyyy-mm-dd
              }
            },
          ),
          const SizedBox(height: 16),

          // "Expiry date" + text field - input
          const Text(
            'Expiry date',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: expiryDateController,
            readOnly: true,
            decoration: _whiteInputDecoration.copyWith(hintText: 'yyyy-mm-dd'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                expiryDateController.text =
                    picked.toIso8601String().split('T').first; // yyyy-mm-dd
              }
            },
          ),
          const SizedBox(height: 24),

          // Knapper (Save, Delete + ny create visa)
          Row(
            children: [
              ElevatedButton(
                onPressed: _saveVisa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A759F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _deleteVisa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A759F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Delete Visa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Ny ændring ---- KNAP til at opreyye nyt visa (reset form)
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _createNewVisa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F9E44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Create New Visa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- API kald - Gem visa (POST eller PUT) ----------------
  Future<void> _saveVisa() async {
    if (selectedVisaType == null ||
        arrivalDateController.text.isEmpty ||
        expiryDateController.text.isEmpty) {
      _show('Select visa type, arrival and expiry date');
      return;
    }

    final arrival = DateTime.tryParse(arrivalDateController.text);
    final expiry = DateTime.tryParse(expiryDateController.text);
    if (arrival == null || expiry == null) {
      _show('Invalid date format (yyyy-MM-dd)');
      return;
    }
    if (expiry.isBefore(arrival)) {
      _show('Expiry must be after arrival');
      return;
    }

    final api = ref.read(visaApiServiceProvider);

    try {
      if (currentVisaId == null) {
        // --- POST ---
        currentVisaId = await api.createVisa(
          CreateVisaRequest(
            arrivalDate: arrival,
            expireDate: expiry,
            visaTypeId: selectedVisaType!.id,
          ),
        );
        _show('Visa created');
      } else {
        // --- PUT ---
        await api.updateVisa(
          currentVisaId!,
          UpdateVisaRequest(
            arrivalDate: arrival,
            expireDate: expiry,
            visaTypeId: selectedVisaType!.id,
          ),
        );
        _show('Visa updated');
      }
      // hent opdateret data - reload
      await _initPage();
      ref.invalidate(currentVisaProvider);
    } catch (e) {
      _show('Failed to save visa');
      debugPrint('save error: $e');
    }
  }

  //------------------MEtode til at slette visa----------------
  Future<void> _deleteVisa() async {
    if (currentVisaId != null) {
      try {
        await ref.read(visaApiServiceProvider).deleteVisa(currentVisaId!);
        _show('Visa deleted');
      } catch (_) {
        _show('Failed to delete visa');
      }
    }
    _resetVisaForm();
    await _initPage();
    ref.invalidate(currentVisaProvider);
  }

  // "white box" stil
  final InputDecoration _whiteInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );

  //---------Snackbar-helper----------------
  void _show(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
