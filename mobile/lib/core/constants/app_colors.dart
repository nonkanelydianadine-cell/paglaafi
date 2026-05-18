import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color roseFonce = Color(0xFFC0185A);
  static const Color roseVif = Color(0xFFE8357A);
  static const Color rosePale = Color(0xFFFFF0F5);
  static const Color roseClair = Color(0xFFFFD6E7);
  static const Color fondPrincipal = Color(0xFFFFF5F8);
  static const Color fondBlanc = Color(0xFFFFFFFF);
  static const Color textePrincipal = Color(0xFF333333);
  static const Color texteSecondaire = Color(0xFF666666);
  static const Color texteGris = Color(0xFF999999);
  static const Color fondGris = Color(0xFFF5F5F5);

  static const Color risqueFaible = Color(0xFF2E7D32);
  static const Color risqueFaibleFond = Color(0xFFE8F5E9);
  static const Color risqueModere = Color(0xFFE65100);
  static const Color risqueModereFond = Color(0xFFFFF3E0);
  static const Color risqueEleve = Color(0xFFC62828);
  static const Color risqueEleveFond = Color(0xFFFFEBEE);

  static const LinearGradient gradientPrincipal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [roseFonce, roseVif],
  );

  static const LinearGradient gradientSplash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [roseVif, roseFonce],
  );
}
