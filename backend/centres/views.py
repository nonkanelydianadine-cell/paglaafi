from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import CentreSante
from .serializers import CentreSanteSerializer


class CentreSanteViewSet(viewsets.ModelViewSet):
    queryset = CentreSante.objects.filter(actif=True)
    serializer_class = CentreSanteSerializer

    def get_permissions(self):
        if self.action in ['list', 'retrieve', 'par_ville']:
            return [permissions.AllowAny()]
        return [permissions.IsAdminUser()]

    def get_queryset(self):
        queryset = CentreSante.objects.filter(actif=True)
        # Filtre par ville si fourni dans l'URL
        # Ex: /api/centres/?ville=Ouagadougou
        ville = self.request.query_params.get('ville')
        if ville:
            queryset = queryset.filter(ville=ville)
        return queryset.order_by('distance_km')

    @action(detail=False, methods=['get'],
            permission_classes=[permissions.AllowAny])
    def villes(self, request):
        # Retourne la liste des villes disponibles
        villes = CentreSante.objects.filter(
            actif=True
        ).values_list('ville', flat=True).distinct()
        return Response(list(villes))