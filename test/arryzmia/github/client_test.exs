defmodule Arryzmia.Github.ClientTest do
  use ExUnit.Case, async: false
  import Mock

  test "Github Client" do
    mocked_request = fn(_path, %{state: state}) ->
      case state do
        "all" -> Arryzmia.Fixtures.Loader.load("github.issues.all.json")
        "closed" -> Arryzmia.Fixtures.Loader.load("github.issues.closed.json")
        _ -> Arryzmia.Fixtures.Loader.load("github.issues.open.json")
      end
      |> Jason.decode!()
    end
    with_mock Arryzmia.Github.Client.Core, [paging_request: mocked_request] do
      assert Arryzmia.Github.Client.issues("foo/bar") |> length() == 19
      assert Arryzmia.Github.Client.issues("foo/bar", %{state: "all"}) |> length() == 6
      assert Arryzmia.Github.Client.issues("foo/bar", %{state: "closed"}) |> length() == 6
      assert Arryzmia.Github.Client.pulls("foo/bar") |> length() == 11
      assert Arryzmia.Github.Client.pulls("foo/bar", %{state: "all"}) |> length() == 24
      assert Arryzmia.Github.Client.pulls("foo/bar", %{state: "closed"}) |> length() == 24
    end
  end
end
