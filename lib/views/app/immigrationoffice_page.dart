import 'package:flutter/material.dart';

class ImmigrationofficePage extends StatelessWidget {
  const ImmigrationofficePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Her simulerer vi en liste over immigration offices
    final List<Office> offices = [
      Office(
        name: 'Bangkok Immigration Office',
        address: 'Bangkok, Chaeng Wattana Road...',
        phone: '+66 2 141 9889',
        openingHours: 'Mon-Fri 8:30-16:30',
      ),
      Office(
        name: 'Chiang Mai Immigration Office',
        address: 'Chiang Mai, Promenada Mall, 3rd floor...',
        phone: '+66 53 142 986',
        openingHours: 'Mon-Fri 8:30-16:30',
      ),
      Office(
        name: 'Phuket Immigration Office',
        address: 'Phuket Town, Phuket Road...',
        phone: '+66 76 222 080',
        openingHours: 'Mon-Fri 8:30-16:30',
      ),
      // ... Tilføj flere
    ];

    return Row(
      children: [
        // Venstre side – fx en baggrund / overskrift
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
            child: _buildOfficeList(offices),
          ),
        ),
        // Højre side – Evt. billede, eller placeholders
        Expanded(
          flex: 1,
          child: Center(
            child: Image.asset(
              'assets/images/immigration.png', // Indsæt relevant billede
              width: 250,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeList(List<Office> offices) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Immigration Offices',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Listen i en Expanded for scroll
          Expanded(
            child: ListView.separated(
              itemCount: offices.length,
              separatorBuilder:
                  (context, index) =>
                      const Divider(color: Colors.blueGrey, thickness: 1),
              itemBuilder: (context, index) {
                final office = offices[index];
                return _buildOfficeTile(office);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeTile(Office office) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          office.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('Address: ${office.address}'),
        Text('Phone: ${office.phone}'),
        if (office.openingHours != null)
          Text('Opening hours: ${office.openingHours}'),
      ],
    );
  }
}

// Model-klasse for immigration office
class Office {
  final String name;
  final String address;
  final String phone;
  final String? openingHours;

  Office({
    required this.name,
    required this.address,
    required this.phone,
    this.openingHours,
  });
}
