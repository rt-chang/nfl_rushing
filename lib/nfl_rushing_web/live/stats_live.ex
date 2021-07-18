defmodule NflRushingWeb.StatsLive do
 use NflRushingWeb, :live_view
 alias NflRushing.Records

 @impl Phoenix.LiveView
 def mount(_params, _session, socket) do
  records = Records.list_records()
  socket =
    socket
    |> assign(records: records)
    |> assign(filter_player: "")
    |> assign(sort_by: nil)
    |> assign(sort_order: nil)

  {:ok, socket}
 end

 @impl Phoenix.LiveView
 def handle_event("filter-player", %{"player" => player}, socket) do
  player = String.trim(player)
  records =
    if String.length(player) > 0 and player != socket.assigns.filter_player do
      Records.list_records_with_player(player)
    else
      Records.list_records()
    end

  socket =
    socket
    |> assign(records: records)
    |> assign(filter_player: player)

  {:noreply, socket}
 end

 @impl Phoenix.LiveView
 def handle_event("sort-by", %{"attr" => attr}, socket) do
  attr = String.to_atom(attr)
  sort_order = get_sort_order(attr, socket)
  records = sort_records_by(attr, sort_order, socket)
  socket =
    socket
    |> assign(records: records)
    |> assign(sort_order: sort_order)
    |> assign(sort_by: attr)

  {:noreply, assign(socket, records: records)}
 end

 defp sort_records_by(attr, sort_order, socket) do
  Enum.sort_by(socket.assigns.records, fn record ->
    if attr == :longest_rush do
      record
      |> Map.get(attr)
      |> String.trim("T")
      |> String.to_integer()
    else
      Map.get(record, attr)
    end
  end, sort_order)
 end

 def get_sort_order(attr, socket) do
  current_sort_by = socket.assigns.sort_by
  if is_nil(current_sort_by) or attr != current_sort_by or socket.assigns.sort_order == :asc do
      :desc
    else
      :asc
    end
  end
end
