import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final VoidCallback onAgePressed;
  final VoidCallback onWorkPressed;
  final VoidCallback onAssetsPressed;
  final VoidCallback onRelationsPressed;
  final VoidCallback onActivitiesPressed;

  const BottomNavigation({
    super.key,
    required this.onAgePressed,
    required this.onWorkPressed,
    required this.onAssetsPressed,
    required this.onRelationsPressed,
    required this.onActivitiesPressed,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}


class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF0D47A1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('Travail', Icons.work, widget.onWorkPressed),
          _buildNavItem('Capital', Icons.account_balance, widget.onAssetsPressed),
          _buildAgeButton(),
          _buildNavItem('Relations', Icons.people, widget.onRelationsPressed),
          _buildNavItem('Activités', Icons.sports_esports, widget.onActivitiesPressed),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeButton() {
    return GestureDetector(
      onTap: widget.onAgePressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.white, size: 30),
          ),
          Positioned(
            bottom: 8,
            child: Text(
              'Âge +1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
