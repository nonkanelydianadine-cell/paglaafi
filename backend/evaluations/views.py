from rest_framework import viewsets, permissions
from .models import OptionReponse
from .serializers import (
    OptionReponseSerializer,
    QuestionAvecOptionsSerializer,
)
from contenus.models import Question


class OptionReponseViewSet(viewsets.ModelViewSet):
    queryset = OptionReponse.objects.all()
    serializer_class = OptionReponseSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]


class QuestionAvecOptionsViewSet(viewsets.ReadOnlyModelViewSet):
    # Vue lecture seule — questions avec leurs options
    queryset = Question.objects.filter(
        actif=True
    ).prefetch_related('options').order_by('ordre')
    serializer_class = QuestionAvecOptionsSerializer
    permission_classes = [permissions.AllowAny]