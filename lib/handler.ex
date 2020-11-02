defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  @page_path Path.expand("../pages/", __DIR__)

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  @doc """
  Logs 404 request
  """
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} not exist!")
    conv
  end

  @doc """
  Log not 404
  """
  def track(conv), do: conv

  @doc """
  Update a path
  """
  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  @doc """
  Not updated
  """
  def rewrite_path(conv), do: conv

  @doc """
  Log conv
  """
  def log(conv), do: IO.inspect(conv)

  @doc """
  Parse a request and return a map 
  """
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  @doc """
  Route for wildthings
  """
  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  @doc """
  Route for bears
  """
  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  @doc """
  Route for read a file about
  """
  def route(%{method: "GET", path: "/about"} = conv) do
    @page_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  @doc """
  Return a content ok
  """
  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  @doc """
  Rerturn file don't exist
  """
  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found."}
  end

  @doc """
  Return an error
  """
  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File Error: #{reason}."}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file = 
  #   Path.expand("../pages/", __DIR__)
  #   |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found."}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File Error: #{reason}."}
  #   end
  # end

  @doc """
  Route for doggos id
  """
  def route(%{method: "GET", path: "/doggos/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Doggos #{id}"}
  end

  @doc """
  Route for wrong path
  """
  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  @doc """
  Format response
  """
  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /doggos HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /doggos/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
