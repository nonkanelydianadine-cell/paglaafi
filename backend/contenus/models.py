from django.db import models

class ContenuEducatif(models.Model):
    CATEGORIES = [
        ('cancer',     'Cancer du sein'),
        ('signes',     'Signes précoces'),
        ('prevention', 'Prévention'),
        ('risques',    'Facteurs de risque'),
    ]

    categorie       = models.CharField(max_length=20, choices=CATEGORIES)
    ordre           = models.IntegerField()
    titre_fr        = models.CharField(max_length=200)
    titre_moore     = models.CharField(max_length=200, blank=True)
    titre_dioula    = models.CharField(max_length=200, blank=True)
    titre_fulfude   = models.CharField(max_length=200, blank=True)
    texte_fr        = models.TextField()
    texte_moore     = models.TextField(blank=True)
    texte_dioula    = models.TextField(blank=True)
    texte_fulfude   = models.TextField(blank=True)
    illustration    = models.ImageField(
        upload_to='illustrations/', blank=True, null=True)
    audio_fr        = models.FileField(
        upload_to='audio/fr/', blank=True, null=True)
    audio_moore     = models.FileField(
        upload_to='audio/moore/', blank=True, null=True)
    audio_dioula    = models.FileField(
        upload_to='audio/dioula/', blank=True, null=True)
    audio_fulfude   = models.FileField(
        upload_to='audio/fulfude/', blank=True, null=True)
    actif           = models.BooleanField(default=True)
    date_creation   = models.DateTimeField(auto_now_add=True)
    date_modification = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['categorie', 'ordre']
        verbose_name = 'Contenu éducatif'
        verbose_name_plural = 'Contenus éducatifs'

    def __str__(self):
        return f"{self.categorie} — {self.titre_fr}"


class Question(models.Model):
    TYPES = [
        ('oui_non',        'Oui / Non'),
        ('choix_multiple', 'Choix multiple'),
    ]

    ordre           = models.IntegerField(unique=True)
    type_reponse    = models.CharField(
        max_length=20, choices=TYPES, default='choix_multiple')
    poids_max       = models.IntegerField(default=3)
    enonce_fr       = models.TextField()
    enonce_moore    = models.TextField(blank=True)
    enonce_dioula   = models.TextField(blank=True)
    enonce_fulfude  = models.TextField(blank=True)
    audio_fr        = models.FileField(
        upload_to='audio/questions/fr/', blank=True, null=True)
    audio_moore     = models.FileField(
        upload_to='audio/questions/moore/', blank=True, null=True)
    audio_dioula    = models.FileField(
        upload_to='audio/questions/dioula/', blank=True, null=True)
    audio_fulfude   = models.FileField(
        upload_to='audio/questions/fulfude/', blank=True, null=True)
    actif           = models.BooleanField(default=True)

    class Meta:
        ordering = ['ordre']
        verbose_name = 'Question'
        verbose_name_plural = 'Questions'

    def __str__(self):
        return f"Question {self.ordre} — {self.enonce_fr[:50]}"


class EtapeAutoExamen(models.Model):
    numero_etape        = models.IntegerField(unique=True)
    titre_fr            = models.CharField(max_length=200)
    titre_moore         = models.CharField(max_length=200, blank=True)
    titre_dioula        = models.CharField(max_length=200, blank=True)
    titre_fulfude       = models.CharField(max_length=200, blank=True)
    description_fr      = models.TextField()
    description_moore   = models.TextField(blank=True)
    description_dioula  = models.TextField(blank=True)
    description_fulfude = models.TextField(blank=True)
    illustration        = models.ImageField(
        upload_to='etapes/', blank=True, null=True)
    audio_fr            = models.FileField(
        upload_to='audio/etapes/fr/', blank=True, null=True)
    audio_moore         = models.FileField(
        upload_to='audio/etapes/moore/', blank=True, null=True)
    audio_dioula        = models.FileField(
        upload_to='audio/etapes/dioula/', blank=True, null=True)
    audio_fulfude       = models.FileField(
        upload_to='audio/etapes/fulfude/', blank=True, null=True)

    class Meta:
        ordering = ['numero_etape']
        verbose_name = "Étape auto-examen"
        verbose_name_plural = "Étapes auto-examen"

    def __str__(self):
        return f"Étape {self.numero_etape} — {self.titre_fr}"