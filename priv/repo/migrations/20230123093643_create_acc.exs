defmodule Urbandev.Repo.Migrations.CreateAcc do
  use Ecto.Migration

  def change do
    create table(:acc) do
      add :name, :string
      add :phone, :integer
      add :idnumber, :integer
      add :location, :integer
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:acc, [:user_id])
  end
end
