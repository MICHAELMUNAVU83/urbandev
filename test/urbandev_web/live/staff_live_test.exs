defmodule UrbandevWeb.StaffLiveTest do
  use UrbandevWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Urbandev.Staffs

  @create_attrs %{active: "some active", description: "some description", dob: ~D[2010-04-17], email: "some email", estate: 42, firstname: "some firstname", housenumber: "some housenumber", ifso: "some ifso", image: "some image", lastname: "some lastname", nationalid: "some nationalid", passcode: "some passcode", phone: "some phone", residence: "some residence", status: "some status", title: "some title"}
  @update_attrs %{active: "some updated active", description: "some updated description", dob: ~D[2011-05-18], email: "some updated email", estate: 43, firstname: "some updated firstname", housenumber: "some updated housenumber", ifso: "some updated ifso", image: "some updated image", lastname: "some updated lastname", nationalid: "some updated nationalid", passcode: "some updated passcode", phone: "some updated phone", residence: "some updated residence", status: "some updated status", title: "some updated title"}
  @invalid_attrs %{active: nil, description: nil, dob: nil, email: nil, estate: nil, firstname: nil, housenumber: nil, ifso: nil, image: nil, lastname: nil, nationalid: nil, passcode: nil, phone: nil, residence: nil, status: nil, title: nil}

  defp fixture(:staff) do
    {:ok, staff} = Staffs.create_staff(@create_attrs)
    staff
  end

  defp create_staff(_) do
    staff = fixture(:staff)
    %{staff: staff}
  end

  describe "Index" do
    setup [:create_staff]

    test "lists all staff", %{conn: conn, staff: staff} do
      {:ok, _index_live, html} = live(conn, Routes.staff_index_path(conn, :index))

      assert html =~ "Listing Staff"
      assert html =~ staff.active
    end

    test "saves new staff", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.staff_index_path(conn, :index))

      assert index_live |> element("a", "New Staff") |> render_click() =~
               "New Staff"

      assert_patch(index_live, Routes.staff_index_path(conn, :new))

      assert index_live
             |> form("#staff-form", staff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#staff-form", staff: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.staff_index_path(conn, :index))

      assert html =~ "Staff created successfully"
      assert html =~ "some active"
    end

    test "updates staff in listing", %{conn: conn, staff: staff} do
      {:ok, index_live, _html} = live(conn, Routes.staff_index_path(conn, :index))

      assert index_live |> element("#staff-#{staff.id} a", "Edit") |> render_click() =~
               "Edit Staff"

      assert_patch(index_live, Routes.staff_index_path(conn, :edit, staff))

      assert index_live
             |> form("#staff-form", staff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#staff-form", staff: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.staff_index_path(conn, :index))

      assert html =~ "Staff updated successfully"
      assert html =~ "some updated active"
    end

    test "deletes staff in listing", %{conn: conn, staff: staff} do
      {:ok, index_live, _html} = live(conn, Routes.staff_index_path(conn, :index))

      assert index_live |> element("#staff-#{staff.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#staff-#{staff.id}")
    end
  end

  describe "Show" do
    setup [:create_staff]

    test "displays staff", %{conn: conn, staff: staff} do
      {:ok, _show_live, html} = live(conn, Routes.staff_show_path(conn, :show, staff))

      assert html =~ "Show Staff"
      assert html =~ staff.active
    end

    test "updates staff within modal", %{conn: conn, staff: staff} do
      {:ok, show_live, _html} = live(conn, Routes.staff_show_path(conn, :show, staff))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Staff"

      assert_patch(show_live, Routes.staff_show_path(conn, :edit, staff))

      assert show_live
             |> form("#staff-form", staff: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#staff-form", staff: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.staff_show_path(conn, :show, staff))

      assert html =~ "Staff updated successfully"
      assert html =~ "some updated active"
    end
  end
end
