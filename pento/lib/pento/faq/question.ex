defmodule Pento.Faq.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :answer, :string
    field :question, :string
    field :vote_count, :integer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:answer, :question, :vote_count])
    |> validate_required([:answer, :question, :vote_count])
  end

  def upvote_changeset(question, attrs) do
    question
    |> cast(attrs, [:vote_count])
    |> validate_number(:vote_count, greater_than: question.vote_count)
  end
end
