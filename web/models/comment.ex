defmodule Discuss.Comment do
  use Discuss.Web, :model

  # instruct Poison Encoder to only conver :content
  # Poison.Encoder converts model to json for socket communication
  @derive {Poison.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User  # comment belongs to a user
    belongs_to :topic, Discuss.Topic # comment is for a topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content]) # take content from params, produce new changeset
    |> validate_required([:content]) # make content required field
  end
end
