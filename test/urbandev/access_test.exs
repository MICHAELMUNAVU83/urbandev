defmodule Urbandev.AccessTest do
  use Urbandev.DataCase

  alias Urbandev.Access

  describe "acc" do
    alias Urbandev.Access.Acc

    import Urbandev.AccessFixtures

    @invalid_attrs %{description: nil, idnumber: nil, location: nil, name: nil, phone: nil}

    test "list_acc/0 returns all acc" do
      acc = acc_fixture()
      assert Access.list_acc() == [acc]
    end

    test "get_acc!/1 returns the acc with given id" do
      acc = acc_fixture()
      assert Access.get_acc!(acc.id) == acc
    end

    test "create_acc/1 with valid data creates a acc" do
      valid_attrs = %{description: "some description", idnumber: 42, location: 42, name: "some name", phone: 42}

      assert {:ok, %Acc{} = acc} = Access.create_acc(valid_attrs)
      assert acc.description == "some description"
      assert acc.idnumber == 42
      assert acc.location == 42
      assert acc.name == "some name"
      assert acc.phone == 42
    end

    test "create_acc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Access.create_acc(@invalid_attrs)
    end

    test "update_acc/2 with valid data updates the acc" do
      acc = acc_fixture()
      update_attrs = %{description: "some updated description", idnumber: 43, location: 43, name: "some updated name", phone: 43}

      assert {:ok, %Acc{} = acc} = Access.update_acc(acc, update_attrs)
      assert acc.description == "some updated description"
      assert acc.idnumber == 43
      assert acc.location == 43
      assert acc.name == "some updated name"
      assert acc.phone == 43
    end

    test "update_acc/2 with invalid data returns error changeset" do
      acc = acc_fixture()
      assert {:error, %Ecto.Changeset{}} = Access.update_acc(acc, @invalid_attrs)
      assert acc == Access.get_acc!(acc.id)
    end

    test "delete_acc/1 deletes the acc" do
      acc = acc_fixture()
      assert {:ok, %Acc{}} = Access.delete_acc(acc)
      assert_raise Ecto.NoResultsError, fn -> Access.get_acc!(acc.id) end
    end

    test "change_acc/1 returns a acc changeset" do
      acc = acc_fixture()
      assert %Ecto.Changeset{} = Access.change_acc(acc)
    end
  end
end
