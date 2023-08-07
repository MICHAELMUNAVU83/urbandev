defmodule Urbandev.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add(:role, :string, null: false)
      add :address, :string, null: true
      add :company, :string, null: true
      add(:location, :string, null: true)
      add :firstname, :string, null: true
      add(:image, :string, null: true)
      add :lastname, :string, null: true
      add :phone, :string, null: true
      add :verified, :integer, null: true
      add :active, :string, null: true, default: false
      add :username, :string, null: true
      add(:logged, :string, null: true)
    end

  end
end
