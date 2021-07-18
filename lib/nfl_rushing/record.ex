defmodule NflRushing.Record do
  @moduledoc """
  Schema for a player's record of rushing statistics
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :player, :string
    field :team, :string
    field :position, :string
    field :attempts, :integer
    field :attempts_per_game_avg, :float
    field :yards, :integer
    field :avg_yards_per_attempt, :float
    field :yards_per_game, :float
    field :touchdowns, :integer
    field :longest_rush, :string
    field :first_downs, :integer
    field :first_down_percentage, :float
    field :twenty_yards_plus, :integer
    field :forty_yards_plus, :integer
    field :fumbles, :integer
  end

  @doc false
  def changeset(record, params \\ %{}) do
    record
    |> cast(params, [
      :player,
      :team,
      :position,
      :attempts,
      :attempts_per_game_avg,
      :yards,
      :avg_yards_per_attempt,
      :yards_per_game,
      :touchdowns,
      :longest_rush,
      :first_downs,
      :first_down_percentage,
      :twenty_yards_plus,
      :forty_yards_plus,
      :fumbles
    ])
  end
end
