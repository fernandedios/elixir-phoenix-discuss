defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  #def callback(conn, params) do
    # IO.inspect(conn.assigns)
    # IO.inspect(params)
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    # IO.inspect(auth)

    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    insert_or_update(changeset)
  end

  # private function
  defp insert_or_update_user(changeset) do
    # check if user exists
    case Repo.get_by(User, email: changeser.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end

  end
end
