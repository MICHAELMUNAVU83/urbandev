defmodule UrbandevWeb.UserLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Accounts
    alias Urbandev.Accounts.User

  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpeg .jpg ), max_entries: 1)}

  end 

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end
  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
      user = put_photo_url_edit(socket)|> Map.merge(user_params)
    case  IO.inspect Accounts.update_user(socket.assigns.user, user, &consume_photos(socket, &1)) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
      user = put_photo_url(socket, %User{})
    get_datetimestamp =
   Timex.local()
     |> Timex.format!("{YYYY}{0M}{0D}{h24}")

     get_timestamp =
    Timex.local()
      |> Timex.format!("{h24}:{m}:{s}")
    case IO.inspect Accounts.create_user(user, user_params |> Map.merge(%{"user_id" => socket.assigns.user.id, "time" =>get_timestamp, "serial" => get_datetimestamp<>String.upcase(SecureRandom.hex(3)) }) , &consume_photos(socket, &1)) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end



    defp put_photo_url(socket, %User{} = user ) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %User{user | image: "#{inspect url}"}
    end

    defp put_photo_url_edit(socket) do
       {completed, []} = uploaded_entries(socket, :photo)
       url =
         for entry <- completed do
           Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
         end

          %{ "image" => "#{inspect url}"}
    end

    defp consume_photos(socket, %User{} = user ) do
      consume_uploaded_entries(socket, :photo, fn meta, entry ->
         destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
         File.cp!(meta.path, destination)
      end)
      {:ok, user}
    end
    def ext(entry) do
      [ext | _] = MIME.extensions(entry.client_type)
      ext
    end


end
