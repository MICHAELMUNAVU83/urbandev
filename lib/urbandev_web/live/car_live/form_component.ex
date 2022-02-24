defmodule UrbandevWeb.CarLive.FormComponent do
  use UrbandevWeb, :live_component
  alias Urbandev.Cars
  alias Urbandev.Cars.Car

  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg ), max_entries: 1)}

  end

  @impl true
  def update(%{car: car} = assigns, socket) do

    changeset = Cars.change_car(car)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"car" => car_params}, socket) do
    changeset =
      socket.assigns.car
      |> Cars.change_car(car_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end
  def handle_event("save", %{"car" => car_params}, socket) do

    save_car(socket, socket.assigns.action, car_params)
  end

  defp save_car(socket, :edit, car_params) do
    car = put_photo_url_edit(socket)|> Map.merge(car_params)
    case Cars.update_car(socket.assigns.car, car , &consume_photos(socket, &1)) do
      {:ok, _car} ->
        {:noreply,
         socket
         |> put_flash(:info, "Car updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_car(socket, :new, car_params) do
      car = put_photo_url(socket, %Car{})
    case  Cars.create_car(car, car_params|> Map.merge(%{"user_id" => socket.assigns.user.id}) , &consume_photos(socket, &1) ) do
      {:ok, _car} ->
        {:noreply,
         socket
         |> put_flash(:info, "Car created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


    defp put_photo_url(socket, %Car{} = car ) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %Car{car | image: "#{inspect url}"}
    end

    defp put_photo_url_edit(socket) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %{ "image" => "#{inspect url}"}
    end

    defp consume_photos(socket, %Car{} = car ) do
      consume_uploaded_entries(socket, :photo, fn meta, entry ->
         destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
         File.cp!(meta.path, destination)
      end)
      {:ok, car}
    end
    def ext(entry) do
      [ext | _] = MIME.extensions(entry.client_type)
      ext
    end
end
