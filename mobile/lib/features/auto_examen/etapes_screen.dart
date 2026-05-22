import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';

class EtapesScreen extends StatefulWidget {
  const EtapesScreen({super.key});

  @override
  State<EtapesScreen> createState() => _EtapesScreenState();
}

class _EtapesScreenState extends State<EtapesScreen> {
  int _etapeActuelle = 0;

  // Textes multilingues pour chaque étape
  List<Map<String, dynamic>> _getEtapes(String langue) {
    final etapesFr = [
      {
        'titre': 'Préparation',
        'desc':
            'Choisissez un moment calme. Vous pouvez être sous la douche, allongée ou debout devant un miroir.',
        'icone': Icons.self_improvement,
      },
      {
        'titre': 'Observation devant le miroir',
        'desc':
            'Regardez vos seins dans le miroir, bras le long du corps puis levés. Vérifiez la forme, la peau, les mamelons.',
        'icone': Icons.visibility,
      },
      {
        'titre': 'Palpation debout',
        'desc':
            'Levez le bras gauche, palpez le sein gauche avec les doigts de la main droite en mouvements circulaires.',
        'icone': Icons.pan_tool,
      },
      {
        'titre': 'Palpation couchée',
        'desc':
            'Allongez-vous, placez un coussin sous l\'épaule gauche et palpez le sein gauche avec la main droite.',
        'icone': Icons.bed,
      },
      {
        'titre': 'Vérification du mamelon',
        'desc':
            'Pressez doucement le mamelon pour vérifier s\'il y a un écoulement anormal.',
        'icone': Icons.circle_outlined,
      },
      {
        'titre': 'Répétez à droite',
        'desc': 'Refaites les mêmes étapes pour le sein droit.',
        'icone': Icons.repeat,
      },
      {
        'titre': 'Aisselles',
        'desc': 'Palpez les aisselles pour détecter d\'éventuels ganglions.',
        'icone': Icons.accessibility_new,
      },
      {
        'titre': 'Notez vos observations',
        'desc':
            'Notez ce que vous avez ressenti. En cas de doute, consultez un professionnel.',
        'icone': Icons.edit_note,
      },
    ];

    final etapesMoore = [
      {
        'titre': 'Sɩng tɩ b sẽn yɩɩd',
        'desc': 'Sɩng tɩ b sẽn yɩɩd. Y tõe n yɩɩd sɩng tɩ b sẽn yɩɩd.',
        'icone': Icons.self_improvement,
      },
      // ... (ajoute les traductions moore pour chaque étape)
      {
        'titre': 'Gẽesg neere',
        'desc': 'Gẽesg neere tɩ yɩɩd f sɛ.',
        'icone': Icons.visibility,
      },
      {
        'titre': 'Maand tɩ b sẽn yɩɩd',
        'desc': 'Maand tɩ b sẽn yɩɩd f sɛ.',
        'icone': Icons.pan_tool,
      },
      {
        'titre': 'Maand tɩ b sẽn yɩɩd',
        'desc': 'Maand tɩ b sẽn yɩɩd f sɛ.',
        'icone': Icons.bed,
      },
      {
        'titre': 'Kẽng neere',
        'desc': 'Kẽng neere tɩ yɩɩd f sɛ.',
        'icone': Icons.circle_outlined,
      },
      {
        'titre': 'Maand neere',
        'desc': 'Maand neere tɩ yɩɩd f sɛ.',
        'icone': Icons.repeat,
      },
      {
        'titre': 'Kẽng aisselles',
        'desc': 'Kẽng aisselles tɩ yɩɩd f sɛ.',
        'icone': Icons.accessibility_new,
      },
      {
        'titre': 'Yɩɩd f sɛ',
        'desc': 'Yɩɩd f sɛ tɩ yɩɩd f sɛ.',
        'icone': Icons.edit_note,
      },
    ];

    switch (langue) {
      case 'moore':
        return etapesMoore;
      default:
        return etapesFr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langue = context.watch<HomeViewModel>().langueActive;
    final etapes = _getEtapes(langue);
    final etape = etapes[_etapeActuelle];

    return Scaffold(
      body: Column(
        children: [
          AppHeader(titre: 'Étape ${_etapeActuelle + 1}/${etapes.length}'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (_etapeActuelle + 1) / etapes.length,
                    backgroundColor: AppColors.rosePale,
                    color: AppColors.roseFonce,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      etape['icone'],
                      size: 56,
                      color: AppColors.roseFonce,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    etape['titre'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.roseFonce,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    etape['desc'],
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.texteSecondaire,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (_etapeActuelle > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _etapeActuelle--),
                            icon: const Icon(Icons.arrow_back),
                            label: Text(_labelPrecedent(langue)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.roseFonce,
                              side:
                                  const BorderSide(color: AppColors.roseFonce),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      if (_etapeActuelle > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_etapeActuelle < etapes.length - 1) {
                              setState(() => _etapeActuelle++);
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_labelTermine(langue)),
                                  backgroundColor: AppColors.roseFonce,
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            _etapeActuelle < etapes.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                          ),
                          label: Text(
                            _etapeActuelle < etapes.length - 1
                                ? _labelSuivant(langue)
                                : _labelTerminer(langue),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.roseFonce,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _labelPrecedent(String l) {
    switch (l) {
      case 'moore':
        return 'Bãag';
      case 'dioula':
        return 'Kɔfɛ';
      case 'fulfude':
        return 'Yeeso';
      default:
        return 'Précédent';
    }
  }

  String _labelSuivant(String l) {
    switch (l) {
      case 'moore':
        return 'Yɩɩd';
      case 'dioula':
        return 'Tɛmɛ';
      case 'fulfude':
        return 'Yeeso';
      default:
        return 'Suivant';
    }
  }

  String _labelTerminer(String l) {
    switch (l) {
      case 'moore':
        return 'Wãã';
      case 'dioula':
        return 'Lɔgɔ';
      case 'fulfude':
        return 'Timmal';
      default:
        return 'Terminer';
    }
  }

  String _labelTermine(String l) {
    switch (l) {
      case 'moore':
        return 'Auto-examen wãã!';
      case 'dioula':
        return 'Auto-examen lɔgɔra!';
      case 'fulfude':
        return 'Auto-examen timmii!';
      default:
        return 'Auto-examen terminé !';
    }
  }
}
