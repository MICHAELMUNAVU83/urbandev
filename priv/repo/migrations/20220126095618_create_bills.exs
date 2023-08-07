defmodule Urbandev.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :resident, :string
      add :type, :string
      add :date_due, :date
      add :description, :text
      add :amount, :float
      add :paid, :string
      add :penalty, :float
      add :file, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bills, [:user_id])
  end
end
