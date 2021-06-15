defmodule SamsonEnMarie.WinkelkarContext do
  @moduledoc """
  The WinkelkarContext context.
  """

  import Ecto.Query, warn: false
  alias SamsonEnMarie.Repo

  alias SamsonEnMarie.WinkelkarContext.Winkelkar
  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.ProductContext.Products
  alias SamsonEnMarie.ProductContext
  @doc """
  Returns the list of winkelkarren.

  ## Examples

      iex> list_winkelkarren()
      [%Winkelkar{}, ...]

  """
  def list_winkelkarren do
    Repo.all(Winkelkar)
  end

  @doc """
  Gets a single winkelkar.

  Raises `Ecto.NoResultsError` if the Winkelkar does not exist.

  ## Examples

      iex> get_winkelkar!(123)
      %Winkelkar{}

      iex> get_winkelkar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_winkelkar!(id), do: Repo.get!(Winkelkar, id)

  @doc """
  Creates a winkelkar.

  ## Examples

      iex> create_winkelkar(%{field: value})
      {:ok, %Winkelkar{}}

      iex> create_winkelkar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_winkelkar(%User{} = user) do
    %Winkelkar{}
    |> Winkelkar.changeset(%{},user)
    |> Repo.insert()
    |> IO.inspect()
  end

  def show_last() do
    Repo.all(from p in Winkelkar,
              limit: 1, order_by: [desc: p.inserted_at])
  end

  @doc """
  Updates a winkelkar.

  ## Examples

      iex> update_winkelkar(winkelkar, %{field: new_value})
      {:ok, %Winkelkar{}}

      iex> update_winkelkar(winkelkar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_winkelkar(%Winkelkar{} = winkelkar, attrs) do
    winkelkar
    |> Winkelkar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a winkelkar.

  ## Examples

      iex> delete_winkelkar(winkelkar)
      {:ok, %Winkelkar{}}

      iex> delete_winkelkar(winkelkar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_winkelkar(%Winkelkar{} = winkelkar) do
    Repo.delete(winkelkar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking winkelkar changes.

  ## Examples

      iex> change_winkelkar(winkelkar)
      %Ecto.Changeset{data: %Winkelkar{}}

  """
  def change_winkelkar(%Winkelkar{} = winkelkar, attrs \\ %{}) do
    Winkelkar.changeset(winkelkar, attrs)
  end

  def add_to_winkelkar(%Winkelkar{} = winkelkar ,%Products{} = product) do

    new_winkelkar = Repo.preload(winkelkar,[:user, :products])
    attrs = %{id: Map.get(new_winkelkar, :id)}
    Winkelkar.changeset(new_winkelkar,attrs,product)
    |>Repo.update()
    |>IO.inspect()
  end

  def delete_product(%Winkelkar{} = winkelkar, %Products{} = product) do
    new_winkelkar = Repo.preload(winkelkar,[:user, :products])
    attrs = %{id: Map.get(new_winkelkar, :id)}
    Winkelkar.delete(new_winkelkar,attrs,product)
    |>Repo.update()
  end

  def betaling(%Winkelkar{} = winkelkar) do
    new_winkelkar = Repo.preload(winkelkar,[:user, :products])
    attrs = %{id: Map.get(new_winkelkar, :id)}

    Winkelkar.betalen(new_winkelkar,attrs,[])
    |>Repo.update()

  end
end
