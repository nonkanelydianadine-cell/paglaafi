from rest_framework import serializers
from .models import OptionReponse
from contenus.models import Question

class OptionReponseSerializer(serializers.ModelSerializer):
    class Meta:
        model = OptionReponse
        fields = '__all__'


class QuestionAvecOptionsSerializer(serializers.ModelSerializer):
    # Retourne une question avec toutes ses options de réponse
    options = OptionReponseSerializer(many=True, read_only=True)

    class Meta:
        model = Question
        fields = '__all__'