defmodule SamsonEnMarie.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :voornaam, :string, null: false
      add :achternaam, :string, null: false
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :land, :string, null: false
      add :stad, :string, null: false
      add :postcode, :string, null: false
      add :straat, :string, null: false
      add :huisnr, :string, null: false
      add :role, :string, null: false
      add :validated, :boolean, default: false
      add :api_token, :string
      timestamps()
    end

  end
end
