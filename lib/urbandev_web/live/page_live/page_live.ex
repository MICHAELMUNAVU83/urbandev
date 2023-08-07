defmodule UrbandevWeb.PageLive do
  use UrbandevWeb, :live_view_root
  alias Urbandev.Visitors
  alias Urbandev.Visitors.Visitor
  alias Urbandev.Realestates

  @impl true
  def mount(_params, session, socket) do
    IO.inspect get_connect_info(socket)
    changeset = Visitors.change_visitor(%Visitor{})
    estate= Realestates.list_estate!()
    if connected?(socket), do: Visitors.subscribe()
    {:ok, assign(socket, query: "", changeset: changeset,estate: estate, results: %{})}
  end



  @impl true
  def handle_event("save", %{"visitor" => params}, socket) do
    code = get_timestamp<>"datem"<>SecureRandom.hex(6)
    full_params = params |> Map.merge(%{"user_id" => "", "time" =>get_timestamp, "serial" => code})
    qr_code_png =
      code
      |> QRCodeEx.encode()
      |> QRCodeEx.png()

    _url = File.write("priv/static/images/access/" <> code <> ".png", qr_code_png, [:binary])
    socket =
      case IO.inspect Visitors.create_visitor!(full_params) do
        {:ok, _visitor} ->
          blank_changeset = Visitors.change_visitor(%Visitor{})

          assign(socket, changeset: blank_changeset)

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"visitor" => params}, socket) do
    changeset =
      %Visitor{}
      |> Visitors.change_visitor(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:visitor_created, visitor}, socket) do
    socket = update(socket, :query, fn visitors -> [visitor | visitors] end)

    {:noreply,
     socket
     |> put_flash(:info, "visitor details created successfully")}
  end

  def get_timestamp do
    Timex.local()
    |> Timex.format!("{h24}{m}{s}")
  end
  def get_datestamp do
    Timex.local()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
  end
end
