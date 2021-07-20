defmodule NflRushingWeb.RecordsLive do
  @moduledoc """
  LiveView for the main statistics page
  """

  use NflRushingWeb, :live_view
  alias NflRushing.Records

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    pagination_opts = %{page: 1, per_page: 25}

    socket =
      socket
      |> assign(records: Records.list_records(pagination_opts))
      |> assign(filter_by_player: "")
      |> assign(sort_by: nil)
      |> assign(sort_direction: nil)
      |> assign(pagination_opts: pagination_opts)

    {:ok, socket, temporary_assigns: [records: []]}
  end

  @impl Phoenix.LiveView
  def handle_event("filter-by-player", %{"player" => player}, socket) do
    player = String.trim(player)
    is_new_filter = player != socket.assigns.filter_by_player

    pagination_opts =
      if is_new_filter do
        %{page: 1, per_page: socket.assigns.pagination_opts.per_page}
      else
        socket.assigns.pagination_opts
      end

    records =
      cond do
        is_new_filter ->
          opts =
            Map.merge(pagination_opts, %{
              sort_by: socket.assigns.sort_by,
              sort_direction: socket.assigns.sort_direction
            })

          Records.list_records_with_player(player, opts)

        player == socket.assigns.filter_by_player ->
          socket.assigns.records
      end

    socket =
      socket
      |> assign(records: records)
      |> assign(filter_by_player: player)
      |> assign(pagination_opts: pagination_opts)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("sort-by", %{"attr" => sort_by}, socket) do
    sort_by = String.to_atom(sort_by)
    sort_direction = get_sort_direction(sort_by, socket)

    sort_opts = %{sort_by: sort_by, sort_direction: sort_direction}

    records =
      socket.assigns.filter_by_player
      |> Records.list_records_with_player(Map.merge(socket.assigns.pagination_opts, sort_opts))

    socket =
      socket
      |> assign(records: records)
      |> assign(sort_direction: sort_direction)
      |> assign(sort_by: sort_by)

    {:noreply, socket}
  end

  def handle_event("fetch-page", %{"direction" => direction}, socket) do
    pagination_opts = socket.assigns.pagination_opts

    new_page =
      case direction do
        "previous" -> pagination_opts.page - 1
        "next" -> pagination_opts.page + 1
      end

    records =
      socket.assigns.filter_by_player
      |> Records.list_records_with_player(%{
        page: new_page,
        per_page: pagination_opts.per_page,
        sort_by: socket.assigns.sort_by,
        sort_direction: socket.assigns.sort_direction
      })

    socket =
      socket
      |> assign(records: records)
      |> assign(pagination_opts: %{page: new_page, per_page: pagination_opts.per_page})

    {:noreply, socket}
  end

  defp get_sort_direction(sort_by, socket) do
    current_sort_by = socket.assigns.sort_by

    case is_nil(current_sort_by) or sort_by != current_sort_by or
           socket.assigns.sort_direction == :asc do
      true -> :desc
      false -> :asc
    end
  end

  defp get_download_link(assigns) do
    "/download?player=#{assigns.filter_by_player}" <>
      "&sort_by=#{assigns.sort_by}" <>
      "&sort_direction=#{assigns.sort_direction}" <>
      "&page=#{assigns.pagination_opts.page}" <>
      "&per_page=#{assigns.pagination_opts.per_page}"
  end
end
