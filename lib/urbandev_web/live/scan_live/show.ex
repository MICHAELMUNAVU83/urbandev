defmodule UrbandevWeb.ScanLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Scans

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:scan, Scans.get_scan!(id))}
  end

  defp page_title(:show), do: "Show Scan"
  defp page_title(:edit), do: "Edit Scan"
end
