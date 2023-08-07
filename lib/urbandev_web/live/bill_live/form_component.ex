defmodule UrbandevWeb.BillLive.FormComponent do
  use UrbandevWeb, :live_component

  alias Urbandev.Bills
    alias Urbandev.Bills.Bill
  @impl true
  def mount(socket) do

    {:ok, allow_upload(socket, :photo, accept: ~w(.pdf ), max_entries: 1)}

  end

  @impl true
  def update(%{bill: bill} = assigns, socket) do
    changeset = Bills.change_bill(bill)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"bill" => bill_params}, socket) do
    changeset =
      socket.assigns.bill
      |> Bills.change_bill(bill_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"bill" => bill_params}, socket) do
    save_bill(socket, socket.assigns.action, bill_params)
  end

  defp save_bill(socket, :edit, bill_params) do
        bill = put_photo_url_edit(socket)|> Map.merge(bill_params)
    case Bills.update_bill(socket.assigns.bill, bill, &consume_photos(socket, &1)) do
      {:ok, _bill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bill updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bill(socket, :new, bill_params) do
    bill = put_photo_url(socket, %Bill{})
    case Bills.create_bill(bill, bill_params|> Map.merge(%{"user_id" => socket.assigns.user.id}), &consume_photos(socket, &1) )  do
      {:ok, _bill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bill created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_photo_url(socket, %Bill{} = bill ) do
     {completed, []} = uploaded_entries(socket, :photo)
     url =
       for entry <- completed do
         Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
       end

        %Bill{bill | file: "#{inspect url}"}
  end

  defp put_photo_url_edit(socket) do
     {completed, []} = uploaded_entries(socket, :photo)
     url =
       for entry <- completed do
         Routes.static_path(socket, "/images/uploads/#{entry.uuid}.#{ext(entry)}")
       end

        %{ "file" => "#{inspect url}"}
  end

  defp consume_photos(socket, %Bill{} = bill ) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
       destination = Path.join("priv/static/images/uploads", "#{entry.uuid}.#{ext(entry)}")
       File.cp!(meta.path, destination)
    end)
    {:ok, bill}
  end
  def ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end
end
