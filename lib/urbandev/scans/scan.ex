defmodule Urbandev.Scans.Scan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User


  schema "scans" do
    field :serial1, :string
    field :serial2, :string
    field :type, :string
    field :usertype, :string
      belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(scan, attrs) do
    scan
    |> cast(attrs, [:serial1, :serial2, :usertype, :type, :user_id])
    |> validate_required([:serial1, :usertype, :type])
  end
end
