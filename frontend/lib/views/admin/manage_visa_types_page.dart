// opret/ret/slet visa typer
// -GET/visa-types, POST og -DELETE/visa-types{id}

import 'package:flutter/material.dart';

class ManageVisaTypesPage extends StatefulWidget {
  const ManageVisaTypesPage({super.key});

  @override
  State<ManageVisaTypesPage> createState() => _ManageVisaTypesPageState();
}

class _ManageVisaTypesPageState extends State<ManageVisaTypesPage> {
  late Future<List<VisaType>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getVisaTypes();      // -> GET /visa-types
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (ctx, snap) { … }
    );
  }
}