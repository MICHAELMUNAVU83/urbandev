defmodule Urbandev.Residents do
  @moduledoc """
  The Residents context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Residents.Resident

  @doc """
  Returns the list of residents.

  ## Examples

      iex> list_residents()
      [%Resident{}, ...]

  """
  def list_residents do
     Repo.all(from q in Resident, order_by: [desc: q.id])

  end

  def list_residents_user(user) do
    Repo.all(
      from(r in Resident, where: r.user_id == ^user.id , preload: [:esto]) )
  end

  def list_resident!() do
    Repo.all(from(r in Resident,  select: {fragment("concat(?, ' ', ?,'(', ? ,')' )", r.firstname, r.lastname,  r.housenumber), r.id}))
  end
  @doc """
  Gets a single resident.

  Raises `Ecto.NoResultsError` if the Resident does not exist.

  ## Examples

      iex> get_resident!(123)
      %Resident{}

      iex> get_resident!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resident!(id), do: Repo.get!(Resident, id)

  def get_resident_user!(id,user) do

    Repo.one(
      from(r in Resident, where: r.id == ^id and r.user_id == ^user  )
    )

  end

  @doc """
  Creates a resident.

  ## Examples

      iex> create_resident(%{field: value})
      {:ok, %Resident{}}

      iex> create_resident(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """


  def create_resident(%Resident{} = resident,attrs \\ %{}, after_save \\ &{:ok, &1}) do
    resident
    |> Resident.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a resident.

  ## Examples

      iex> update_resident(resident, %{field: new_value})
      {:ok, %Resident{}}

      iex> update_resident(resident, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resident(%Resident{} = resident, attrs, after_save \\ &{:ok, &1}) do
    resident
    |> Resident.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end


  defp after_save({:ok, post}, func) do
    {:ok, _post} = func.(post)
  end

  defp after_save(error, _func), do: error

  @doc """
  Deletes a Resident.

  ## Examples

      iex> delete_resident(resident)
      {:ok, %Resident{}}

      iex> delete_resident(resident)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resident(%Resident{} = resident) do
    Repo.delete(resident)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resident changes.

  ## Examples

      iex> change_resident(resident)
      %Ecto.Changeset{source: %Resident{}}

  """
  def change_resident(%Resident{} = resident, attrs \\ %{}) do
    Resident.changeset(resident, attrs)
  end

  def get_resident_count() do

    Repo.one(
      from(r in Resident,  select: count(r.id) )
    )

  end
end
