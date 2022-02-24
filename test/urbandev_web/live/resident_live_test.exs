defmodule UrbandevWeb.ResidentLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Urbandev.Residents

  @create_attrs %{active: "some active", description: "some description", email: "some email", estate: 42, firstname: "some firstname", housenumber: "some housenumber", idnumber: "some idnumber", ifso: "some ifso", image: "some image", lastname: "some lastname", occupation: "some occupation", paid: "some paid", phone: "some phone", scharge: "some scharge", serial: "some serial", status: "some status", water: "some water"}
  @update_attrs %{active: "some updated active", description: "some updated description", email: "some updated email", estate: 43, firstname: "some updated firstname", housenumber: "some updated housenumber", idnumber: "some updated idnumber", ifso: "some updated ifso", image: "some updated image", lastname: "some updated lastname", occupation: "some updated occupation", paid: "some updated paid", phone: "some updated phone", scharge: "some updated scharge", serial: "some updated serial", status: "some updated status", water: "some updated water"}
  @invalid_attrs %{active: nil, description: nil, email: nil, estate: nil, firstname: nil, housenumber: nil, idnumber: nil, ifso: nil, image: nil, lastname: nil, occupation: nil, paid: nil, phone: nil, scharge: nil, serial: nil, status: nil, water: nil}

  defp fixture(:resident) do
    {:ok, resident} = Residents.create_resident(@create_attrs)
    resident
  end

  defp create_resident(_) do
    resident = fixture(:resident)
    %{resident: resident}
  end

  describe "Index" do
    setup [:create_resident]

    test "lists all residents", %{conn: conn, resident: resident} do
      {:ok, _index_live, html} = live(conn, Routes.resident_index_path(conn, :index))

      assert html =~ "Listing Residents"
      assert html =~ resident.active
    end

    test "saves new resident", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.resident_index_path(conn, :index))

      assert index_live |> element("a", "New Resident") |> render_click() =~
               "New Resident"

      assert_patch(index_live, Routes.resident_index_path(conn, :new))

      assert index_live
             |> form("#resident-form", resident: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#resident-form", resident: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resident_index_path(conn, :index))

      assert html =~ "Resident created successfully"
      assert html =~ "some active"
    end

    test "updates resident in listing", %{conn: conn, resident: resident} do
      {:ok, index_live, _html} = live(conn, Routes.resident_index_path(conn, :index))

      assert index_live |> element("#resident-#{resident.id} a", "Edit") |> render_click() =~
               "Edit Resident"

      assert_patch(index_live, Routes.resident_index_path(conn, :edit, resident))

      assert index_live
             |> form("#resident-form", resident: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#resident-form", resident: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resident_index_path(conn, :index))

      assert html =~ "Resident updated successfully"
      assert html =~ "some updated active"
    end

    test "deletes resident in listing", %{conn: conn, resident: resident} do
      {:ok, index_live, _html} = live(conn, Routes.resident_index_path(conn, :index))

      assert index_live |> element("#resident-#{resident.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#resident-#{resident.id}")
    end
  end

  describe "Show" do
    setup [:create_resident]

    test "displays resident", %{conn: conn, resident: resident} do
      {:ok, _show_live, html} = live(conn, Routes.resident_show_path(conn, :show, resident))

      assert html =~ "Show Resident"
      assert html =~ resident.active
    end

    test "updates resident within modal", %{conn: conn, resident: resident} do
      {:ok, show_live, _html} = live(conn, Routes.resident_show_path(conn, :show, resident))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Resident"

      assert_patch(show_live, Routes.resident_show_path(conn, :edit, resident))

      assert show_live
             |> form("#resident-form", resident: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#resident-form", resident: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resident_show_path(conn, :show, resident))

      assert html =~ "Resident updated successfully"
      assert html =~ "some updated active"
    end
  end
end
