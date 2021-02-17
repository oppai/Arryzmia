defmodule ArryzmiaWeb.Controllers.DashboardController do
  use ArryzmiaWeb, :controller

  def index(conn, %{"repo" => repo}) do
    success(conn, %{
      pulls: Arryzmia.Github.countOfPulls(repo),
      issues: Arryzmia.Github.countOfIssues(repo),
    })
  end
end
