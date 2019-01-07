defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn # for halt()
  import Phoenix.Controller # for put_flash and redirect

  alias Discuss.Router.Helpers # for Helpers.topic_path 

  def init(_params) do
  end

  # params is from init()
  def call(conn, _params) do
    if conn.assigns[:user] do
      conn # just return conn if user is logged in
    else
       # if not logged in
       conn
       |> put_flash(:error, "You must be logged in") # show error msg
       |> redirect(to: Helpers.topic_path(conn, :index)) # redirect to index
       |> halt() # stop connection
    end
  end
end
