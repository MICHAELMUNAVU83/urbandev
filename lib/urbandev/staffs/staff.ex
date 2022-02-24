defmodule Urbandev.Staffs.Staff do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Realestates.Realestate
  alias Urbandev.Accounts.User


  schema "staff" do
    field :active, :string
    field :description, :string
    field :dob, :date
    field :email, :string
    belongs_to(:esto, Realestate, foreign_key: :estate)
    field :firstname, :string
    field(:image, :string)
    field :lastname, :string
    field :nationalid, :string
    field :phone, :string
    field :passcode, :string
    field :residence, :string
    field :serial, :string
    field :title, :string
      belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [:firstname, :lastname, :email, :phone, :nationalid, :dob, :title, :passcode,:serial, :estate, :residence, :description, :image, :active, :user_id])
    |> validate_required([:firstname, :lastname, :email, :phone, :nationalid, :dob, :title, :estate])
    |> unique_constraint(:phone)
    |> unique_constraint(:serial)
  end
end
