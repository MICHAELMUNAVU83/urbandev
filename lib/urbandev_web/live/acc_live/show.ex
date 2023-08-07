defmodule UrbandevWeb.AccLive.Show do
  use UrbandevWeb, :live_view

  alias Urbandev.Access

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
     |> assign(:acc, Access.get_acc!(id))}
  end

  defp page_title(:show), do: "Show Acc"
  defp page_title(:edit), do: "Edit Acc"
end
