defmodule UrbandevWeb.VisitorLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Urbandev.Visitors

  @create_attrs %{active: "some active", description: "some description", image: "some image", names: "some names", nationalid: "some nationalid", phone: "some phone", serial: "some serial", time: "some time", type: "some type", visiting: 42}
  @update_attrs %{active: "some updated active", description: "some updated description", image: "some updated image", names: "some updated names", nationalid: "some updated nationalid", phone: "some updated phone", serial: "some updated serial", time: "some updated time", type: "some updated type", visiting: 43}
  @invalid_attrs %{active: nil, description: nil, image: nil, names: nil, nationalid: nil, phone: nil, serial: nil, time: nil, type: nil, visiting: nil}

  defp fixture(:visitor) do
    {:ok, visitor} = Visitors.create_visitor(@create_attrs)
    visitor
  end

  defp create_visitor(_) do
    visitor = fixture(:visitor)
    %{visitor: visitor}
  end

  describe "Index" do
    setup [:create_visitor]

    test "lists all visitor", %{conn: conn, visitor: visitor} do
      {:ok, _index_live, html} = live(conn, Routes.visitor_index_path(conn, :index))

      assert html =~ "Listing Visitor"
      assert html =~ visitor.active
    end

    test "saves new visitor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.visitor_index_path(conn, :index))

      assert index_live |> element("a", "New Visitor") |> render_click() =~
               "New Visitor"

      assert_patch(index_live, Routes.visitor_index_path(conn, :new))

      assert index_live
             |> form("#visitor-form", visitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#visitor-form", visitor: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.visitor_index_path(conn, :index))

      assert html =~ "Visitor created successfully"
      assert html =~ "some active"
    end

    test "updates visitor in listing", %{conn: conn, visitor: visitor} do
      {:ok, index_live, _html} = live(conn, Routes.visitor_index_path(conn, :index))

      assert index_live |> element("#visitor-#{visitor.id} a", "Edit") |> render_click() =~
               "Edit Visitor"

      assert_patch(index_live, Routes.visitor_index_path(conn, :edit, visitor))

      assert index_live
             |> form("#visitor-form", visitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#visitor-form", visitor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.visitor_index_path(conn, :index))

      assert html =~ "Visitor updated successfully"
      assert html =~ "some updated active"
    end

    test "deletes visitor in listing", %{conn: conn, visitor: visitor} do
      {:ok, index_live, _html} = live(conn, Routes.visitor_index_path(conn, :index))

      assert index_live |> element("#visitor-#{visitor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#visitor-#{visitor.id}")
    end
  end

  describe "Show" do
    setup [:create_visitor]

    test "displays visitor", %{conn: conn, visitor: visitor} do
      {:ok, _show_live, html} = live(conn, Routes.visitor_show_path(conn, :show, visitor))

      assert html =~ "Show Visitor"
      assert html =~ visitor.active
    end

    test "updates visitor within modal", %{conn: conn, visitor: visitor} do
      {:ok, show_live, _html} = live(conn, Routes.visitor_show_path(conn, :show, visitor))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Visitor"

      assert_patch(show_live, Routes.visitor_show_path(conn, :edit, visitor))

      assert show_live
             |> form("#visitor-form", visitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#visitor-form", visitor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.visitor_show_path(conn, :show, visitor))

      assert html =~ "Visitor updated successfully"
      assert html =~ "some updated active"
    end
  end
end
