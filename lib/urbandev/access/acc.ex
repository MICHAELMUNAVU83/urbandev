defmodule Urbandev.Access.Acc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "acc" do
    field :code, :string
    field :description, :string
    field :idnumber, :integer
    field :location, :integer
    field :name, :string
    field :phone, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(acc, attrs) do
    acc
    |> cast(attrs, [:name, :code, :phone, :idnumber, :location, :description])
    |> validate_required([:name, :phone, :idnumber, :location, :description])
  end
end
