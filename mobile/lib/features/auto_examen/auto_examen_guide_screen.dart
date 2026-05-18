import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';

class AutoExamenGuideScreen extends StatelessWidget {
  const AutoExamenGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langue = context.watch<HomeViewModel>().langueActive;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(titre: 'Auto-examen'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Introduction ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.roseClair),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.roseVif
                                .withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_outline,
                            color: AppColors.roseFonce,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Guide d\'auto-examen',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.roseFonce,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Choisissez votre mode d\'apprentissage',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColors.texteSecondaire,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Label ──
                  const Text(
                    'COMMENT VOULEZ-VOUS APPRENDRE ?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.texteGris,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Carte Vidéo ──
                  _CarteChoix(
                    icone: Icons.play_circle_outline_rounded,
                    titre: _titreVideo(langue),
                    description: _descVideo(langue),
                    tag: _tagVideo(langue),
                    couleurAccent: AppColors.roseFonce,
                    gradient: AppColors.gradientPrincipal,
                    texteBouton: _btnVideo(langue),
                    iconeBouton: Icons.play_arrow_rounded,
                    surClic: () => Navigator.pushNamed(
                      context,
                      AppRoutes.autoExamenVideo,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Carte Guide ──
                  _CarteChoix(
                    icone: Icons.list_alt_outlined,
                    titre: _titreGuide(langue),
                    description: _descGuide(langue),
                    tag: '8 étapes',
                    couleurAccent: AppColors.roseVif,
                    gradient: null,
                    texteBouton: _btnGuide(langue),
                    iconeBouton: Icons.arrow_forward_ios,
                    surClic: () => Navigator.pushNamed(
                      context,
                      AppRoutes.etapesAutoExamen,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Conseil ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.roseClair),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.roseVif,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _conseil(langue),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.texteSecondaire,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Textes multilingues ──
  String _titreVideo(String l) {
    switch (l) {
      case 'moore':   return 'Ges vɩɩd video sẽn wilgd';
      case 'dioula':  return 'Video ɲɛfɛ';
      case 'fulfude': return 'Yiy video ngoo';
      default:        return 'Regarder la vidéo explicative';
    }
  }

  String _descVideo(String l) {
    switch (l) {
      case 'moore':   return 'Ges video sẽn wilgd f sɛ gẽesg neere';
      case 'dioula':  return 'Yɛlɛma ye ka a se';
      case 'fulfude': return 'Yiy video ngoo hollitaari';
      default:
        return 'Regardez une démonstration complète de l\'auto-examen mammaire';
    }
  }

  String _tagVideo(String l) {
    switch (l) {
      case 'moore':   return 'Video';
      case 'dioula':  return 'Video';
      case 'fulfude': return 'Video';
      default:        return 'Vidéo';
    }
  }

  String _btnVideo(String l) {
    switch (l) {
      case 'moore':   return 'Ges video';
      case 'dioula':  return 'Video lajɛ';
      case 'fulfude': return 'Yiy video';
      default:        return 'Regarder la vidéo';
    }
  }

  String _titreGuide(String l) {
    switch (l) {
      case 'moore':   return 'Maand etapo nins ne etapo';
      case 'dioula':  return 'Kalansen tile kelen o kelen';
      case 'fulfude': return 'Jaŋtirde e tippudi';
      default:        return 'Suivre le guide étape par étape';
    }
  }

  String _descGuide(String l) {
    switch (l) {
      case 'moore':   return 'Paam etapo nins ne etapo tɩ fo tõe n maan';
      case 'dioula':  return 'Kɛ tile kelen o kelen n`a ɲɛ';
      case 'fulfude': return 'Jaŋtir tippudi kala tippudi';
      default:
        return 'Suivez les 8 étapes illustrées à votre rythme avec les instructions audio';
    }
  }

  String _btnGuide(String l) {
    switch (l) {
      case 'moore':   return 'Sɩng etapo';
      case 'dioula':  return 'Dɔ tile fɔlɔ';
      case 'fulfude': return 'Fuɗ tippudi';
      default:        return 'Commencer le guide';
    }
  }

  String _conseil(String l) {
    switch (l) {
      case 'moore':
        return 'Conseil: Maand f mens gẽesg yʋʋm-vʋʋs fãa, tɩ yɩɩd fõ rasem a yɩɩre poorẽ.';
      case 'dioula':
        return 'Ladɔnni: I yɛrɛ lajɛ kɔ kɔ kelen, tile saba kalo sariya tɛmɛ kɔfɛ.';
      case 'fulfude':
        return 'Ladde: Taƴtu hoore maa kala lewru, ɗuuɗe tati caggal hannde maa.';
      default:
        return 'Conseil : Pratiquez l\'auto-examen chaque mois, idéalement quelques jours après vos règles.';
    }
  }
}

// ── Widget carte de choix ──
class _CarteChoix extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String description;
  final String tag;
  final Color couleurAccent;
  final LinearGradient? gradient;
  final String texteBouton;
  final IconData iconeBouton;
  final VoidCallback surClic;

  const _CarteChoix({
    required this.icone,
    required this.titre,
    required this.description,
    required this.tag,
    required this.couleurAccent,
    this.gradient,
    required this.texteBouton,
    required this.iconeBouton,
    required this.surClic,
  });

  @override
  Widget build(BuildContext context) {
    final estAccent = gradient != null;

    return GestureDetector(
      onTap: surClic,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: estAccent ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: estAccent
              ? null
              : Border.all(
                  color: AppColors.roseClair, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: couleurAccent.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: estAccent
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.rosePale,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icone,
                      size: 28,
                      color: estAccent
                          ? Colors.white
                          : couleurAccent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Tag
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: estAccent
                                ? Colors.white
                                    .withOpacity(0.2)
                                : AppColors.rosePale,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: estAccent
                                  ? Colors.white
                                  : couleurAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          titre,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: estAccent
                                ? Colors.white
                                : AppColors.textePrincipal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: estAccent
                      ? Colors.white70
                      : AppColors.texteSecondaire,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Bouton
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: estAccent
                      ? Colors.white
                      : couleurAccent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      texteBouton,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: estAccent
                            ? couleurAccent
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      iconeBouton,
                      size: 14,
                      color: estAccent
                          ? couleurAccent
                          : Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}