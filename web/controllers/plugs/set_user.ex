defmodule  Discuss.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller

    alias Discuss.Repo
    alias Discuss.User

    def init (_params) do
    end

    # _params is the return value from init
    def call(conn, _params) do
      # get userid from session
      user_id = get_session(conn, :user_id)

      # pull user from db if it exists
      cond do
        # result of Repo.get will be assigned to user if user_id is not nil
        user = user_id && Repo.get(User, user_id) ->
          # if truthy, user is assigned to conn
          assign(conn, :user, user)  # conn.assigns.user = user

        # if no user, assign user to nil
        true ->
          assign(conn, :user, nil)
      end
    end
end
