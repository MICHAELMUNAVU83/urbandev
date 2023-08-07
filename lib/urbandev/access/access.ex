defmodule Urbandev.Access do
  @moduledoc """
  The Access context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Access.Acc

  @topic "access"

  def subscribe do
    Phoenix.PubSub.subscribe(Urbandev.PubSub, @topic)
  end

  @doc """
  Returns the list of acc.

  ## Examples

      iex> list_acc()
      [%Acc{}, ...]

  """
  def list_acc do
    Repo.all(Acc)
  end

  def list_acc_user(user) do
    Repo.all(
      from(c in Acc, where: c.user_id == ^user , preload: [:res])
    )
  end

  @doc """
  Gets a single acc.

  Raises `Ecto.NoResultsError` if the Acc does not exist.

  ## Examples

      iex> get_acc!(123)
      %Acc{}

      iex> get_acc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_acc!(id), do: Repo.get!(Acc, id)

  @doc """
  Creates a acc.

  ## Examples

      iex> create_acc(%{field: value})
      {:ok, %Acc{}}

      iex> create_acc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_acc(attrs \\ %{}) do
    %Acc{}
    |> Acc.changeset(attrs)
    |> Repo.insert()
  end

  def create_access(attrs \\ %{}) do
    %Acc{}
    |> Acc.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:access_created)
  end

  @doc """
  Updates a acc.

  ## Examples

      iex> update_acc(acc, %{field: new_value})
      {:ok, %Acc{}}

      iex> update_acc(acc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_acc(%Acc{} = acc, attrs) do
    acc
    |> Acc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a acc.

  ## Examples

      iex> delete_acc(acc)
      {:ok, %Acc{}}

      iex> delete_acc(acc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_acc(%Acc{} = acc) do
    Repo.delete(acc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking acc changes.

  ## Examples

      iex> change_acc(acc)
      %Ecto.Changeset{data: %Acc{}}

  """
  def change_acc(%Acc{} = acc, attrs \\ %{}) do
    Acc.changeset(acc, attrs)
  end

  def broadcast({:ok, access}, event) do
    Phoenix.PubSub.broadcast(Urbandev.PubSub, @topic, {event, access})

    {:ok, access}
  end

  def broadcast({:error, _reason} = error, _event), do: error

end
