defmodule Urbandev.AccessFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Urbandev.Access` context.
  """

  @doc """
  Generate a acc.
  """
  def acc_fixture(attrs \\ %{}) do
    {:ok, acc} =
      attrs
      |> Enum.into(%{
        description: "some description",
        idnumber: 42,
        location: 42,
        name: "some name",
        phone: 42
      })
      |> Urbandev.Access.create_acc()

    acc
  end
end
