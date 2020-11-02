defmodule Servy.Parse do
  @moduledoc """
  Parse a request and return a map 
  """

  alias Servy.Conv, as: Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
