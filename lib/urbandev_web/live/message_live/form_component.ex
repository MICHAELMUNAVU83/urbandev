defmodule UrbandevWeb.MessageLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Messages
    alias Urbandev.Rest

  @impl true
  def update(%{message: message} = assigns, socket) do
    changeset = Messages.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    save_message(socket, socket.assigns.action, message_params)
  end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_message(socket, :new, message_params) do

    {:ok, _second, %HTTPotion.Response{status_code: status_code, body: body, headers: headers}} = Rest.webtopic( message_params["receiver"],message_params["title"],message_params["message"])

    IO.inspect(body)
    IO.inspect(headers.hdrs)
    IO.inspect(status_code)

    if status_code == 200 do
        case Messages.create_message(message_params |> Map.merge(%{"user_id" => socket.assigns.user.id})) do
          {:ok, _message} ->
            {:noreply,
             socket
             |> put_flash(:info, "Message created successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, changeset: changeset)}
        end
      else
        {:noreply,
         socket
         |> put_flash(:error, "Push notification failed try again later")
         |> push_redirect(to: socket.assigns.return_to)}


      end
  end
end
