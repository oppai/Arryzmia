defmodule Arryzmia.Helpers.Api do
  import Plug.Conn

  defmodule Status do
    def success, do: 1001
    def failure, do: 1002
    def notfound, do: 1003
  end

  def success(conn, params) do
    response(conn, Status.success(), params, 200)
  end

  def failure(conn, status, message, code \\ 200) do
    response(conn, status, %{message: message}, code)
  end

  def notfound(conn) do
    failure(conn, Status.notfound(), "not found", 404)
  end

  defp response(conn, status, params, code) do
    send_resp(conn, code, %{status: status, data: params} |> Jason.encode!())
  end
end
