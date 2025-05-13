// lib/views/app/profile_page.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/models/update_user_request.dart';
import 'package:overstay_frontend/models/user_response.dart';
import 'package:overstay_frontend/services/providers.dart';
import 'package:overstay_frontend/services/api_exception.dart';
import 'package:overstay_frontend/services/user_api_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // ────── controllers ──────
  final _userNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  String? _selectedCountryId;

  // mock landeliste (brug samme GUIDs som i signup)
  final _countries = const [
    {'id': 'd6cf4…4106', 'name': 'Denmark'},
    {'id': 'b242b…6be0', 'name': 'Sweden'},
    {'id': 'a1b2c…o5p6', 'name': 'Norway'},
    {'id': '7f8e9…1j2k', 'name': 'Finland'},
  ];

  @override
  void dispose() {
    _userNameC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: Row(
        children: [
          // venstre side (gradient + form)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF99D98C), Color(0xFF52B69A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: userAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (_, __) =>
                        const Center(child: Text('Could not load profile')),
                data: (user) => _buildForm(context, user),
              ),
            ),
          ),
          // højre side (illustration)
          Expanded(
            child: Center(child: Image.asset('assets/images/passport.png')),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  Widget _buildForm(BuildContext ctx, UserResponse user) {
    // 1) pre-utfyld kun første gang
    if (_userNameC.text.isEmpty) {
      _userNameC.text = user.userName;
      _emailC.text = user.email;
      _selectedCountryId = user.country; // kan være null
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _label('Username'),
            _field(_userNameC, 'Username'),
            const SizedBox(height: 16),

            _label('Email'),
            _field(_emailC, 'Email'),
            const SizedBox(height: 16),

            _label('Country'),
            _countryDropdown(),
            const SizedBox(height: 16),

            _label('New password'),
            _field(_passwordC, 'Password', obscure: true),
            const SizedBox(height: 24),

            Row(
              children: [
                _actionBtn('Save', _saveProfile),
                const SizedBox(width: 20),
                _actionBtn('Reset', _resetForm),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────── helpers ─────────
  Widget _label(String txt) =>
      Text(txt, style: const TextStyle(fontSize: 16, color: Colors.black));

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) =>
      TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget _countryDropdown() => DropdownButtonFormField<String>(
    isExpanded: true,
    value: _selectedCountryId,
    items:
        _countries
            .map(
              (c) => DropdownMenuItem(value: c['id'], child: Text(c['name']!)),
            )
            .toList(),
    onChanged: (val) => setState(() => _selectedCountryId = val),
    decoration: const InputDecoration(border: OutlineInputBorder()),
  );

  Widget _actionBtn(String txt, VoidCallback fn) => ElevatedButton(
    onPressed: fn,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A759F),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    ),
    child: Text(txt, style: const TextStyle(color: Colors.white)),
  );

  // ───────── save handler ─────────
  Future<void> _saveProfile() async {
    final body = UpdateUserRequest(
      userName: _userNameC.text.trim().isEmpty ? null : _userNameC.text.trim(),
      email: _emailC.text.trim().isEmpty ? null : _emailC.text.trim(),
      country: _selectedCountryId,
      password: _passwordC.text.trim().isEmpty ? null : _passwordC.text.trim(),
    );

    try {
      final api = ref.read(userApiServiceProvider);
      final userId = ref.read(authStateProvider).userId!;
      await api.updateUser(userId, body.toJson());

      ref.invalidate(currentUserProvider); // hent friske data
      _show('Profile updated');

      setState(() => _passwordC.clear()); // clear pwd-felt
    } on ApiException catch (e) {
      _show('Error ${e.statusCode}: ${e.message}');
    } catch (_) {
      _show('Update failed');
    }
  }

  void _resetForm() {
    setState(() {
      _userNameC.clear();
      _emailC.clear();
      _passwordC.clear();
      _selectedCountryId = null;
    });
  }

  // ───────── snackbar ─────────
  void _show(String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
}
