defmodule UrbandevWeb.UserLive.Index do
  use UrbandevWeb, :live_view
  alias Urbandev.Accounts.User
  alias Urbandev.Accounts
    alias Urbandev.Kcitys

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :users, list_user())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
    |> assign(:user_id, socket.assigns.current_user)
    |> assign(:list_city, Kcitys.list_cities())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
    |> assign(:user_id, socket.assigns.current_user)
      |> assign(:list_city, Kcitys.list_cities())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:user_collection, list_user())
     |> push_redirect(to: Routes.user_index_path(socket, :index))
    }

  end

  defp list_user do
    Accounts.list_user()
  end

end
