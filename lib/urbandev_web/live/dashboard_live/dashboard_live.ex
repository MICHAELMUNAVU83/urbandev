defmodule UrbandevWeb.DashboardLive do
  use UrbandevWeb, :live_view

  alias Urbandev.Accounts
  alias Urbandev.Residents
  alias Urbandev.Realestates
  alias Urbandev.Visitors


  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    if connected?(socket) do
      :timer.send_interval(5000, self(), :tick)
    end

    socket = assign_stats(socket)
      {:ok, socket}
  end


  @impl true
    def handle_event("refresh", _, socket) do
      socket = assign_stats(socket)
      {:noreply, socket}
    end
  @impl true
    def handle_info(:tick, socket) do
      socket = assign_stats(socket)
      {:noreply, socket}
    end

    defp assign_stats(socket) do
      assign(socket,
        cars:   Enum.random(100..1000),
        accounts: Accounts.get_user_count(),
        residents: Residents.get_resident_count(),
        realestates: Realestates.get_realestate_count(),
        visitors: Visitors.get_visitor_count()
      )
    end
end
