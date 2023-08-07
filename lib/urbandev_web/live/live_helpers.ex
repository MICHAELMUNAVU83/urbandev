defmodule UrbandevWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView
  alias Urbandev.Accounts.User
  alias Urbandev.Accounts
  alias UrbandevWeb.Router.Helpers, as: Routes

  # alias Phoenix.Controller

  @doc """
  Renders a component inside the `UrbandevWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.


  ## Examples

      <%= live_modal @socket, UrbandevWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def assign_defaults(session, socket) do
    socket =
      assign_new(socket, :current_user, fn -> find_current_user(session) end)

      case socket.assigns.current_user do
        %User{} ->
          socket

          _other ->
          socket
          # |> put_flash(:error, "You need to be authenticated to access the page")
          |> redirect(to: Routes.user_session_path(socket, :new))
      end
  end

    def find_current_user (session) do
      with user_token when not is_nil(user_token) <- session["user_token"],
      %User{} = user <-Accounts.get_user_by_session_token(user_token) do
        user
      end

    end

  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    IO.inspect socket
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component( UrbandevWeb.ModalComponent, modal_opts)
  end
end
