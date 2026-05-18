from django.contrib import admin
from .models import StatAnonyme

@admin.register(StatAnonyme)
class StatAnonymeAdmin(admin.ModelAdmin):
    list_display = ['periode', 'nb_evaluations',
                    'nb_faible', 'nb_modere', 'nb_eleve']
    readonly_fields = ['periode', 'nb_evaluations',
                       'nb_faible', 'nb_modere', 'nb_eleve']