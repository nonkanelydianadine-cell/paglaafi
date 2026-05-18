from django.contrib import admin
from .models import CentreSante

@admin.register(CentreSante)
class CentreSanteAdmin(admin.ModelAdmin):
    list_display  = ['nom', 'ville', 'telephone', 'distance_km', 'actif']
    list_filter   = ['ville', 'actif']
    search_fields = ['nom', 'adresse']