from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import StatAnonyme
from .serializers import StatAnonymeSerializer, StatAnonymeCreateSerializer


class StatAnonymeViewSet(viewsets.ModelViewSet):
    queryset = StatAnonyme.objects.all()
    serializer_class = StatAnonymeSerializer
    permission_classes = [permissions.IsAdminUser]

    @action(
        detail=False,
        methods=['post'],
        # Le mobile peut envoyer sans authentification
        permission_classes=[permissions.AllowAny]
    )
    def recevoir(self, request):
        # Endpoint appelé par l'app mobile
        # Reçoit les stats anonymes et les fusionne
        serializer = StatAnonymeCreateSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        stats = serializer.validated_data['stats']
        for stat_data in stats:
            periode = stat_data.get('periode')
            if not periode:
                continue

            # Crée ou met à jour la stat pour cette période
            stat, created = StatAnonyme.objects.get_or_create(
                periode=periode,
                defaults={
                    'nb_evaluations': 0,
                    'nb_faible': 0,
                    'nb_modere': 0,
                    'nb_eleve': 0,
                }
            )
            # Additionne les nouvelles valeurs
            stat.nb_evaluations += stat_data.get('nb_evaluations', 0)
            stat.nb_faible      += stat_data.get('nb_faible', 0)
            stat.nb_modere      += stat_data.get('nb_modere', 0)
            stat.nb_eleve       += stat_data.get('nb_eleve', 0)
            stat.save()

        return Response(
            {'message': 'Statistiques reçues avec succès'},
            status=status.HTTP_200_OK
        )

    @action(detail=False, methods=['get'])
    def resume(self, request):
        # Retourne un résumé global pour le tableau de bord admin
        stats = StatAnonyme.objects.all()
        total_evaluations = sum(s.nb_evaluations for s in stats)
        total_faible = sum(s.nb_faible for s in stats)
        total_modere = sum(s.nb_modere for s in stats)
        total_eleve  = sum(s.nb_eleve  for s in stats)

        return Response({
            'total_evaluations': total_evaluations,
            'total_faible':  total_faible,
            'total_modere':  total_modere,
            'total_eleve':   total_eleve,
            'par_periode': StatAnonymeSerializer(
                stats, many=True
            ).data,
        })