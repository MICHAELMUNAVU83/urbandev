defmodule UrbandevWeb.VisitorLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Visitors
  alias Urbandev.Visitors.Visitor
  alias Urbandev.Residents

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
      visitor =
        if socket.assigns.current_user.role == "user" do
          list_visitor_user(socket.assigns.current_user)
        else
          list_visitor()
        end
    {:ok, assign(socket, :visitor_collection, visitor)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Visitor")
    |> assign(:visitor, Visitors.get_visitor!(id))
    |> assign(:residents, Residents.list_resident!())
      |> assign(:user_id, socket.assigns.current_user)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Visitor")
    |> assign(:visitor, %Visitor{})
    |> assign(:residents, Residents.list_resident!())
    |> assign(:user_id, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Visitor")
    |> assign(:visitor, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    visitor = Visitors.get_visitor!(id)
    {:ok, _} = Visitors.delete_visitor(visitor)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:visitor_collection, list_visitor())
     |> push_redirect(to: Routes.visitor_index_path(socket, :index))
    }

  end

  defp list_visitor do
    Visitors.list_visitor()
  end

  defp list_visitor_user(user) do
    Visitors.list_visitors_user(user.id)
  end
end
