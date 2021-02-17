defmodule Arryzmia.Github do
  alias Arryzmia.Github.Client

  defp month_ago, do: Timex.now() |> Timex.shift(months: -1) |> DateTime.to_iso8601()
  defp range_from(from), do: Date.range(Timex.now() |> DateTime.to_date(), from |> DateTime.to_date())

  defp filtered_date(issues, label) do
    Enum.map(issues, fn issue ->
      Map.get(issue, label)
        |> DateTime.from_iso8601()
        |> elem(1)
        |> DateTime.to_date()
        |> to_string()
    end)
  end

  defp count_of_days(days, date) do
    Enum.count(days, fn day -> day == date end)
  end

  defp make_count_of_days_all(base_days, target_days) do
    base_days
    |> Enum.map(fn date ->
      %{
        date: date,
        count: count_of_days(target_days, date)
      }
    end)
  end

  def countOfIssues(repo_name) do
    open_issues = Client.issues(repo_name) |> length()
    thirty_days = Timex.now() |> Timex.shift(months: -1) |> range_from() |> Enum.map(&to_string/1)
    created_days = Client.issues(repo_name, %{state: "all", since: month_ago()}) |> filtered_date("created_at")
    closed_days = Client.issues(repo_name, %{state: "closed", since: month_ago()}) |> filtered_date("closed_at")
    %{
      open_count: open_issues,
      created_count_per_day: make_count_of_days_all(thirty_days, created_days),
      closed_count_per_day: make_count_of_days_all(thirty_days, closed_days)
    }
  end

  def countOfPulls(repo_name) do
    open_pulls = Client.pulls(repo_name) |> length()
    thirty_days = Timex.now() |> Timex.shift(months: -1) |> range_from() |> Enum.map(&to_string/1)
    created_days = Client.pulls(repo_name, %{state: "all", since: month_ago()}) |> filtered_date("created_at")
    closed_days = Client.pulls(repo_name, %{state: "closed", since: month_ago()}) |> filtered_date("closed_at")
    %{
      open_count: open_pulls,
      created_count_per_day: make_count_of_days_all(thirty_days, created_days),
      closed_count_per_day: make_count_of_days_all(thirty_days, closed_days)
    }
  end
end
