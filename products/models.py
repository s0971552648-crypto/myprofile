from django.db import models

class Product(models.Model):
    name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.CharField(max_length=100, blank=True, null=True)  # 存檔名 a.jpg
    stock = models.PositiveIntegerField(default=0)  # ✅ 預設 0，不會報錯

    def __str__(self):
        return self.name
