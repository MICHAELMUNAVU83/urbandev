defmodule Urbandev.Realestates do
  @moduledoc """
  The Realestates context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Realestates.Realestate

  @doc """
  Returns the list of realestates.

  ## Examples

      iex> list_realestates()
      [%Realestate{}, ...]

  """
  def list_realestates do
   Repo.all(from q in Realestate, order_by: [desc: q.id])
  end

  def list_realestates_user(user) do
    Repo.all(
      from(u in Realestate, where: u.user_id == ^user, preload: [:city] )
    )
  end

  def list_estate!() do
    Repo.all(from(e in Realestate,  select: {fragment("concat(?, '(', ? , ')')", e.name, e.country), e.id}))
  end

  @doc """
  Gets a single realestate.

  Raises `Ecto.NoResultsError` if the Realestate does not exist.

  ## Examples

      iex> get_realestate!(123)
      %Realestate{}

      iex> get_realestate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_realestate!(id), do: Repo.get!(Realestate, id)

  def get_realestate_user!(id,user) do

    Repo.one(
      from(c in Realestate, where: c.id == ^id and c.user_id == ^user , preload: [:city]  )
    )

  end

  @doc """
  Creates a realestate.

  ## Examples

      iex> create_realestate(%{field: value})
      {:ok, %Realestate{}}

      iex> create_realestate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_realestate(attrs \\ %{}) do
    %Realestate{}
    |> Realestate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a realestate.

  ## Examples

      iex> update_realestate(realestate, %{field: new_value})
      {:ok, %Realestate{}}

      iex> update_realestate(realestate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_realestate(%Realestate{} = realestate, attrs) do
    realestate
    |> Realestate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Realestate.

  ## Examples

      iex> delete_realestate(realestate)
      {:ok, %Realestate{}}

      iex> delete_realestate(realestate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_realestate(%Realestate{} = realestate) do
    Repo.delete(realestate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking realestate changes.

  ## Examples

      iex> change_realestate(realestate)
      %Ecto.Changeset{source: %Realestate{}}

  """
  def change_realestate(%Realestate{} = realestate, attrs \\ %{}) do
    Realestate.changeset(realestate, attrs)
  end

  def get_realestate_count() do

    Repo.one(
      from(r in Realestate,  select: count(r.id) )
    )

  end
end
