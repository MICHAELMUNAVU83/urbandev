defmodule UrbandevWeb.AccLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Access

  @impl true
  def update(%{acc: acc} = assigns, socket) do
    changeset = Access.change_acc(acc)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"acc" => acc_params}, socket) do
    changeset =
      socket.assigns.acc
      |> Access.change_acc(acc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"acc" => acc_params}, socket) do
    save_acc(socket, socket.assigns.action, acc_params)
  end

  defp save_acc(socket, :edit, acc_params) do
    case Access.update_acc(socket.assigns.acc, acc_params) do
      {:ok, _acc} ->
        {:noreply,
         socket
         |> put_flash(:info, "Acc updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_acc(socket, :new, acc_params) do
    case Access.create_acc(acc_params) do
      {:ok, _acc} ->
        {:noreply,
         socket
         |> put_flash(:info, "Acc created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
