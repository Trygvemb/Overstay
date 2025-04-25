import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Tekstfelt til “x days before expiration”
  final TextEditingController daysController = TextEditingController();

  // To booleans for checkboxes
  bool agreeEmail = false;
  bool agreePush = false;

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
            child: _buildNotificationForm(context),
          ),
        ),

        // Højre side (billede)
        Expanded(
          flex: 1,
          child: Center(
            child: Image.asset(
              'assets/images/plane.png', // Tilpas stien/billede
              width: 250,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overskrift
          const Text(
            'Notification settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // 1) "Notify me x days before expiration" + Tekstfelt
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Notify my x days before expiration',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300], // Grå baggrund
                    hintText: 'Days',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2) "Agree to email notification" + Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Agree to email notification',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Checkbox(
                  value: agreeEmail,
                  onChanged: (bool? newVal) {
                    setState(() => agreeEmail = newVal ?? false);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3) "Agree to push notifications" + Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Agree to push notifications',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Checkbox(
                  value: agreePush,
                  onChanged: (bool? newVal) {
                    setState(() => agreePush = newVal ?? false);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Divider (gradient)
          _gradientDivider(),
          const SizedBox(height: 16),

          // Knapper
          Row(
            children: [
              ElevatedButton(
                onPressed: _saveNotifications,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A759F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _deleteNotifications,
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

  Widget _gradientDivider() {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A759F), Color(0xFF1E6091)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  void _saveNotifications() {
    final days = daysController.text.trim();
    final emailAgree = agreeEmail;
    final pushAgree = agreePush;

    // TODO: Kald backend for at gemme - vise snack/feedback
    debugPrint('Saving: days=$days, email=$emailAgree, push=$pushAgree');
  }

  void _deleteNotifications() {
    // TODO: Kald backend for at slette - vise snack/feedback
    debugPrint('Deleting notification settings');
  }
}
