defmodule SamsonEnMarie.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias SamsonEnMarie.ProductContext.Products
  alias SamsonEnMarie.WinkelkarContext.Winkelkar

  @acceptable_roles ["Admin", "Geregistreerde gebruiker", "Gast"]

  schema "users" do
    field :achternaam, :string
    field :email, :string
    field :hashed_password, :string
    field :huisnr, :string
    field :land, :string
    field :postcode, :string
    field :role, :string, default: "Geregistreerde gebruiker"
    field :stad, :string
    field :straat, :string
    field :voornaam, :string
    field :password, :string, virtual: true
    field :validated, :boolean, default: false
    field :verification_token, :string
    field :verification_token_sent_at, :naive_datetime
    field :api_token, :string
    has_many :history, Products, on_replace: :nilify
    has_one :winkelkar, Winkelkar

    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:voornaam, :achternaam,:password, :email, :land, :stad, :postcode, :straat, :huisnr, :role, :verification_token,:verification_token_sent_at,:api_token])
    |> validate_required([:voornaam, :achternaam, :email, :land, :stad, :postcode, :straat, :huisnr, :role])
    |> cast_assoc(:history)
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> validate_confirmation(:hashed_password)
  end

  def changeset(user, attrs, %Winkelkar{} = winkelkar) do
    IO.inspect(1)
    user
    |> cast(attrs, [:voornaam, :achternaam,:password, :email, :land, :stad, :postcode, :straat, :huisnr, :role, :verification_token,:verification_token_sent_at,:api_token])
    |> validate_required([:voornaam, :achternaam, :email, :land, :stad, :postcode, :straat, :huisnr, :role])
    |> put_assoc(:winkelkar, winkelkar)
    |> cast_assoc(:history)
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
    |> validate_confirmation(:hashed_password)
  end

  def bestellen(user, attrs, producten) do
    user
    |> cast(attrs, [:voornaam, :achternaam,:password, :email, :land, :stad, :postcode, :straat, :huisnr, :role, :verification_token,:verification_token_sent_at,:api_token])
    |> validate_required([:voornaam, :achternaam, :email, :land, :stad, :postcode, :straat, :huisnr, :role])
    |> put_assoc(:history, producten)

  end


  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
      change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset



end
