defmodule SamsonEnMarie.ProductContext do
  @moduledoc """
  The ProductContext context.
  """

  import Ecto.Query, only: [from: 2]
  alias SamsonEnMarie.Repo

  alias SamsonEnMarie.ProductContext.Products

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Products{}, ...]

  """
  def list_products do
    Repo.all(Products)

  end

  def minimum_prijs(prijs) do
    Repo.all(from p in Products,
             where: p.price >= type(^prijs, :integer))
  end

  def maximum_prijs(prijs) do
    Repo.all(from p in Products,
             where: p.price <= type(^prijs, :integer))
  end

  def zoek_naam(naam) do
    Repo.all(from p in Products,
             where: p.title == ^naam)
  end

  def zoek_kleur(kleur) do
    Repo.all(from p in Products,
             where: p.color == ^kleur)
  end

  def zoek_maat(maat) do
    Repo.all(from p in Products,
             where: p.size == ^maat)
  end

  @doc """
  Gets a single products.

  Raises `Ecto.NoResultsError` if the Products does not exist.

  ## Examples

      iex> get_products!(123)
      %Products{}

      iex> get_products!(456)
      ** (Ecto.NoResultsError)

  """
  def get_products!(id), do: Repo.get!(Products, id)



  @doc """
  Creates a products.

  ## Examples

      iex> create_products(%{field: value})
      {:ok, %Products{}}

      iex> create_products(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_products(attrs \\ %{}) do
    %Products{}
    |> Products.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a products.

  ## Examples

      iex> update_products(products, %{field: new_value})
      {:ok, %Products{}}

      iex> update_products(products, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_products(%Products{} = products, attrs) do
    products
    |> Products.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a products.

  ## Examples

      iex> delete_products(products)
      {:ok, %Products{}}

      iex> delete_products(products)
      {:error, %Ecto.Changeset{}}

  """
  def delete_products(%Products{} = products) do
    Repo.delete(products)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking products changes.

  ## Examples

      iex> change_products(products)
      %Ecto.Changeset{data: %Products{}}

  """
  def change_products(%Products{} = products, attrs \\ %{}) do
    Products.changeset(products, attrs)
  end
end
