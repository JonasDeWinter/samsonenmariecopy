defmodule SamsonEnMarieWeb.Api.ProductsView do
  use SamsonEnMarieWeb, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, SamsonEnMarieWeb.Api.ProductsView, "product.json")}
  end

  def render("show.json", %{products: products}) do
    %{data: render_one(products, SamsonEnMarieWeb.Api.ProductsView, "product.json")}
  end

  def render("product.json", %{products: products}) do
    %{
      id: products.id,
      title: products.title,
      color: products.color,
      size: products.size,
      description: products.description,
      price: products.price
    }
  end

end
