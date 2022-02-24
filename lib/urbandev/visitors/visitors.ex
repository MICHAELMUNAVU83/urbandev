defmodule Urbandev.Visitors do
  @moduledoc """
  The Visitors context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Visitors.Visitor

  @doc """
  Returns the list of visitor.

  ## Examples

      iex> list_visitor()
      [%Visitor{}, ...]

  """
  def list_visitor do
       Repo.all(from q in Visitor, order_by: [desc: q.id])
  end


    def list_visitors_user(user) do
      Repo.all(
        from(u in Visitor, where: u.user_id == ^user , preload: [:res])
      )
    end

  @doc """
  Gets a single visitor.

  Raises `Ecto.NoResultsError` if the Visitor does not exist.

  ## Examples

      iex> get_visitor!(123)
      %Visitor{}

      iex> get_visitor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_visitor!(id), do: Repo.get!(Visitor, id)

  def get_visitor_user!(id,user) do

    Repo.one(
      from(c in Visitor, where: c.id == ^id and c.user_id == ^user , preload: [:res] )
    )

  end

  @doc """
  Creates a visitor.

  ## Examples

      iex> create_visitor(%{field: value})
      {:ok, %Visitor{}}

      iex> create_visitor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_visitor(%Visitor{} = visitor,attrs \\ %{}, after_save \\ &{:ok, &1}) do
    visitor
    |> Visitor.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a visitor.

  ## Examples

      iex> update_visitor(visitor, %{field: new_value})
      {:ok, %Visitor{}}

      iex> update_visitor(visitor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_visitor(%Visitor{} = visitor, attrs, after_save \\ &{:ok, &1}) do
    visitor
    |> Visitor.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end



    defp after_save({:ok, post}, func) do
      {:ok, _post} = func.(post)
    end

    defp after_save(error, _func), do: error


  @doc """
  Deletes a Visitor.

  ## Examples

      iex> delete_visitor(visitor)
      {:ok, %Visitor{}}

      iex> delete_visitor(visitor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_visitor(%Visitor{} = visitor) do
    Repo.delete(visitor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking visitor changes.

  ## Examples

      iex> change_visitor(visitor)
      %Ecto.Changeset{source: %Visitor{}}

  """
  def change_visitor(%Visitor{} = visitor, attrs \\ %{}) do
    Visitor.changeset(visitor, attrs)
  end

  def get_visitor_count() do

    Repo.one(
      from(v in Visitor,  select: count(v .id) )
    )

  end
end
