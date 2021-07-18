defmodule NflRushing.Records do
  @moduledoc """
  The Records context for a player's record of rushing statistics
  """

  alias NflRushing.Repo
  alias NflRushing.Record

  def list_records() do
    Repo.all(Record)
  end
end
