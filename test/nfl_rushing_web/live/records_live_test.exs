defmodule NflRushingWeb.RecordsLiveTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest

  test "initial render state", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#filter-input")
    assert has_element?(view, "#download-btn")
    assert has_element?(view, "#prev-btn[disabled]")
    assert has_element?(view, "#next-btn")

    # Ensure exactly 25 records on first page
    assert view
           |> get_nth_record_element(25)
           |> has_element?()

    refute view
           |> get_nth_record_element(26)
           |> has_element?()

    # First player on the page
    assert has_element?(view, "td", "Joe Banyard")
    # Last player on the page
    assert has_element?(view, "td", "Rashad Jennings")
  end

  test "filtering records list", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    render_change(view, "filter-by-player", %{"player" => "Taiwan"})

    assert view
           |> get_nth_record_element_with_player(1, "Taiwan Jones")
           |> has_element?()
  end

  test "sorting records list by yards", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # Descending order
    view
    |> element("#yards-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "Ezekiel Elliot")
           |> has_element?()

    # Ascending order
    view
    |> element("#yards-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "Sam Koch")
           |> has_element?()
  end

  test "sorting records list by touchdowns", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#touchdowns-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "LeGarrette Blount")
           |> has_element?()

    view
    |> element("#touchdowns-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "Brandon LaFell")
           |> has_element?()
  end

  test "sorting records list by longest rush", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#rush-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "Isaiah Crowell")
           |> has_element?()

    view
    |> element("#rush-header")
    |> render_click()

    assert view
           |> get_nth_record_element_with_player(1, "Taiwan Jones")
           |> has_element?()
  end

  defp get_nth_record_element(view, n) do
    element(view, "tbody tr.record:nth-of-type(#{n})")
  end

  defp get_nth_record_element_with_player(view, n, player) do
    element(view, "tbody tr.record:nth-of-type(#{n})", player)
  end
end
