defmodule UrbandevWeb.AccLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest
  import Urbandev.AccessFixtures

  @create_attrs %{description: "some description", idnumber: 42, location: 42, name: "some name", phone: 42}
  @update_attrs %{description: "some updated description", idnumber: 43, location: 43, name: "some updated name", phone: 43}
  @invalid_attrs %{description: nil, idnumber: nil, location: nil, name: nil, phone: nil}

  defp create_acc(_) do
    acc = acc_fixture()
    %{acc: acc}
  end

  describe "Index" do
    setup [:create_acc]

    test "lists all acc", %{conn: conn, acc: acc} do
      {:ok, _index_live, html} = live(conn, Routes.acc_index_path(conn, :index))

      assert html =~ "Listing Acc"
      assert html =~ acc.description
    end

    test "saves new acc", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.acc_index_path(conn, :index))

      assert index_live |> element("a", "New Acc") |> render_click() =~
               "New Acc"

      assert_patch(index_live, Routes.acc_index_path(conn, :new))

      assert index_live
             |> form("#acc-form", acc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#acc-form", acc: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acc_index_path(conn, :index))

      assert html =~ "Acc created successfully"
      assert html =~ "some description"
    end

    test "updates acc in listing", %{conn: conn, acc: acc} do
      {:ok, index_live, _html} = live(conn, Routes.acc_index_path(conn, :index))

      assert index_live |> element("#acc-#{acc.id} a", "Edit") |> render_click() =~
               "Edit Acc"

      assert_patch(index_live, Routes.acc_index_path(conn, :edit, acc))

      assert index_live
             |> form("#acc-form", acc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#acc-form", acc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acc_index_path(conn, :index))

      assert html =~ "Acc updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes acc in listing", %{conn: conn, acc: acc} do
      {:ok, index_live, _html} = live(conn, Routes.acc_index_path(conn, :index))

      assert index_live |> element("#acc-#{acc.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#acc-#{acc.id}")
    end
  end

  describe "Show" do
    setup [:create_acc]

    test "displays acc", %{conn: conn, acc: acc} do
      {:ok, _show_live, html} = live(conn, Routes.acc_show_path(conn, :show, acc))

      assert html =~ "Show Acc"
      assert html =~ acc.description
    end

    test "updates acc within modal", %{conn: conn, acc: acc} do
      {:ok, show_live, _html} = live(conn, Routes.acc_show_path(conn, :show, acc))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Acc"

      assert_patch(show_live, Routes.acc_show_path(conn, :edit, acc))

      assert show_live
             |> form("#acc-form", acc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#acc-form", acc: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acc_show_path(conn, :show, acc))

      assert html =~ "Acc updated successfully"
      assert html =~ "some updated description"
    end
  end
end
