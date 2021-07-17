# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias NflRushing.Repo
alias NflRushing.Record

with file <- File.read!("priv/repo/rushing.json"),
     json <- Jason.decode!(file) do
  Enum.each(json, fn record ->
    yards =
      if is_binary(record["Yds"]) do
        record["Yds"]
        |> String.replace(",", "")
        |> String.to_integer()
      else
        record["Yds"]
      end

    longest_rush =
      if is_binary(record["Lng"]) do
        record["Lng"]
      else
        Integer.to_string(record["Lng"])
      end

    params = %{
      player: record["Player"],
      team: record["Team"],
      position: record["Pos"],
      attempts: record["Att"],
      attempts_per_game_avg: record["Att/G"],
      yards: yards,
      avg_yards_per_attempt: record["Avg"],
      yards_per_game: record["Yds/G"],
      touchdowns: record["TD"],
      longest_rush: longest_rush,
      first_downs: record["1st"],
      first_down_percentage: record["1st%"],
      twenty_yards_plus: record["20+"],
      forty_yards_plus: record["40+"],
      fumbles: record["FUM"]
    }

    changeset = Record.changeset(%Record{}, params)
    Repo.insert!(changeset)
  end)
end
