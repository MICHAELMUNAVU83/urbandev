defmodule Estate.Repo.Migrations.CreateScans do
  use Ecto.Migration

  def change do
    create table(:scans) do
      add :serial1, :string
      add :serial2, :string
      add :usertype, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:scans, [:user_id])
  end
end
