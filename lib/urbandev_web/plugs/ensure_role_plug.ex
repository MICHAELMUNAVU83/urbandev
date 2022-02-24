defmodule UrbandevWeb.EnsureRolePlug do
import Plug.Conn
alias Phoenix.Controller
alias Urbandev.Accounts.User
alias Urbandev.Accounts


  def init(config) do
    config
  end

  def call(conn, roles) do
    user_token = get_session(conn, :user_token)

    (user_token && Accounts.get_user_by_session_token(user_token))
     |> has_role?(roles)
     |> maybe_halt(conn)

       assign(conn, :current_user, user_token && Accounts.get_user_by_session_token(user_token))


  end
  defp has_role?(%User{} = user, roles) when  is_list(roles) do
   Enum.any?(roles, &has_role?(user, &1))
  end

  defp has_role?(%User{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(false, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorised")
    |> Controller.redirect(to: "/dashboard")
    |> halt()
  end

end
