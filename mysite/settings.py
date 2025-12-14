from pathlib import Path

# 專案根目錄
BASE_DIR = Path(__file__).resolve().parent.parent

# 測試用金鑰（⚠️ 正式上線請更換）
SECRET_KEY = 'dev-secret-key-change-me'

# 開發模式
DEBUG = True
ALLOWED_HOSTS = []  # 上線時要設定 ['你的網域', '伺服器IP']

# 已安裝的 App
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # 自訂應用
    'products',
    'cart',
    'accounts',
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

# 模板設定
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],   # 專案層級的 templates 目錄
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# WSGI / ASGI
WSGI_APPLICATION = 'mysite.wsgi.application'
ASGI_APPLICATION = 'mysite.asgi.application'

# 資料庫（預設 SQLite）
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# 密碼驗證（開發模式可關閉）
AUTH_PASSWORD_VALIDATORS = [
    # ⚠️ 正式上線建議開啟以下驗證：
    # {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    # {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    # {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    # {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

# 語系 / 時區
LANGUAGE_CODE = 'zh-hant'
TIME_ZONE = 'Asia/Taipei'
USE_I18N = True
USE_TZ = True

# 靜態檔案（CSS / JS / 圖片）
STATIC_URL = '/static/'
STATICFILES_DIRS = [
    BASE_DIR / "static",   # 開發用：專案層級的 static 資料夾
]
STATIC_ROOT = BASE_DIR / "staticfiles"  # 上線收集用：python manage.py collectstatic

# 媒體檔案（使用者上傳）
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# 主鍵型別
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# 登入 / 登出後導向
LOGIN_REDIRECT_URL = "/"   # 登入後回首頁 (你之前是 dashboard，但沒有這個頁面，所以404)
LOGOUT_REDIRECT_URL = "/"  # 登出後回首頁
