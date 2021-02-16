defmodule Arryzmia.Github.Client do
  @config Application.get_env(:arryzmia, Arryzmia)
  defp access_token, do: @config |> Keyword.get(:github_token)

  defp header(), do: [{"Accept", "application/vnd.github.v3+json"}, {"Authorization", "token #{access_token()}"}]

  defp request(path, opt \\ %{}) do
    "https://api.github.com#{path}?#{URI.encode_query(opt)}"
    |> HTTPoison.get!(header())
    |> Map.get(:body)
    |> Jason.decode!()
  end

  defp paging_request(path, opt) do
    request(path, opt)
    |> case do
      [] -> []
      list ->
        next_page = opt |> Map.get(:page, 1) |> Kernel.+(1)
        list ++ paging_request(path, Map.merge(opt, %{page: next_page})) 
    end
  end

  def repo(repo_name) do
    request("/repos/#{repo_name}")
  end

  def issues(repo_name, opt \\ %{state: "open"}) do
    paging_request("/repos/#{repo_name}/issues", opt |> Map.merge(%{per_page: 100, page: 1}))
    |> Enum.filter(fn issue ->
      issue |> Map.get("pull_request") |> is_nil()
    end)
  end

  def pulls(repo_name, opt \\ %{state: "open"}) do
    paging_request("/repos/#{repo_name}/issues", opt |> Map.merge(%{per_page: 100, page: 1}))
    |> Enum.filter(fn issue ->
      issue |> Map.get("pull_request") |> is_nil() |> Kernel.not()
    end)
  end
end