defmodule SamsonEnMarieWeb.Api.UserView do
  use SamsonEnMarieWeb, :view

  def render("index.json", %{user: user}) do
    %{data: render_many(user, SamsonEnMarieWeb.Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.voornaam
    }
  end

  def render("showcart.json", %{user: producten}) do
    IO.inspect(producten)
    %{data: render_many(producten, SamsonEnMarieWeb.Api.UserView, "cart.json")}
  end

  def render("cart.json", %{user: producten}) do
    %{
      id: producten.id,
      title: producten.title,
      color: producten.color,
      size: producten.size,
      description: producten.description,
      price: producten.price
    }
  end

  def render("fout.json", %{message: message}) do
      %{
        message: message
      }
  end
end
