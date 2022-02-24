defmodule UrbandevWeb.ResidentLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Residents
  alias Urbandev.Residents.Resident

  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg ), max_entries: 1)}

  end

  @impl true
  def update(%{resident: resident} = assigns, socket) do
    changeset = Residents.change_resident(resident)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"resident" => resident_params}, socket) do
    changeset =
      socket.assigns.resident
      |> Residents.change_resident(resident_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end
  def handle_event("save", %{"resident" => resident_params}, socket) do
    save_resident(socket, socket.assigns.action, resident_params)
  end

  defp save_resident(socket, :edit, resident_params) do
      resident = put_photo_url_edit(socket)|> Map.merge(resident_params)
    case Residents.update_resident(socket.assigns.resident, resident, &consume_photos(socket, &1)) do
      {:ok, _resident} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resident updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_resident(socket, :new, resident_params) do
      resident = put_photo_url(socket, %Resident{})
    get_datetimestamp =
   Timex.local()
     |> Timex.format!("{YYYY}{0M}{0D}{h24}")

    case Residents.create_resident(resident, resident_params |> Map.merge(%{"user_id" => socket.assigns.user.id, "serial" => get_datetimestamp<>String.upcase(SecureRandom.hex(3))}) , &consume_photos(socket, &1)) do
      {:ok, _resident} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resident created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


    defp put_photo_url(socket, %Resident{} = resident ) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %Resident{resident | image: "#{inspect url}"}
    end

    defp put_photo_url_edit(socket) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %{ "image" => "#{inspect url}"}
    end

    defp consume_photos(socket, %Resident{} = resident ) do
      consume_uploaded_entries(socket, :photo, fn meta, entry ->
         destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
         File.cp!(meta.path, destination)
      end)
      {:ok, resident}
    end
    def ext(entry) do
      [ext | _] = MIME.extensions(entry.client_type)
      ext
    end
end
