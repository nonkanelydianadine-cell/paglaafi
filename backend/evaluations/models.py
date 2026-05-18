from django.db import models
from contenus.models import Question

class OptionReponse(models.Model):
    question     = models.ForeignKey(
        Question,
        on_delete=models.CASCADE,
        related_name='options'
    )
    texte_fr     = models.CharField(max_length=200)
    texte_moore  = models.CharField(max_length=200, blank=True)
    texte_dioula = models.CharField(max_length=200, blank=True)
    texte_fulfude = models.CharField(max_length=200, blank=True)
    poids        = models.IntegerField(default=0)
    ordre        = models.IntegerField(default=0)

    class Meta:
        ordering = ['ordre']
        verbose_name = 'Option de réponse'
        verbose_name_plural = 'Options de réponse'

    def __str__(self):
        return f"Q{self.question.ordre} — {self.texte_fr}"