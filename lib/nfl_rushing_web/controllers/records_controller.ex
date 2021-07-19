defmodule NflRushingWeb.RecordsController do
  @moduledoc """
  A controller for requests to rushing records
  """

  use NflRushingWeb, :controller
  alias NflRushing.Records

  def download(conn, %{
        "player" => player,
        "sort_by" => sort_by,
        "sort_direction" => sort_direction
      }) do
    sort_by = convert_sort_opt_to_atom(sort_by)
    sort_direction = convert_sort_opt_to_atom(sort_direction)

    records =
      Records.list_records_with_player(player, %{
        sort_by: sort_by,
        sort_direction: sort_direction,
        page: nil,
        per_page: nil
      })

    csv = convert_to_csv(records)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"download.csv\"")
    |> send_resp(200, csv)
  end

  defp convert_to_csv(records) do
    records
    |> Enum.reduce([], &convert_record_to_list/2)
    |> Enum.reverse()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end

  defp convert_record_to_list(record, acc) do
    record_attrs = [
      record.player,
      record.team,
      record.position,
      record.attempts_per_game_avg,
      record.attempts,
      record.yards,
      record.avg_yards_per_attempt,
      record.yards_per_game,
      record.touchdowns,
      record.longest_rush,
      record.first_downs,
      record.first_down_percentage,
      record.twenty_yards_plus,
      record.forty_yards_plus,
      record.fumbles
    ]

    [record_attrs | acc]
  end

  defp convert_sort_opt_to_atom(opt) do
    if opt == "" do
      nil
    else
      String.to_atom(opt)
    end
  end
end
