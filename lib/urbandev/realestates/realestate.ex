defmodule Urbandev.Realestates.Realestate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User
  alias Urbandev.Kcitys.KCity


  schema "realestates" do
    field :country, :string
    belongs_to(:city, KCity, foreign_key: :county)
    field :description, :string
    field :name, :string
    field :status, :string
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(realestate, attrs) do
    realestate
    |> cast(attrs, [:name, :country, :county, :description, :status, :user_id])
    |> validate_required([:name, :country, :county, :description])
  end
end
