from django.db import models

class StatAnonyme(models.Model):
    # Format YYYY-MM
    periode          = models.CharField(max_length=7, unique=True)
    nb_evaluations   = models.IntegerField(default=0)
    nb_faible        = models.IntegerField(default=0)
    nb_modere        = models.IntegerField(default=0)
    nb_eleve         = models.IntegerField(default=0)
    date_reception   = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-periode']
        verbose_name = 'Statistique anonyme'
        verbose_name_plural = 'Statistiques anonymes'

    def __str__(self):
        return f"Stats {self.periode} — {self.nb_evaluations} évaluations"