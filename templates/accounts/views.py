from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required

def register(request):
    """會員註冊"""
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = User.objects.create_user(username=username, password=password)
        login(request, user)
        return redirect("accounts:dashboard")
    return render(request, "accounts/register.html")

@login_required
def dashboard(request):
    """會員中心"""
    return render(request, "accounts/dashboard.html")
