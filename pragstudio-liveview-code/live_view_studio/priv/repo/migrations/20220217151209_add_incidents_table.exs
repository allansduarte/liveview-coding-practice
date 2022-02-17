defmodule LiveViewStudio.Repo.Migrations.AddIncidentsTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:incidents) do
      add :description, :string
      add :lat, :float
      add :lng, :float

      timestamps()
    end
  end
end
