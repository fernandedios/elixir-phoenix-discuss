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

    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: params.provider
    }
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  # private
  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  # private function
  defp insert_or_update_user(changeset) do
    # check if user exists
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end

  end
end
