from django.contrib import admin
from .models import ContenuEducatif, Question, EtapeAutoExamen

@admin.register(ContenuEducatif)
class ContenuEducatifAdmin(admin.ModelAdmin):
    list_display = ['titre_fr', 'categorie', 'ordre', 'actif']
    list_filter  = ['categorie', 'actif']
    search_fields = ['titre_fr']

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ['ordre', 'enonce_fr', 'type_reponse', 'poids_max', 'actif']
    list_filter  = ['actif', 'type_reponse']

@admin.register(EtapeAutoExamen)
class EtapeAutoExamenAdmin(admin.ModelAdmin):
    list_display = ['numero_etape', 'titre_fr']