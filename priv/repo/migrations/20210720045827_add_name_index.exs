defmodule NflRushing.Repo.Migrations.AddNameIndex do
  use Ecto.Migration

  def change do
    create index("records", [:player])
  end
end
