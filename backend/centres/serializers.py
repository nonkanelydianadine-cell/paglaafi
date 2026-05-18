from rest_framework import serializers
from .models import CentreSante

class CentreSanteSerializer(serializers.ModelSerializer):
    class Meta:
        model = CentreSante
        fields = '__all__'