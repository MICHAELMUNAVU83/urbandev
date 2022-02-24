defmodule UrbandevWeb.ResidentLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Residents
  alias Urbandev.Realestates
  alias Urbandev.Cars

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:resident, Residents.get_resident!(id))
     |> assign(:estate , Realestates.list_estate!())
     |> assign(:cars, Cars.list_cars_resident(id))
     |> assign(:count, Cars.get_car_user_count(id))
   }
  end

  defp page_title(:show), do: "Show Resident"
  defp page_title(:edit), do: "Edit Resident"
end
