defmodule Urbandev.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Urbandev.Accounts.User


  schema "messages" do
    field :active, :string
    field :message, :string
    field :receiver, :string
    field :serial, :string
    field :title, :string
      belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:serial, :receiver, :title,:message, :active, :user_id])
    |> validate_required([:serial, :receiver, :title,:message])
  end
end
