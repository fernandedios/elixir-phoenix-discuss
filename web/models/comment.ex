defmodule Discuss.Comment do
  use Discss.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User  # comment belongs to a user
    belongs_to :topic, Discuss.Topic # comment is for a topic

    timestamps()
  end

  def changeser(struct, params \\ %{}) do
    struct
    |> cast(params, [:content]) # take content from params, produce new changeset
    |> validate_required([:content]) # make content required field
  end
end
