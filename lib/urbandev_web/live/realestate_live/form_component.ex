defmodule UrbandevWeb.RealestateLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Realestates

  @impl true
  def update(%{realestate: realestate} = assigns, socket) do
    changeset = Realestates.change_realestate(realestate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"realestate" => realestate_params}, socket) do
    changeset =
      socket.assigns.realestate
      |> Realestates.change_realestate(realestate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"realestate" => realestate_params}, socket) do
    save_realestate(socket, socket.assigns.action, realestate_params)
  end

  defp save_realestate(socket, :edit, realestate_params) do
    case Realestates.update_realestate(socket.assigns.realestate, realestate_params) do
      {:ok, _realestate} ->
        {:noreply,
         socket
         |> put_flash(:info, "Realestate updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_realestate(socket, :new, realestate_params) do

    case  Realestates.create_realestate(realestate_params |> Map.merge(%{"user_id" => socket.assigns.user.id}) ) do
      {:ok, _realestate} ->
        {:noreply,
         socket
         |> put_flash(:info, "Realestate created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
