defmodule SamsonEnMarie.Repo.Migrations.CreateWinkelkarren do
  use Ecto.Migration
  alias SamsonEnMarie.UserContext.User

  def change do
    create table(:winkelkarren) do
      add :user_id, references(:users)

      timestamps()
    end

  end
end
