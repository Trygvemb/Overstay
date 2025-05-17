// tanken er at denne side skal håndtere brugerens ønskede notifikationsvalg
//daysBefore (med input, men med 7 som deault), allowEmail, allow90days, allowExpired
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/services/providers.dart';
import 'package:overstay_frontend/services/notifications_api_service.dart';
import 'package:overstay_frontend/services/api_exception.dart';
import 'package:overstay_frontend/models/notification_settings.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  // Tekstfelt til “x days before expiration" men skal som deafult være 7
  final _daysController = TextEditingController(text: '7');

  // booleans for checkboxes
  bool _email = false;
  bool _nintyDays = false;
  bool _expire = false;
  bool _initialisedFromServer = false;

  // --------------------- UI ---------------------
  @override
  Widget build(BuildContext context) {
    // Hent notification settings fra provider
    final asyncSettings = ref.watch(currentNotificationProvider);
    return asyncSettings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _errorWidget(e),
      data: (settings) => _buildLoadedUI(settings),
    );
  }

  // ------- VIS FEJL ----------
  Widget _errorWidget(Object e) => Center(
    child: Text(
      (e is ApiException)
          ? '(${e.statusCode}) ${e.message}'
          : 'Could not load notification settings',
      style: const TextStyle(color: Colors.red),
    ),
  );

  // ------- VIS INDHOLD ---------
  Widget _buildLoadedUI(NotificationSettings? settings) {
    // Opdater controller og booleans med de aktuelle værdier
    if (!_initialisedFromServer && settings != null) {
      //kun første gang
      _daysController.text = settings.daysBefore.toString();
      _email = settings.emailNotification;
      _nintyDays = settings.nintyDaysNotification;
      _expire = settings.expiredNotification;
      _initialisedFromServer = true;
    }

    return Row(
      children: [
        // Venstre side (gradient + form)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(32),
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
            child: SingleChildScrollView(child: _buildNotificationForm()),
          ),
        ),
        // Højre side (billede)
        Expanded(
          child: Center(
            child: Image.asset('assets/images/plane.png', width: 220),
          ),
        ),
      ],
    );
  }

  // --------------------- selve FORM-widget ---------------------

  Widget _buildNotificationForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Overskrift
      const Text(
        'Notification settings',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),

      _row(
        label: 'Email notification',
        child: Checkbox(
          value: _email,
          onChanged: (v) => setState(() => _email = v ?? false),
        ),
      ),

      //"Notify me x days before expiration" + Tekstfelt
      _row(
        label: 'Notify me x days before expiration',
        child: TextField(
          controller: _daysController,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Days'),
        ),
      ),

      _row(
        label: '90 days reporting reminder',
        child: Checkbox(
          value: _nintyDays,
          onChanged: (v) => setState(() => _nintyDays = v ?? false),
        ),
      ),

      _row(
        label: 'Visa expiry reminder',
        child: Checkbox(
          value: _expire,
          onChanged: (v) => setState(() => _expire = v ?? false),
        ),
      ),

      const SizedBox(height: 24),
      _buttonBar(),
    ],
  );

  // --------- Helper widgets ---------
  Widget _row({required String label, required Widget child}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        Flexible(flex: 2, child: child),
      ],
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  Widget _buttonBar() => Row(
    children: [
      ElevatedButton(onPressed: _save, child: const Text('save')),
      const SizedBox(width: 16),
      OutlinedButton(onPressed: _reset, child: const Text('reset')),
    ],
  );

  // --------- SAVE --------
  Future<void> _save() async {
    final api = ref.read(notificationApiProvider);
    final settings = NotificationSettings(
      id: '',
      emailNotification: _email,
      nintyDaysNotification: _nintyDays,
      expiredNotification: _expire,
      daysBefore: int.tryParse(_daysController.text) ?? 7,
    );

    try {
      final existing = ref.read(currentNotificationProvider).value;
      if (existing == null) {
        // POST
        await api.create(settings); // opretter ny første gang
      } else {
        await api.update(settings); // PUT
      }
      ref.invalidate(currentNotificationProvider);
      _show('Saved');
    } on ApiException catch (e) {
      _show('Error: ${e.statusCode}');
    }
  }

  // --------- RESET --------
  void _reset() => setState(() {
    _daysController.text = '7';
    _email = false;
    _nintyDays = false;
    _expire = false;
  });

  // --------- SHOW MESSAGE --------
  void _show(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}
