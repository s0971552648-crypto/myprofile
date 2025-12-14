from django.shortcuts import render, redirect
from products.models import Product

def cart_view(request):
    cart = request.session.get("cart", {})
    items, total = [], 0

    for pid, qty in cart.items():
        product = Product.objects.get(id=pid)
        subtotal = product.price * qty
        items.append({
            "id": product.id,
            "name": product.name,
            "image": product.image,
            "price": product.price,
            "qty": qty,
            "subtotal": subtotal
        })
        total += subtotal

    return render(request, "cart/cart.html", {"items": items, "total": total})

def add_to_cart(request, pid):
    cart = request.session.get("cart", {})
    qty = int(request.POST.get("qty", 1))
    cart[str(pid)] = cart.get(str(pid), 0) + qty
    request.session["cart"] = cart
    return redirect("cart:cart_view")

def remove_from_cart(request, pid):
    cart = request.session.get("cart", {})
    if str(pid) in cart:
        del cart[str(pid)]
    request.session["cart"] = cart
    return redirect("cart:cart_view")
