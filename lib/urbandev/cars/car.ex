defmodule Urbandev.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User
  alias Urbandev.Residents.Resident
  use Arc.Ecto.Schema


  schema "cars" do
    field :description, :string
    field :regno, :string
    belongs_to(:res, Resident, foreign_key: :resident)
    field :type, :string
    field :active, :string
    field :serial, :string
    field(:image, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car

    |> cast(attrs, [:regno, :resident, :type, :description, :serial,:image, :active, :user_id])
    |> validate_required([:regno, :resident, :type])
  end
end
