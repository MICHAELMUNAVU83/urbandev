defmodule UrbandevWeb.StaffLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Staffs
  alias Urbandev.Staffs.Staff
  alias Urbandev.Realestates

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :staff_collection, list_staff_user(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Staff")
    |> assign(:staff, Staffs.get_staff!(id))
    |> assign(:estate, Realestates.list_estate!())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Staff")
    |> assign(:staff, %Staff{})
    |> assign(:estate, Realestates.list_estate!())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Staff")
    |> assign(:staff, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    IO.inspect socket
    staff = Staffs.get_staff!(id)
    case Staffs.delete_staff(staff) do
      {:ok, _post} ->

      {:noreply,
       socket
       |> put_flash(:error, "Post deleted successfully")
       |> assign(:staff_collection, list_staff_user(socket.assigns.current_user))
      }
    {:error, %Ecto.Changeset{} = _changeset} ->
      {:noreply,
      socket
      |> assign(:staff_collection, list_staff_user(socket.assigns.current_user))}
    end

  end

  # defp list_staff do
  #   Staffs.list_staff()
  # end

  defp list_staff_user(user) do
   Staffs.list_staff_user(user.id)
 end

end
