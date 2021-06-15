defmodule SamsonEnMarie.WinkelkarContext.Winkelkar do
  use Ecto.Schema
  import Ecto.Changeset

  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.ProductContext.Products

  schema "winkelkarren" do
    belongs_to :user, User
    has_many :products, Products, on_replace: :nilify
    timestamps()
  end

  @doc false
  def changeset(winkelkar, attrs) do
    winkelkar
    |> cast(attrs,[:id])
    |> cast_assoc(:products)
  end

  def changeset(winkelkar, attrs, %User{} = user) do

    winkelkar
    |> cast(attrs,[:id])
    |> put_assoc(:user, user)
    |> cast_assoc(:products)
  end

  def changeset(winkelkar, attrs, %Products{} = product) do
    IO.inspect(product)
    all_products = Map.get(winkelkar, :products) ++ [product]
    |>IO.inspect()

    winkelkar
    |> cast(attrs,[:id])
    |> put_assoc(:products, all_products)
    |> IO.inspect()
  end

  def delete(winkelkar, attrs, %Products{} = product) do
    IO.inspect(product)
    all_products = Map.get(winkelkar, :products) -- [product]
    |>IO.inspect()

    winkelkar
    |> cast(attrs,[:id])
    |> put_assoc(:products, all_products)
    |> IO.inspect()
  end

  def betalen(winkelkar, attrs, product) do

    winkelkar
    |> cast(attrs,[:id])
    |> put_assoc(:products, product)
    |> IO.inspect()
  end
end
