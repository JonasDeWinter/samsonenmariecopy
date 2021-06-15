defmodule SamsonEnMarieWeb.Api.ProductsController do
  use SamsonEnMarieWeb, :controller

  alias SamsonEnMarie.ProductContext
  alias SamsonEnMarie.ProductContext.Products
  alias SamsonEnMarie.UserContext

  def index(conn, _params) do
    products = ProductContext.list_products()
    render(conn, "index.json", %{products: products})
  end

  def show(conn, %{"id" => id}) do
    products = ProductContext.get_products!(id)
    render(conn, "show.json", %{products: products})
  end
end
