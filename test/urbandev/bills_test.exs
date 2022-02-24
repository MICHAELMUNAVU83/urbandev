defmodule Urbandev.BillsTest do
  use Urbandev.DataCase

  alias Urbandev.Bills

  describe "bills" do
    alias Urbandev.Bills.Bill

    @valid_attrs %{amount: 120.5, date_due: ~D[2010-04-17], description: "some description", file: "some file", paid: "some paid", penalty: 120.5, resident: "some resident", type: "some type"}
    @update_attrs %{amount: 456.7, date_due: ~D[2011-05-18], description: "some updated description", file: "some updated file", paid: "some updated paid", penalty: 456.7, resident: "some updated resident", type: "some updated type"}
    @invalid_attrs %{amount: nil, date_due: nil, description: nil, file: nil, paid: nil, penalty: nil, resident: nil, type: nil}

    def bill_fixture(attrs \\ %{}) do
      {:ok, bill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bills.create_bill()

      bill
    end

    test "list_bills/0 returns all bills" do
      bill = bill_fixture()
      assert Bills.list_bills() == [bill]
    end

    test "get_bill!/1 returns the bill with given id" do
      bill = bill_fixture()
      assert Bills.get_bill!(bill.id) == bill
    end

    test "create_bill/1 with valid data creates a bill" do
      assert {:ok, %Bill{} = bill} = Bills.create_bill(@valid_attrs)
      assert bill.amount == 120.5
      assert bill.date_due == ~D[2010-04-17]
      assert bill.description == "some description"
      assert bill.file == "some file"
      assert bill.paid == "some paid"
      assert bill.penalty == 120.5
      assert bill.resident == "some resident"
      assert bill.type == "some type"
    end

    test "create_bill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bills.create_bill(@invalid_attrs)
    end

    test "update_bill/2 with valid data updates the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{} = bill} = Bills.update_bill(bill, @update_attrs)
      assert bill.amount == 456.7
      assert bill.date_due == ~D[2011-05-18]
      assert bill.description == "some updated description"
      assert bill.file == "some updated file"
      assert bill.paid == "some updated paid"
      assert bill.penalty == 456.7
      assert bill.resident == "some updated resident"
      assert bill.type == "some updated type"
    end

    test "update_bill/2 with invalid data returns error changeset" do
      bill = bill_fixture()
      assert {:error, %Ecto.Changeset{}} = Bills.update_bill(bill, @invalid_attrs)
      assert bill == Bills.get_bill!(bill.id)
    end

    test "delete_bill/1 deletes the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{}} = Bills.delete_bill(bill)
      assert_raise Ecto.NoResultsError, fn -> Bills.get_bill!(bill.id) end
    end

    test "change_bill/1 returns a bill changeset" do
      bill = bill_fixture()
      assert %Ecto.Changeset{} = Bills.change_bill(bill)
    end
  end
end
