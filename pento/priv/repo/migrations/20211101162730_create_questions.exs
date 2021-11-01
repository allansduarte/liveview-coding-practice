defmodule Pento.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :answer, :string
      add :question, :string
      add :vote_count, :integer

      timestamps()
    end
  end
end
