defmodule UrbandevWeb.CarLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Cars
  alias Urbandev.Cars.Car
    alias Urbandev.Residents

  @impl true
  def mount(_params, session, socket) do

      socket = assign_defaults(session, socket)

    {:ok, assign(socket, :cars, list_cars_user(socket.assigns.current_user) )}
  end

  @impl true
  def handle_params(params, _url, socket) do

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Car")
    |> assign(:car, Cars.get_car!(id))
    |> assign(:residents, Residents.list_resident!())
  end

  defp apply_action(socket, :new, _params) do

    socket
    |> assign(:page_title, "New Car")
    |> assign(:car, %Car{})
    |> assign(:residents, Residents.list_resident!())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cars")
    |> assign(:car, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    car = Cars.get_car!(id)
    {:ok, _} = Cars.delete_car(car)

    {:noreply,
     socket
     |> put_flash(:error, "Item deleted successfully")
     |> assign(:cars, list_cars_user(socket.assigns.current_user))
     |> push_redirect(to: Routes.car_index_path(socket, :index))
    }
  end

  defp list_cars() do
    Cars.list_cars()
  end

  defp list_cars_user(user) do
    Cars.list_cars_user(user.id)
  end
end
