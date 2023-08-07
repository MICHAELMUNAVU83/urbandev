defmodule UrbandevWeb.StaffLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Staffs
  alias Urbandev.Realestates

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:staff, Staffs.get_staff!(id))
     |> assign(:estate, Realestates.list_estate!())
   }
  end

  defp page_title(:show), do: "Show Staff"
  defp page_title(:edit), do: "Edit Staff"
end
