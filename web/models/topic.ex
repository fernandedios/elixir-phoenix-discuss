defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User # topic is owned by 1 user
    has_many :comments, Discuss.Comment # topic can have many comments
  end

  # \\ %{} defines default params to be empty struct
  def changeset(struct, params \\ %{}) do
    struct # represents a record
    |> cast(params, [:title]) # produces a changeset
    |> validate_required([:title])
  end
end
