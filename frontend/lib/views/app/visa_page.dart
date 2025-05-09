import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/models/create_visa_request.dart';
import 'package:overstay_frontend/models/visa_type_response.dart';
import 'package:overstay_frontend/views/app/widget_tree.dart';
import 'package:overstay_frontend/services/providers.dart';
import 'package:overstay_frontend/services/visa_api_service.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialiserer expiryDate feltet med en placeholder
    expiryDateController.text = "dd/mm/yyyy";
    _loadVisaTypes();
  }

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Venstre side (gradient + form)
        Expanded(
          flex: 1,
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
        // Højre side (billede)
        Expanded(
          flex: 1,
          child: Center(
            child: Image.asset('assets/images/passport.png', width: 250),
          ),
        ),
      ],
    );
  }

  Widget _buildVisaForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
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

          // "Choose Country" + dropdown
          /*const Text(
            'Choose Country',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _whiteInputDecoration,
            value: selectedCountry,
            hint: const Text('Select a country'),
            items:
                countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() => selectedCountry = newValue);
            },
          ),
          const SizedBox(height: 16),*/

          // "Check visatype" + dropdown
          const Text(
            'Check visa-type',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<VisaTypeResponse>(
            decoration: _whiteInputDecoration,
            value: selectedVisaType,
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

          // Knapper (Save, Delete)
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
              const SizedBox(width: 20),
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
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Metode til at gemme visa data
  Future<void> _saveVisa() async {
    if (selectedVisaType == null ||
        arrivalDateController.text.isEmpty ||
        expiryDateController.text.isEmpty) {
      _show('Select visa type and arrival date and epiry date');
      return;
    }
    final arrival = DateTime.tryParse(arrivalDateController.text);
    final expiry = DateTime.tryParse(expiryDateController.text);

    if (arrival == null || expiry == null) {
      _show('Invalid date format (yyyy-mm-dd)');
      return;
    }

    if (expiry.isBefore(arrival)) {
      _show('Expiry date must be after arrival date');
      return;
    }

    final api = ref.read(visaApiServiceProvider);
    try {
      final response = await api.createVisa(
        CreateVisaRequest(
          arrivalDate: arrival,
          expireDate: expiry,
          visaTypeId: selectedVisaType!.id,
        ),
      );

      currentVisaId = response.id;
      expiryDateController.text =
          response.expireDate.toIso8601String().split('T').first; // yyyy-mm-dd
      _show('Visa saved!');
      debugPrint('Visa saved with ID: ${response.id}');
    } on Exception catch (e) {
      debugPrint('Failed to save visa: $e');
      _show('Failed to save visa: $e');
    }
  }

  // Metode til at slette data
  void _deleteVisa() {
    setState(() {
      selectedVisaType = null;
      arrivalDateController.clear();
      expiryDateController.clear();
      currentVisaId = null;
    });
    _show('Visa fields deleted!');
    debugPrint('Deleting visa data');
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
