defmodule Urbandev.Bills.Bill do
  use Ecto.Schema

  alias Urbandev.Accounts.User

  alias Urbandev.Residents.Resident
  import Ecto.Changeset

  schema "bills" do
    field :amount, :float
    field :date_due, :date
    field :description, :string
    field :file, :string
    field :paid, :string, default: 0.0
    field :penalty, :float
    belongs_to(:res, Resident, foreign_key: :resident)
    field :type, :string
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(bill, attrs) do
    bill
    |> cast(attrs, [:resident, :type, :date_due, :description, :amount, :paid, :penalty, :file, :user_id])
    |> validate_required([:resident, :type, :date_due, :amount,  :file])
  end
end
