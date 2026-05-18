from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from rest_framework.authtoken.views import obtain_auth_token

# Contenus
from contenus.views import (
    ContenuEducatifViewSet,
    QuestionViewSet,
    EtapeAutoExamenViewSet,
)
# Centres
from centres.views import CentreSanteViewSet
# Statistiques
from statistiques.views import StatAnonymeViewSet
# Evaluations
from evaluations.views import (
    OptionReponseViewSet,
    QuestionAvecOptionsViewSet,
)

# Router — crée automatiquement toutes les URLs CRUD
router = DefaultRouter()
router.register(r'contenus',        ContenuEducatifViewSet,    basename='contenus')
router.register(r'questions',       QuestionViewSet,           basename='questions')
router.register(r'etapes',          EtapeAutoExamenViewSet,    basename='etapes')
router.register(r'centres',         CentreSanteViewSet,        basename='centres')
router.register(r'stats',           StatAnonymeViewSet,        basename='stats')
router.register(r'options',         OptionReponseViewSet,      basename='options')
router.register(r'questions-completes', QuestionAvecOptionsViewSet, basename='questions-completes')

urlpatterns = [
    # Interface admin Django
    path('admin/', admin.site.urls),

    # Authentification JWT
    # POST /api/auth/login/  → obtenir un token
    # POST /api/auth/refresh/ → rafraîchir le token
    path('api/auth/login/',   TokenObtainPairView.as_view(),  name='token_obtain'),
    path('api/auth/refresh/', TokenRefreshView.as_view(),     name='token_refresh'),
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),

    # Toutes les routes API
    path('api/', include(router.urls)),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)