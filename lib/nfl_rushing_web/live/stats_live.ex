defmodule NflRushingWeb.StatsLive do
 use NflRushingWeb, :live_view
 alias NflRushing.Records

 @impl Phoenix.LiveView
 def mount(_params, _session, socket) do
  records = Records.list_records()
  {:ok, assign(socket, records: records)}
 end
end
