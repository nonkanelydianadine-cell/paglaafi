from rest_framework import serializers
from .models import StatAnonyme

class StatAnonymeSerializer(serializers.ModelSerializer):
    class Meta:
        model = StatAnonyme
        fields = '__all__'


class StatAnonymeCreateSerializer(serializers.Serializer):
    # Serializer pour recevoir les stats du mobile
    # Le mobile envoie une liste de stats
    stats = serializers.ListField(
        child=serializers.DictField()
    )