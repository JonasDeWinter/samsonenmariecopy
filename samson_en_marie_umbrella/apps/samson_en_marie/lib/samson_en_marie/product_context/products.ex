defmodule SamsonEnMarie.ProductContext.Products do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :title, :color, :size, :description, :price]}
  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.WinkelkarContext.Winkelkar

  schema "products" do
    field :color, :string
    field :size, :string
    field :description, :string
    field :price, :float
    field :title, :string
    belongs_to :winkelkar, Winkelkar
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:title, :description, :size, :color, :price])
    |> validate_required([:title, :description, :size, :color, :price])
  end
end
