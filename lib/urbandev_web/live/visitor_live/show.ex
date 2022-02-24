defmodule UrbandevWeb.VisitorLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Visitors
    alias Urbandev.Residents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:visitor, Visitors.get_visitor!(id))
     |> assign(:residents, Residents.list_resident!())}
  end

  defp page_title(:show), do: "Show Visitor"
  defp page_title(:edit), do: "Edit Visitor"
end
