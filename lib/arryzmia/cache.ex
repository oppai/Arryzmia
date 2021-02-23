defmodule Arryzmia.Cache do
  @cache_name Arryzmia
  @default_expired_time 10800 # 60 * 60 * 3
  defmacro cache(key, expired_time \\ @default_expired_time, do: yield) do
    quote do
      case Cachex.get(unquote(@cache_name), unquote(key)) do
        {:ok, nil} ->
          result = unquote(yield)
          Cachex.put(unquote(@cache_name), unquote(key), result)
          Cachex.expire(unquote(@cache_name), unquote(key), unquote(expired_time))
          result
        {:ok, value} ->
          value
        res -> raise("Invalid response: #{inspect(res)}")
      end
    end
  end
end
