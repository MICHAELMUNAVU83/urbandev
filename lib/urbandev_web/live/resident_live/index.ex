defmodule UrbandevWeb.ResidentLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Residents
  alias Urbandev.Residents.Resident
  alias Urbandev.Realestates
  alias Urbandev.Cars

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :residents, Residents.list_residents_user(socket.assigns.current_user) )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Resident")
    |> assign(:resident, Residents.get_resident!(id))
    |> assign(:estate , Realestates.list_estate!())

  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Resident")
    |> assign(:resident, %Resident{})
    |> assign(:estate , Realestates.list_estate!())

  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Residents")
    |> assign(:resident, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    resident = Residents.get_resident!(id)
    {:ok, _} = Residents.delete_resident(resident)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:residents, list_residents_user(socket.assigns.current_user))
     |> push_redirect(to: Routes.resident_index_path(socket, :index))
    }
  end

  # defp list_residents do
  #   Residents.list_residents()
  # end

  defp list_residents_user(user) do
    Residents.list_residents_user(user.id)
  end
end
