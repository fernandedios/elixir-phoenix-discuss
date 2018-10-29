defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
  end

  # \\ %{} defines default params to be empty struct
  def changeset(struct, params \\ %{}) do
    struct # represents a record
    |> cast(params, [:title]) # produces a changeset
    |> validate_required([:title])
  end
end