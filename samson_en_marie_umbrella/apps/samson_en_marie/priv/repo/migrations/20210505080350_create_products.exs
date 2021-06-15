defmodule SamsonEnMarie.Repo.Migrations.CreateProducts do
  use Ecto.Migration
  alias SamsonEnMarie.UserContext.User
  alias SamsonEnMarie.WinkelkarContext.Winkelkar

  def change do
    create table(:products) do
      add :title, :string
      add :description, :string
      add :size, :string
      add :color, :string
      add :price, :float
      add :winkelkar_id, references(:winkelkarren)
      add :user_id, references(:users)
      timestamps()
    end

  end
end
