from django.contrib import admin
from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    # 在後台商品列表顯示的欄位
    list_display = ("name", "price")

    # 支援搜尋的欄位
    search_fields = ("name", "description")

    # 預設排序（用名稱）
    ordering = ("name",)
