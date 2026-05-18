from django.db import models

class CentreSante(models.Model):
    nom         = models.CharField(max_length=200)
    adresse     = models.CharField(max_length=300)
    ville       = models.CharField(max_length=100, default='Ouagadougou')
    telephone   = models.CharField(max_length=20, blank=True)
    horaires    = models.CharField(max_length=200, blank=True)
    distance_km = models.FloatField(null=True, blank=True)
    audio_fr    = models.FileField(
        upload_to='audio/centres/fr/', blank=True, null=True)
    audio_moore = models.FileField(
        upload_to='audio/centres/moore/', blank=True, null=True)
    actif       = models.BooleanField(default=True)
    date_creation     = models.DateTimeField(auto_now_add=True)
    date_modification = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['ville', 'distance_km']
        verbose_name = 'Centre de santé'
        verbose_name_plural = 'Centres de santé'

    def __str__(self):
        return f"{self.nom} — {self.ville}"