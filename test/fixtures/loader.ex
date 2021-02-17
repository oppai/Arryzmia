defmodule Arryzmia.Fixtures.Loader do
  def load(file_name), do: File.read!("#{__DIR__}/#{file_name}")
end
