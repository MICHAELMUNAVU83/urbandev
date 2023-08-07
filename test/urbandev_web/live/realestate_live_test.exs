defmodule UrbandevWeb.RealestateLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Urbandev.Realestates

  @create_attrs %{country: "some country", county: 42, description: "some description", name: "some name", status: "some status"}
  @update_attrs %{country: "some updated country", county: 43, description: "some updated description", name: "some updated name", status: "some updated status"}
  @invalid_attrs %{country: nil, county: nil, description: nil, name: nil, status: nil}

  defp fixture(:realestate) do
    {:ok, realestate} = Realestates.create_realestate(@create_attrs)
    realestate
  end

  defp create_realestate(_) do
    realestate = fixture(:realestate)
    %{realestate: realestate}
  end

  describe "Index" do
    setup [:create_realestate]

    test "lists all realestates", %{conn: conn, realestate: realestate} do
      {:ok, _index_live, html} = live(conn, Routes.realestate_index_path(conn, :index))

      assert html =~ "Listing Realestates"
      assert html =~ realestate.country
    end

    test "saves new realestate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.realestate_index_path(conn, :index))

      assert index_live |> element("a", "New Realestate") |> render_click() =~
               "New Realestate"

      assert_patch(index_live, Routes.realestate_index_path(conn, :new))

      assert index_live
             |> form("#realestate-form", realestate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#realestate-form", realestate: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.realestate_index_path(conn, :index))

      assert html =~ "Realestate created successfully"
      assert html =~ "some country"
    end

    test "updates realestate in listing", %{conn: conn, realestate: realestate} do
      {:ok, index_live, _html} = live(conn, Routes.realestate_index_path(conn, :index))

      assert index_live |> element("#realestate-#{realestate.id} a", "Edit") |> render_click() =~
               "Edit Realestate"

      assert_patch(index_live, Routes.realestate_index_path(conn, :edit, realestate))

      assert index_live
             |> form("#realestate-form", realestate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#realestate-form", realestate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.realestate_index_path(conn, :index))

      assert html =~ "Realestate updated successfully"
      assert html =~ "some updated country"
    end

    test "deletes realestate in listing", %{conn: conn, realestate: realestate} do
      {:ok, index_live, _html} = live(conn, Routes.realestate_index_path(conn, :index))

      assert index_live |> element("#realestate-#{realestate.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#realestate-#{realestate.id}")
    end
  end

  describe "Show" do
    setup [:create_realestate]

    test "displays realestate", %{conn: conn, realestate: realestate} do
      {:ok, _show_live, html} = live(conn, Routes.realestate_show_path(conn, :show, realestate))

      assert html =~ "Show Realestate"
      assert html =~ realestate.country
    end

    test "updates realestate within modal", %{conn: conn, realestate: realestate} do
      {:ok, show_live, _html} = live(conn, Routes.realestate_show_path(conn, :show, realestate))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Realestate"

      assert_patch(show_live, Routes.realestate_show_path(conn, :edit, realestate))

      assert show_live
             |> form("#realestate-form", realestate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#realestate-form", realestate: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.realestate_show_path(conn, :show, realestate))

      assert html =~ "Realestate updated successfully"
      assert html =~ "some updated country"
    end
  end
end
