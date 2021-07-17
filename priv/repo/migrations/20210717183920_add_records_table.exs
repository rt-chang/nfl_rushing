defmodule NflRushing.Repo.Migrations.AddRecordsTable do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :player, :string
      add :team, :string
      add :position, :string
      add :attempts, :integer
      add :attempts_per_game_avg, :float
      add :yards, :integer
      add :avg_yards_per_attempt, :float
      add :yards_per_game, :float
      add :touchdowns, :integer
      add :longest_rush, :string
      add :first_downs, :integer
      add :first_down_percentage, :float
      add :twenty_yards_plus, :integer
      add :forty_yards_plus, :integer
      add :fumbles, :integer
    end
  end
end
