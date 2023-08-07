defmodule UrbandevWeb.RealestateLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Realestates
    alias Urbandev.Kcitys

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:realestate, Realestates.get_realestate!(id))
     |> assign(:list_city,  Kcitys.list_cities() )
   }
  end

  defp page_title(:show), do: "Show Realestate"
  defp page_title(:edit), do: "Edit Realestate"
end
