defmodule Estate.Repo.Migrations.CreateResidents do
  use Ecto.Migration

  def change do
    create table(:residents) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :phone, :string
      add :housenumber, :string
      add :status, :string
      add :ifso, :string
      add :cars, :integer
      add :description, :string
      add :paid, :string
      add :water, :string
      add :servicecharge, :string
      add :serial, :string
      add :image, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:residents, [:email])
    create unique_index(:residents, [:phone])
    create unique_index(:residents, [:housenumber])
    create unique_index(:residents, [:serial])
    create index(:residents, [:user_id])
  end
end
