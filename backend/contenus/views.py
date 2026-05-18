from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import ContenuEducatif, Question, EtapeAutoExamen
from .serializers import (
    ContenuEducatifSerializer,
    QuestionSerializer,
    EtapeAutoExamenSerializer,
)


class ContenuEducatifViewSet(viewsets.ModelViewSet):
    # Admin seulement pour créer/modifier/supprimer
    # Lecture accessible sans authentification
    # (pour que le mobile puisse synchroniser)
    queryset = ContenuEducatif.objects.filter(actif=True)
    serializer_class = ContenuEducatifSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]

    def get_queryset(self):
        queryset = ContenuEducatif.objects.filter(actif=True)
        # Filtre par catégorie si fourni dans l'URL
        # Ex: /api/contenus/?categorie=cancer
        categorie = self.request.query_params.get('categorie')
        if categorie:
            queryset = queryset.filter(categorie=categorie)
        return queryset

    @action(detail=False, methods=['get'],
            permission_classes=[permissions.AllowAny])
    def par_categorie(self, request):
        # Retourne les contenus groupés par catégorie
        categories = ['cancer', 'signes', 'prevention', 'risques']
        result = {}
        for cat in categories:
            contenus = ContenuEducatif.objects.filter(
                categorie=cat, actif=True
            )
            result[cat] = ContenuEducatifSerializer(
                contenus, many=True
            ).data
        return Response(result)


class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.filter(actif=True).order_by('ordre')
    serializer_class = QuestionSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]


class EtapeAutoExamenViewSet(viewsets.ModelViewSet):
    queryset = EtapeAutoExamen.objects.all().order_by('numero_etape')
    serializer_class = EtapeAutoExamenSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]