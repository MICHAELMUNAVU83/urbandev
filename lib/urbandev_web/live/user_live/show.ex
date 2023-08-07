defmodule UrbandevWeb.UserLive.Show do
  use UrbandevWeb, :live_view

    alias Urbandev.Kcitys
  alias Urbandev.Accounts

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
     |> assign(:user, Accounts.get_users!(id))
     |> assign(:list_city, Kcitys.list_cities())
   }

  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
