defmodule Urbandev.Visitors.Visitor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User
  alias Urbandev.Residents.Resident

  schema "visitor" do
    field :active, :string
    field(:image, :string)
    field :names, :string
    field :nationalid, :string
    field :phone, :string
    field :serial, :string
    field :time, :string
    field :type, :string
    field :description, :string
    belongs_to(:res, Resident, foreign_key: :visiting)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(visitor, attrs) do
    visitor
    |> cast(attrs, [:names, :phone, :nationalid, :visiting, :description ,:time, :type, :serial, :image, :active, :user_id])
    |> validate_required([:names, :phone, :nationalid, :visiting, :time, :serial, :active])
    |> unique_constraint(:phone)
    |> unique_constraint(:serial)
  end
end
