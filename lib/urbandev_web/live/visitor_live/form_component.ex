defmodule UrbandevWeb.VisitorLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Visitors
  alias Urbandev.Visitors.Visitor
  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg ), max_entries: 1)}

  end

  @impl true
  def update(%{visitor: visitor} = assigns, socket) do
    changeset = Visitors.change_visitor(visitor)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"visitor" => visitor_params}, socket) do
    changeset =
      socket.assigns.visitor
      |> Visitors.change_visitor(visitor_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end
  def handle_event("save", %{"visitor" => visitor_params}, socket) do
    save_visitor(socket, socket.assigns.action, visitor_params)
  end

  defp save_visitor(socket, :edit, visitor_params) do
      visitor = put_photo_url_edit(socket)|> Map.merge(visitor_params)
    case Visitors.update_visitor(socket.assigns.visitor, visitor, &consume_photos(socket, &1)) do
      {:ok, _visitor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Visitor updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_visitor(socket, :new, visitor_params) do
      visitor = put_photo_url(socket, %Visitor{})
    get_datetimestamp =
   Timex.local()
     |> Timex.format!("{YYYY}{0M}{0D}{h24}")

     get_timestamp =
    Timex.local()
      |> Timex.format!("{h24}:{m}:{s}")
    case IO.inspect Visitors.create_visitor(visitor, visitor_params |> Map.merge(%{"user_id" => socket.assigns.user.id, "time" =>get_timestamp, "serial" => get_datetimestamp<>String.upcase(SecureRandom.hex(3)) }), &consume_photos(socket, &1)) do
      {:ok, _visitor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Visitor created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end



    defp put_photo_url(socket, %Visitor{} = visitor ) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %Visitor{visitor | image: "#{inspect url}"}
    end

    defp put_photo_url_edit(socket) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %{ "image" => "#{inspect url}"}
    end

    defp consume_photos(socket, %Visitor{} = visitor ) do
      consume_uploaded_entries(socket, :photo, fn meta, entry ->
         destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
         File.cp!(meta.path, destination)
      end)
      {:ok, visitor}
    end
    def ext(entry) do
      [ext | _] = MIME.extensions(entry.client_type)
      ext
    end


end
