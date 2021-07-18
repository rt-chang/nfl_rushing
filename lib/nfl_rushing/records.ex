defmodule NflRushing.Records do
  @moduledoc """
  The Records context for a player's record of rushing statistics
  """

  import Ecto.Query
  alias NflRushing.Repo
  alias NflRushing.Record

  def list_records() do
    Repo.all(Record)
  end

  def list_records_with_player(name) do
    name_wildcard = "%" <> name <> "%"

    Record
    |> where([r], ilike(r.player, ^name_wildcard))
    |> Repo.all()
  end
end
