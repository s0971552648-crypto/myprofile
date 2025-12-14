# cart/admin.py
from django.contrib import admin
from .models import CartItem

@admin.register(CartItem)
class CartItemAdmin(admin.ModelAdmin):
    list_display = ("user", "product", "quantity", "get_total_price")
    search_fields = ("user__username", "product__name")
