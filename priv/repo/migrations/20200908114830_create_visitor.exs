defmodule Estate.Repo.Migrations.CreateVisitor do
  use Ecto.Migration

  def change do
    create table(:visitor) do
      add :names, :string
      add :phone, :string
      add :nationalid, :string
      add :visiting, :string
      add :time, :string
      add :serial, :string
      add :image, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:visitor, [:phone])
    create unique_index(:visitor, [:serial])
    create index(:visitor, [:user_id])
  end
end
