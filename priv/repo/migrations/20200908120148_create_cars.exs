defmodule Estate.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :regno, :string
      add :resident, :integer
      add :type, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:cars, [:user_id])
  end
end
