import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/visa_respons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overstay_frontend/services/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hent data fra auth‑state
    final auth = ref.watch(authStateProvider);
    final visaAsync = ref.watch(currentVisaProvider);
    final userName = auth.userName?.trim();
    final mail = auth.email?.trim();
    final greet = userName?.isNotEmpty == true ? userName! : (mail ?? 'User');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //venstre side "tekst" + bokse
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //*** Dynamisk velkomstbesked ***
                Text(
                  'Welcome, $greet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                /*//Visa Status
                const Text('Visa status:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                // grå boks til visa status
                Container(
                  width: 120,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text('Tourist', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),*/

                //-------------------Visa status-------------------
                visaAsync.when(
                  data:
                      (visa) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visa status:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          _infoBox(visa?.visaType.name ?? 'No visa'),
                        ],
                      ),
                  loading:
                      () => const CircularProgressIndicator(strokeWidth: 2),
                  error: (_, _) => const Text('Could not load visa status'),
                ),
                const SizedBox(height: 20),

                // Visa udløbsdato
                visaAsync.when(
                  data: (visa) {
                    final dateStr =
                        visa == null
                            ? '_'
                            : DateFormat('yyyy-MM-dd').format(visa.expireDate);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: const Text(
                            'Visa expiration date:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _infoBox(dateStr),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),

                // 4) Needed documentation (uden boks)
                const Text(
                  'Needed documentation',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          // Højre side (billede)
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                'assets/images/travelers.png',
                width: 280, // tilpas efter behov
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoBox(String txt) => Container(
  width: 120,
  height: 24,
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(4),
  ),
  child: Center(child: Text(txt, style: const TextStyle(fontSize: 16))),
);
