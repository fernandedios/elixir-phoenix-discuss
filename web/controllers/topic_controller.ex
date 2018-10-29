defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def new(conn, params) do
    # IO.inspect conn
    # IO.inspect params

    # struct = %Discuss.Topic{}
    # params = %{}
    # changeset = Discuss.Topic.changeset(struct, params)

    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset  # plucked from templates/topic folder
  end
end
