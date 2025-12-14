# init-django-shop.ps1  —  一次建立 Django 開發骨架 (products + cart + templates)

# 以腳本所在資料夾為根目錄運作（不靠目前工作目錄）
$Root = $PSScriptRoot
if (-not $Root) { $Root = (Get-Location).Path }
Set-Location $Root

# 目錄
New-Item -ItemType Directory -Force -Path .\mysite       | Out-Null
New-Item -ItemType Directory -Force -Path .\products     | Out-Null
New-Item -ItemType Directory -Force -Path .\cart         | Out-Null
New-Item -ItemType Directory -Force -Path .\templates    | Out-Null

# manage.py
@'
#!/usr/bin/env python
import os
import sys

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')
    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
'@ | Set-Content .\manage.py -Encoding UTF8

# mysite/__init__.py (空檔)
"" | Set-Content .\mysite\__init__.py -Encoding UTF8

# mysite/settings.py
@'
from pathlib import Path

# 專案根目錄
BASE_DIR = Path(__file__).resolve().parent.parent

# 測試用金鑰，正式請改
SECRET_KEY = 'dev-secret-key-change-me'

# 開發模式
DEBUG = True
ALLOWED_HOSTS = []

# App
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'products',
    'cart',
]

# 中介層
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# URL 入口
ROOT_URLCONF = 'mysite.urls'

# 模板
TEMPLATES = [{
    'BACKEND': 'django.template.backends.django.DjangoTemplates',
    'DIRS': [BASE_DIR / 'templates'],
    'APP_DIRS': True,
    'OPTIONS': {
        'context_processors': [
            'django.template.context_processors.debug',
            'django.template.context_processors.request',
            'django.contrib.auth.context_processors.auth',
            'django.contrib.messages.context_processors.messages',
        ],
    },
}]

# WSGI/ASGI
WSGI_APPLICATION = 'mysite.wsgi.application'
ASGI_APPLICATION = 'mysite.asgi.application'

# 資料庫
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# 密碼驗證（開發先關）
AUTH_PASSWORD_VALIDATORS = []

# 語系/時區
LANGUAGE_CODE = 'zh-hant'
TIME_ZONE = 'Asia/Taipei'
USE_I18N = True
USE_TZ = True

# 靜態/媒體
STATIC_URL = 'static/'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

# 主鍵型別
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
'@ | Set-Content .\mysite\settings.py -Encoding UTF8

# mysite/urls.py
@'
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('products.urls', namespace='products')),
    path('cart/', include('cart.urls', namespace='cart')),
]
'@ | Set-Content .\mysite\urls.py -Encoding UTF8

# mysite/wsgi.py
@'
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')
application = get_wsgi_application()
'@ | Set-Content .\mysite\wsgi.py -Encoding UTF8

# mysite/asgi.py
@'
import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')
application = get_asgi_application()
'@ | Set-Content .\mysite\asgi.py -Encoding UTF8

# products/__init__.py (空檔)
"" | Set-Content .\products\__init__.py -Encoding UTF8

# products/apps.py
@'
from django.apps import AppConfig
class ProductsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'products'
'@ | Set-Content .\products\apps.py -Encoding UTF8

# products/views.py
@'
from django.shortcuts import render

def home(request):
    return render(request, "home.html")
'@ | Set-Content .\products\views.py -Encoding UTF8

# products/urls.py
@'
from django.urls import path
from . import views

app_name = "products"
urlpatterns = [
    path("", views.home, name="home"),
]
'@ | Set-Content .\products\urls.py -Encoding UTF8

# cart/__init__.py (空檔)
"" | Set-Content .\cart\__init__.py -Encoding UTF8

# cart/apps.py
@'
from django.apps import AppConfig
class CartConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'cart'
'@ | Set-Content .\cart\apps.py -Encoding UTF8

# cart/views.py
@'
from django.shortcuts import redirect, render
from django.views.decorators.http import require_POST

@require_POST
def add_to_cart(request, product_id):
    cart = request.session.get('cart', {})
    qty = int(request.POST.get('qty', 1))
    cart[str(product_id)] = cart.get(str(product_id), 0) + qty
    request.session['cart'] = cart
    return redirect('products:home')

def cart_page(request):
    cart = request.session.get('cart', {})
    items = [{'id': k, 'qty': v} for k, v in cart.items()]
    return render(request, 'cart.html', {'items': items})
'@ | Set-Content .\cart\views.py -Encoding UTF8

# cart/urls.py
@'
from django.urls import path
from . import views

app_name = "cart"
urlpatterns = [
    path('', views.cart_page, name='page'),
    path('add/<int:product_id>/', views.add_to_cart, name='add'),
]
'@ | Set-Content .\cart\urls.py -Encoding UTF8

# templates/base.html
@'
<!doctype html>
<html lang="zh-Hant">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>{% block title %}我的商店{% endblock %}</title>
  <style>
    body { font-family: sans-serif; max-width: 900px; margin: 40px auto; }
    nav a { margin-right: 12px; }
    .card { border: 1px solid #ddd; padding: 12px; border-radius: 8px; margin: 8px 0; }
  </style>
</head>
<body>
  <nav>
    <a href="/">首頁</a>
    <a href="/cart/">購物車</a>
    <form method="get" action="/" style="display:inline-block; margin-left:12px">
      <input type="text" name="q" value="{{ request.GET.q }}" placeholder="搜尋商品…">
      <button type="submit">搜尋</button>
    </form>
  </nav>
  <hr>
  {% block content %}{% endblock %}
</body>
</html>
'@ | Set-Content .\templates\base.html -Encoding UTF8

# templates/home.html
@'
{% extends "base.html" %}
{% block title %}首頁{% endblock %}
{% block content %}
  <h1>商品搜尋（GET 範例）</h1>
  {% if request.GET.q %}
    <p>你搜尋了：<strong>{{ request.GET.q }}</strong></p>
  {% endif %}

  <h2>示範商品</h2>
  <div class="card">
    <p>商品 A – $100</p>
    <form method="post" action="{% url 'cart:add' 1 %}">
      {% csrf_token %}
      <input type="number" name="qty" value="1" min="1">
      <button type="submit">加入購物車</button>
    </form>
  </div>
{% endblock %}
'@ | Set-Content .\templates\home.html -Encoding UTF8

# templates/cart.html
@'
{% extends "base.html" %}
{% block title %}購物車{% endblock %}
{% block content %}
  <h1>購物車</h1>
  {% if items %}
    <ul>
      {% for it in items %}
        <li>商品ID：{{ it.id }}，數量：{{ it.qty }}</li>
      {% endfor %}
    </ul>
  {% else %}
    <p>購物車是空的。</p>
  {% endif %}
{% endblock %}
'@ | Set-Content .\templates\cart.html -Encoding UTF8

# (可選) 需求檔
@'
django>=5.2.6
'@ | Set-Content .\requirements.txt -Encoding UTF8

Write-Host "✅ Django Shop Skeleton 建立完成！路徑：$Root"
