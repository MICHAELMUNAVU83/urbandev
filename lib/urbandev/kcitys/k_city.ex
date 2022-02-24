defmodule Urbandev.Kcitys.KCity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User

  schema "kcity" do
    field(:active, :string)
    field(:city, :string)
    field(:county, :string)
    field(:population, :string)
    field(:status, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(k_city, attrs) do
    k_city
    |> cast(attrs, [:city, :status, :population, :county, :active])
    |> validate_required([:city, :status, :population, :county, :active])
  end
end
