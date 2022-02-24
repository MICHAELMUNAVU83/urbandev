defmodule Urbandev.Cars do
  @moduledoc """
  The Cars context.
  """

  import Ecto.Query, warn: false
  alias Urbandev.Repo

  alias Urbandev.Cars.Car

  @doc """
  Returns the list of cars.

  ## Examples

      iex> list_cars()
      [%Car{}, ...]

  """
  def list_cars do
     Repo.all(from q in Car, order_by: [desc: q.id])
  end


  def list_cars_user(user) do
    Repo.all(
      from(c in Car, where: c.user_id == ^user , preload: [:res])
    )
  end

  def list_cars_resident(user) do
    Repo.all(
      from(c in Car, where: c.resident == ^user , preload: [:res])
    )
  end
  @doc """
  Gets a single car.

  Raises `Ecto.NoResultsError` if the Car does not exist.

  ## Examples

      iex> get_car!(123)
      %Car{}

      iex> get_car!(456)
      ** (Ecto.NoResultsError)

  """
  def get_car!(id), do: Repo.get!(Car, id)

  def get_car_user!(id,user) do

    Repo.one(
      from(c in Car, where: c.id == ^id and c.user_id == ^user , preload: [:res] )
    )

  end

  def get_car_user_count(id) do

    Repo.one(
      from(c in Car, where: c.resident == ^id , select: count(c.id) )
    )

  end

  def get_car_count() do

    Repo.one(
      from(c in Car,  select: count(c.id) )
    )

  end
  @doc """
  Creates a car.

  ## Examples

      iex> create_car(%{field: value})
      {:ok, %Car{}}

      iex> create_car(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_car(%Car{} = car,attrs \\ %{}, after_save \\ &{:ok, &1}) do
    car
    |> Car.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a car.

  ## Examples

      iex> update_car(car, %{field: new_value})
      {:ok, %Car{}}

      iex> update_car(car, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_car(%Car{} = car, attrs, after_save \\ &{:ok, &1}) do
    car
    |> Car.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end



    defp after_save({:ok, post}, func) do
      {:ok, _post} = func.(post)
    end

    defp after_save(error, _func), do: error

  @doc """
  Deletes a Car.

  ## Examples

      iex> delete_car(car)
      {:ok, %Car{}}

      iex> delete_car(car)
      {:error, %Ecto.Changeset{}}

  """
  def delete_car(%Car{} = car) do
    Repo.delete(car)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking car changes.

  ## Examples

      iex> change_car(car)
      %Ecto.Changeset{source: %Car{}}

  """
  def change_car(%Car{} = car, attrs \\ %{}) do
    Car.changeset(car, attrs)
  end
end
