defmodule Estate.Repo.Migrations.CreateRealestates do
  use Ecto.Migration

  def change do
    create table(:realestates) do
      add :name, :string
      add :country, :string
      add :county, :string
      add :description, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:realestates, [:user_id])
  end
end
