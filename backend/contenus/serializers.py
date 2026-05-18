from rest_framework import serializers
from .models import ContenuEducatif, Question, EtapeAutoExamen

class ContenuEducatifSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContenuEducatif
        fields = '__all__'


class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = '__all__'


class EtapeAutoExamenSerializer(serializers.ModelSerializer):
    class Meta:
        model = EtapeAutoExamen
        fields = '__all__'