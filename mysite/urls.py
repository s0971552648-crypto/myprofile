from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include(("products.urls", "products"), namespace="products")),
    path("cart/", include(("cart.urls", "cart"), namespace="cart")),
    path("accounts/", include(("accounts.urls", "accounts"), namespace="accounts")),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
