defmodule UrbandevWeb.MessageLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Messages
  alias Urbandev.Messages.Message

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
    {:ok, assign(socket, :messages, list_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply,
     socket
     |> put_flash(:error, "Post deleted successfully")
     |> assign(:messages, list_messages())
     |> push_redirect(to: Routes.message_index_path(socket, :index))
    }
  end

  defp list_messages do
    Messages.list_messages()
  end
end
