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
          //venstre side grafisk velkomst + visa status samt udløbsdato
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                // for grafisk udseend med afrundede kanter
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB2DFDB),
                      Color(0xFF80CBC4),
                      Color(0xFF1A759F),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        //*** Dynamisk velkomstbesked ***
                        Text(
                          'Welcome, $greet',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A759F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    //-------------------Visa status-------------------
                    visaAsync.when(
                      data:
                          (visa) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Visa status:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _chipBox(
                                visa?.visaType.name ?? 'No visa',
                                icon: Icons.verified,
                              ),
                            ],
                          ),
                      loading:
                          () => const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, _) => const Text('Could not load visa status'),
                    ),
                    const SizedBox(height: 24),

                    // Visa udløbsdato
                    visaAsync.when(
                      data: (visa) {
                        final dateStr =
                            visa == null
                                ? '_'
                                : DateFormat(
                                  'yyyy-MM-dd',
                                ).format(visa.expireDate);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Visa expiration date:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _chipBox(dateStr, icon: Icons.calendar_month),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),

                    // 4) Needed documentation (uden boks)
                    const Text(
                      'Needed documentation',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    // --- Liste med dokumenter -- Kan ÆNDRES ---
                    const Text(
                      '-Passport copy\n- Visa application\n- Recent photo\n- Travel itinerary',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
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

// CHIPBOX ---nyt trial lets see
// NYT: Grafisk "chip" med ikon og tekst – bruges til status og dato
Widget _chipBox(String txt, {IconData? icon}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Color(0xFF1A759F), width: 1),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (icon != null) ...[
        Icon(icon, size: 18, color: Color(0xFF1A759F)),
        const SizedBox(width: 6),
      ],
      Text(txt, style: const TextStyle(fontSize: 16, color: Color(0xFF1A759F))),
    ],
  ),
);
