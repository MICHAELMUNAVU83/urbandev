defmodule UrbandevWeb.BillLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Urbandev.Bills

  @create_attrs %{amount: 120.5, date_due: ~D[2010-04-17], description: "some description", file: "some file", paid: "some paid", penalty: 120.5, resident: "some resident", type: "some type"}
  @update_attrs %{amount: 456.7, date_due: ~D[2011-05-18], description: "some updated description", file: "some updated file", paid: "some updated paid", penalty: 456.7, resident: "some updated resident", type: "some updated type"}
  @invalid_attrs %{amount: nil, date_due: nil, description: nil, file: nil, paid: nil, penalty: nil, resident: nil, type: nil}

  defp fixture(:bill) do
    {:ok, bill} = Bills.create_bill(@create_attrs)
    bill
  end

  defp create_bill(_) do
    bill = fixture(:bill)
    %{bill: bill}
  end

  describe "Index" do
    setup [:create_bill]

    test "lists all bills", %{conn: conn, bill: bill} do
      {:ok, _index_live, html} = live(conn, Routes.bill_index_path(conn, :index))

      assert html =~ "Listing Bills"
      assert html =~ bill.description
    end

    test "saves new bill", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.bill_index_path(conn, :index))

      assert index_live |> element("a", "New Bill") |> render_click() =~
               "New Bill"

      assert_patch(index_live, Routes.bill_index_path(conn, :new))

      assert index_live
             |> form("#bill-form", bill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bill-form", bill: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bill_index_path(conn, :index))

      assert html =~ "Bill created successfully"
      assert html =~ "some description"
    end

    test "updates bill in listing", %{conn: conn, bill: bill} do
      {:ok, index_live, _html} = live(conn, Routes.bill_index_path(conn, :index))

      assert index_live |> element("#bill-#{bill.id} a", "Edit") |> render_click() =~
               "Edit Bill"

      assert_patch(index_live, Routes.bill_index_path(conn, :edit, bill))

      assert index_live
             |> form("#bill-form", bill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#bill-form", bill: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bill_index_path(conn, :index))

      assert html =~ "Bill updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes bill in listing", %{conn: conn, bill: bill} do
      {:ok, index_live, _html} = live(conn, Routes.bill_index_path(conn, :index))

      assert index_live |> element("#bill-#{bill.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bill-#{bill.id}")
    end
  end

  describe "Show" do
    setup [:create_bill]

    test "displays bill", %{conn: conn, bill: bill} do
      {:ok, _show_live, html} = live(conn, Routes.bill_show_path(conn, :show, bill))

      assert html =~ "Show Bill"
      assert html =~ bill.description
    end

    test "updates bill within modal", %{conn: conn, bill: bill} do
      {:ok, show_live, _html} = live(conn, Routes.bill_show_path(conn, :show, bill))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bill"

      assert_patch(show_live, Routes.bill_show_path(conn, :edit, bill))

      assert show_live
             |> form("#bill-form", bill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#bill-form", bill: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.bill_show_path(conn, :show, bill))

      assert html =~ "Bill updated successfully"
      assert html =~ "some updated description"
    end
  end
end
