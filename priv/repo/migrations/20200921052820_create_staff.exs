defmodule Estate.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staff) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :phone, :string
      add :nationalid, :string
      add :dob, :date
      add :title, :string
      add :serial, :string
      add :estate, :integer
      add :residence, :string
      add :description, :string
      add :image, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:staff, [:phone])
    create unique_index(:staff, [:serial])
    create index(:staff, [:user_id])
  end
end
