defmodule ArryzmiaWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :arryzmia

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_arryzmia_key",
    signing_salt: "6j/4bhaT"
  ]

  # socket "/socket", ArryzmiaWeb.UserSocket,
  #   websocket: true,
  #   longpoll: false

  def redirect_index(conn = %Plug.Conn{path_info: []}, _opts) do
    %Plug.Conn{conn | path_info: ["index.html"]}
  end
  def redirect_index(conn, _opts), do: conn
  plug :redirect_index

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :arryzmia,
    gzip: false,
    only: ~w(index.html css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CORSPlug, origin: ["http://localhost:4000", "http://localhost:8080"]
  plug ArryzmiaWeb.Router
end
