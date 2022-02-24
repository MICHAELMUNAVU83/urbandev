defmodule UrbandevWeb.UserRegistrationController do
  use UrbandevWeb, :controller

  alias Urbandev.Accounts
  alias Urbandev.Accounts.User
  alias UrbandevWeb.UserAuth
  alias Urbandev.Kcitys

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    list_city = Kcitys.list_cities()
    render(conn, "new.html", changeset: changeset, list_city: list_city)
  end

  def create(conn, %{"user" => user_params}) do
      list_city = Kcitys.list_cities()
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, list_city: list_city)
    end
  end
end
