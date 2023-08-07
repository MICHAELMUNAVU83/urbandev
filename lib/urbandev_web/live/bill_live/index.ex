defmodule UrbandevWeb.BillLive.Index do
  use UrbandevWeb, :live_view

  alias Urbandev.Bills
  alias Urbandev.Bills.Bill

    alias Urbandev.Residents

  @impl true
  def mount(_params, session, socket) do
      socket = assign_defaults(session, socket)
      IO.inspect socket.assigns.current_user.role
      bills =
        if socket.assigns.current_user.role == "user" do
          list_bills_user(socket.assigns.current_user)
        else
          list_bills()
        end
    {:ok, assign(socket, :bills, bills)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bill")
    |> assign(:bill, Bills.get_bill!(id))
    |> assign(:residents, Residents.list_resident!())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bill")
    |> assign(:bill, %Bill{})
    |> assign(:residents, Residents.list_resident!())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bills")
    |> assign(:bill, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bill = Bills.get_bill!(id)
    {:ok, _} = Bills.delete_bill(bill)

    {:noreply, assign(socket, :bills, list_bills())}
  end

  defp list_bills do
    Bills.list_bills()
  end

  defp list_bills_user(user) do
    Bills.list_bills_user(user.id)
  end
end
