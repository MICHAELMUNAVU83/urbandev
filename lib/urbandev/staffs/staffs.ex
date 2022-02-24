defmodule Urbandev.Staffs do
  @moduledoc """
  The Staffs context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Staffs.Staff

  @doc """
  Returns the list of staff.

  ## Examples

      iex> list_staff()
      [%Staff{}, ...]

  """
  def list_staff do
   Repo.all(from q in Staff, order_by: [desc: q.id])
  end


      def list_staff_user(user) do
        Repo.all(
          from(u in Staff, where: u.user_id == ^user , preload: [:esto])
        )
      end

      def list_staff!() do
        Repo.all(from(r in Staff,  select: {fragment("concat(?, ' ', '(', ? ,')' )", r.firstname, r.lastname), r.id}))
      end

  @doc """
  Gets a single staff.

  Raises `Ecto.NoResultsError` if the Staff does not exist.

  ## Examples

      iex> get_staff!(123)
      %Staff{}

      iex> get_staff!(456)
      ** (Ecto.NoResultsError)

  """
  def get_staff!(id), do: Repo.get!(Staff, id)

  def get_staff_user!(id,user) do

    Repo.one(
      from(c in Staff, where: c.id == ^id and c.user_id == ^user , preload: [:esto] )
    )

  end

  def get_staff_user_pass!(user,pass) do

    Repo.one(
      from(c in Staff, where: c.phone == ^user and c.passcode == ^pass , preload: [:esto] )
    )

  end

  def get_staff_user_records!(user) do

    Repo.one(
      from(c in Staff, where: c.id == ^user , preload: [:esto] )
    )

  end

  @doc """
  Creates a staff.

  ## Examples

      iex> create_staff(%{field: value})
      {:ok, %Staff{}}

      iex> create_staff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_staff(%Staff{} = staff,attrs \\ %{}, after_save \\ &{:ok, &1}) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a staff.

  ## Examples

      iex> update_staff(staff, %{field: new_value})
      {:ok, %Staff{}}

      iex> update_staff(staff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_staff(%Staff{} = staff, attrs,after_save \\ &{:ok, &1}) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end


  defp after_save({:ok, post}, func) do
    {:ok, _post} = func.(post)
  end

  defp after_save(error, _func), do: error

  @doc """
  Deletes a Staff.

  ## Examples

      iex> delete_staff(staff)
      {:ok, %Staff{}}

      iex> delete_staff(staff)
      {:error, %Ecto.Changeset{}}

  """
  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking staff changes.

  ## Examples

      iex> change_staff(staff)
      %Ecto.Changeset{source: %Staff{}}

  """
  def change_staff(%Staff{} = staff, attrs \\ %{}) do
    Staff.changeset(staff, attrs)
  end
end
