defmodule UrbandevWeb.RealestateLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Realestates
  alias Urbandev.Realestates.Realestate
  alias Urbandev.Kcitys

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :realestates, list_realestates_user(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Realestate")
    |> assign(:realestate, Realestates.get_realestate!(id))
    |> assign(:list_city,  Kcitys.list_cities() )

  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Realestate")
    |> assign(:realestate, %Realestate{})
    |> assign(:list_city,  Kcitys.list_cities() )
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Realestates")
    |> assign(:realestate, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    realestate = Realestates.get_realestate!(id)
    {:ok, _} = Realestates.delete_realestate(realestate)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:realestates, list_realestates_user(socket.assigns.current_user))
     |> push_redirect(to: Routes.realestate_index_path(socket, :index))
    }

  end

  # defp list_realestates do
  #   Realestates.list_realestates()
  # end
  defp list_realestates_user(user) do
  Realestates.list_realestates_user(user.id)
  end

end
