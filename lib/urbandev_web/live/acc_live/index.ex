defmodule UrbandevWeb.AccLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Access
  alias Urbandev.Access.Acc

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    IO.inspect socket.assigns.current_user.role
    acc_collection =
      if socket.assigns.current_user.role == "user" do
        Access.list_acc_user(socket.assigns.current_user)
      else
        list_acc()
      end
    {:ok, assign(socket, :acc_collection, list_acc())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Acc")
    |> assign(:acc, Access.get_acc!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Acc")
    |> assign(:acc, %Acc{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Acc")
    |> assign(:acc, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    acc = Access.get_acc!(id)
    {:ok, _} = Access.delete_acc(acc)

    {:noreply, assign(socket, :acc_collection, list_acc())}
  end

  defp list_acc do
    Access.list_acc()
  end
end
