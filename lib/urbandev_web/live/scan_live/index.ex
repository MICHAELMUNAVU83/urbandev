defmodule UrbandevWeb.ScanLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Scans
  alias Urbandev.Scans.Scan

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :scans, list_scans())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Scan")
    |> assign(:scan, Scans.get_scan!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scan")
    |> assign(:scan, %Scan{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scans")
    |> assign(:scan, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scan = Scans.get_scan!(id)
    {:ok, _} = Scans.delete_scan(scan)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:scans, list_scans())
     |> push_redirect(to: Routes.scan_index_path(socket, :index))
    }
  end

  defp list_scans do
    Scans.list_scans()
  end
end
