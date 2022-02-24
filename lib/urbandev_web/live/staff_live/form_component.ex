defmodule UrbandevWeb.StaffLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Staffs
  alias Urbandev.Staffs.Staff


  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg ), max_entries: 1)}

  end

  @impl true
  def update(%{staff: staff} = assigns, socket) do

    changeset = Staffs.change_staff(staff)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"staff" => staff_params}, socket) do
    changeset =
      socket.assigns.staff
      |> Staffs.change_staff(staff_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end


    def handle_event("cancel-entry", %{"ref" => ref}, socket) do
      {:noreply, cancel_upload(socket, :photo, ref)}
    end

  def handle_event("save", %{"staff" => staff_params}, socket) do
    save_staff(socket, socket.assigns.action, staff_params)
  end

  defp save_staff(socket, :edit, staff_params) do
    staff = put_photo_url_edit(socket)|> Map.merge(staff_params)

    case Staffs.update_staff(socket.assigns.staff, staff, &consume_photos(socket, &1)) do
      {:ok, _staff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Staff updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_staff(socket, :new, staff_params) do
    staff = put_photo_url(socket, %Staff{})

    case Staffs.create_staff(staff, staff_params |> Map.merge(%{"user_id" => socket.assigns.user.id}) , &consume_photos(socket, &1)) do
      {:ok, _staff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Staff created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_photo_url(socket, %Staff{} = staff ) do
     {completed, []} = uploaded_entries(socket, :photo)
     url =
       for entry <- completed do
         Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
       end

        %Staff{staff | image: "#{inspect url}"}
  end

  defp put_photo_url_edit(socket) do
     {completed, []} = uploaded_entries(socket, :photo)
     url =
       for entry <- completed do
         Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
       end

        %{ "image" => "#{inspect url}"}
  end

  defp consume_photos(socket, %Staff{} = staff ) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
       destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
       File.cp!(meta.path, destination)
    end)
    {:ok, staff}
  end
  def ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end
end
