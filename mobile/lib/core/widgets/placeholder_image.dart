import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Widget qui affiche un placeholder coloré
/// quand l'image réelle n'est pas encore disponible
class PlaceholderImage extends StatelessWidget {
  final String? imagePath;
  final double height;
  final String emoji;
  final String label;

  const PlaceholderImage({
    super.key,
    this.imagePath,
    this.height = 140,
    required this.emoji,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    // Si un vrai fichier image existe → l'afficher
    if (imagePath != null && imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath!,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          // Si le fichier n'existe pas → afficher le placeholder
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.rosePale, AppColors.roseClair],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.roseClair),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.roseFonce,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }
}