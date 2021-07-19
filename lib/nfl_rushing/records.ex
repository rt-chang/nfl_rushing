defmodule NflRushing.Records do
  @moduledoc """
  The Records context for a player's record of rushing statistics
  """

  import Ecto.Query
  alias NflRushing.Repo
  alias NflRushing.Record

  def list_records(%{page: page, per_page: per_page}) do
    Record
    |> limit(^per_page)
    |> offset((^page - 1) * ^per_page)
    |> Repo.all()
  end

  def list_records_with_player(player, %{
        page: page,
        per_page: per_page,
        sort_by: sort_by,
        sort_direction: sort_direction
      }) do
    player_name_wildcard = "%" <> player <> "%"

    query =
      Record
      |> where([r], ilike(r.player, ^player_name_wildcard))
      |> paginate(page, per_page)
      |> with_order(sort_direction, sort_by)

    Repo.all(query)
  end

  defp order_by_longest_rush(query, sort_direction) do
    case sort_direction do
      :asc ->
        order_by(query, [r], fragment("CAST(RTRIM(?, 'T') AS INTEGER) ASC", r.longest_rush))

      :desc ->
        order_by(query, [r], fragment("CAST(RTRIM(?, 'T') AS INTEGER) DESC", r.longest_rush))
    end
  end

  defp with_order(query, sort_direction, sort_by) do
    case sort_by do
      nil ->
        query

      :longest_rush ->
        order_by_longest_rush(query, sort_direction)

      _ ->
        case sort_direction do
          :asc -> order_by(query, [r], asc: ^sort_by)
          :desc -> order_by(query, [r], desc: ^sort_by)
        end
    end
  end

  defp paginate(query, page, per_page) do
    case is_nil(page) do
      true ->
        query

      false ->
        query
        |> limit(^per_page)
        |> offset((^page - 1) * ^per_page)
    end
  end
end
