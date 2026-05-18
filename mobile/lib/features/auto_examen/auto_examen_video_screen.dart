import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';

class AutoExamenVideoScreen extends StatefulWidget {
  const AutoExamenVideoScreen({super.key});

  @override
  State<AutoExamenVideoScreen> createState() =>
      _AutoExamenVideoScreenState();
}

class _AutoExamenVideoScreenState
    extends State<AutoExamenVideoScreen> {
  bool _enLecture = false;

  // Chemins des vidéos selon la langue
  // À remplacer par vos vrais fichiers vidéo
  static const Map<String, String> _cheminVideos = {
    'fr':      'assets/videos/auto_examen_fr.mp4',
    'moore':   'assets/videos/auto_examen_moore.mp4',
    'dioula':  'assets/videos/auto_examen_dioula.mp4',
    'fulfude': 'assets/videos/auto_examen_fulfude.mp4',
  };

  String _getCheminVideo(String langue) {
    return _cheminVideos[langue] ?? _cheminVideos['fr']!;
  }

  @override
  Widget build(BuildContext context) {
    final langue = context.watch<HomeViewModel>().langueActive;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(titre: 'Vidéo explicative'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ── Langue active ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.roseClair),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.language,
                          size: 16,
                          color: AppColors.roseFonce,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _labelLangue(langue),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.roseFonce,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Lecteur vidéo ──
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _enLecture = !_enLecture;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Fond vidéo (placeholder)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end:
                                    Alignment.bottomCenter,
                                colors: [
                                  AppColors.roseFonce
                                      .withOpacity(0.8),
                                  Colors.black,
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),

                          // Icône lecture
                          AnimatedOpacity(
                            opacity: _enLecture ? 0.0 : 1.0,
                            duration: const Duration(
                                milliseconds: 300),
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                size: 44,
                                color: AppColors.roseFonce,
                              ),
                            ),
                          ),

                          // Message "en lecture"
                          if (_enLecture)
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.videocam_outlined,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _messageVideo(langue),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                  textAlign:
                                      TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _getCheminVideo(langue),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10,
                                  ),
                                  textAlign:
                                      TextAlign.center,
                                ),
                              ],
                            ),

                          // Barre bas avec langue
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: Text(
                                _labelLangue(langue),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info fichier vidéo
                  Text(
                    'Vidéo : ${_getCheminVideo(langue)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.texteGris,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Contenu de la vidéo ──
                  const Text(
                    'CONTENU DE LA VIDÉO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.texteGris,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Liste des points couverts
                  ..._pointsVideo(langue).map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.rosePale,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.roseFonce,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 13,
                                color:
                                    AppColors.texteSecondaire,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Note sur la vidéo ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.roseClair),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.roseVif,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _noteVideo(langue),
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
  String _labelLangue(String l) {
    switch (l) {
      case 'moore':   return 'Mooré';
      case 'dioula':  return 'Dioula';
      case 'fulfude': return 'Fulfuldé';
      default:        return 'Français';
    }
  }

  String _messageVideo(String l) {
    switch (l) {
      case 'moore':   return 'Video sẽn tar Mooré...';
      case 'dioula':  return 'Video Dioula kɛra...';
      case 'fulfude': return 'Video Fulfuldé waɗii...';
      default:        return 'Vidéo en cours de lecture...';
    }
  }

  String _noteVideo(String l) {
    switch (l) {
      case 'moore':
        return 'Video sẽn bee ne mooré. Tɩ fo rat vɩɩd ne tõnd toor, lebg n tɩ yãk fo yam yõor tõogore.';
      case 'dioula':
        return 'Video nin bɛ dioula kɔnɔ. Ni i b`a fɛ i ka to yɛlɛma, taa i ka yɛlɛma i ka kumakan sɔrɔ.';
      case 'fulfude':
        return 'Video ngoo woni e fulfuldé. So a yiɗii yiylude e goɗɗo, yah e suɓugol goɗɗo.';
      default:
        return 'Cette vidéo est disponible dans votre langue sélectionnée. Pour changer de langue, retournez sur l\'écran de sélection de langue.';
    }
  }

  List<String> _pointsVideo(String l) {
    if (l == 'moore') {
      return [
        'Sõng f mens',
        'Ges f yĩnga oglem pʋgẽ',
        'Pals f sɛ neere',
        'Ges f sɛ nugã',
        'Bõe la d segd n maand tɩ d yã bũmb',
      ];
    }
    if (l == 'dioula') {
      return [
        'I yɛrɛ labɛn',
        'I yɛrɛ filɛ daga la',
        'I dɛsɛ mara nɔgɔn',
        'I dɛsɛ koro filɛ',
        'Ko kɛ ni i ye ko dɔ',
      ];
    }
    if (l == 'fulfude') {
      return [
        'Labɓu hoore maa',
        'Filtu hoore maa e ndeenka',
        'Taƴtu ɓalndu maa',
        'Hito ɓataake',
        'Ko waɗat so a yiɗii ko woɗɗi',
      ];
    }
    return [
      'Comment vous préparer à l\'auto-examen',
      'Observer vos seins dans le miroir',
      'Palper correctement chaque sein',
      'Vérifier les mamelons',
      'Que faire si vous détectez une anomalie',
    ];
  }
}