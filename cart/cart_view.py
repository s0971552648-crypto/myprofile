# cart/views.py
from django.shortcuts import redirect, render
from django.views.decorators.http import require_POST

@require_POST
def add_to_cart(request, product_id):
    cart = request.session.get("cart", {})
    qty = int(request.POST.get("qty", 1))
    cart[str(product_id)] = cart.get(str(product_id), 0) + qty
    request.session["cart"] = cart
    return redirect("products:home")

def cart_view(request):   # ✅ 改名成 cart_view
    cart = request.session.get("cart", {})
    items = [{"id": k, "qty": v} for k, v in cart.items()]
    return render(request, "cart.html", {"items": items})
