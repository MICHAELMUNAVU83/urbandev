defmodule Urbandev.Residents.Resident do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Realestates.Realestate
  alias Urbandev.Cars.Car
  alias Urbandev.Accounts.User


  schema "residents" do
    field :active, :string
    belongs_to(:car, Car, foreign_key: :cars)
    field :description, :string
    field :email, :string
    field :firstname, :string
    belongs_to(:esto, Realestate, foreign_key: :estate)
    field :housenumber, :string
    field :ifso, :string
    field(:image, :string)
    field :lastname, :string
    field :paid, :string
    field :phone, :string
    field :occupation, :string
    field :idnumber, :string
    field :serial, :string
    field :servicecharge, :string
    field :status, :string
    field :water, :string
      belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(resident, attrs) do
    resident
    |> cast(attrs, [:firstname, :lastname, :email, :phone, :housenumber, :estate, :status, :ifso, :cars, :description, :paid, :occupation, :idnumber, :water, :servicecharge, :serial, :image, :active, :user_id])
    |> validate_required([:firstname, :lastname, :email, :phone, :housenumber, :estate, :status,  :serial])
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> unique_constraint(:housenumber)
    |> unique_constraint(:serial)
  end
end
