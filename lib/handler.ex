defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  @page_path Path.expand("../pages/", __DIR__)

  alias Servy.Conv
  alias Servy.BearController
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parse, only: [parse: 1]

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

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  @doc """
  Route for wildthings
  """
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  @doc """
  Route for bears
  """
  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  @doc """
  Post data
  """
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  @doc """
  Route for doggos id
  """
  def route(%Conv{method: "GET", path: "/doggos/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  @doc """
  Route for wrong path
  """
  def route(%Conv{path: path} = conv) do
    %Conv{conv | status: 404, resp_body: "No #{path} here!"}
  end

  @doc """
  Route for read a file about
  """
  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @page_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  @doc """
  Return a content ok
  """
  def handle_file({:ok, content}, conv) do
    %Conv{conv | status: 200, resp_body: content}
  end

  @doc """
  Rerturn file don't exist
  """
  def handle_file({:error, :enoent}, conv) do
    %Conv{conv | status: 404, resp_body: "File not found."}
  end

  @doc """
  Return an error
  """
  def handle_file({:error, reason}, conv) do
    %Conv{conv | status: 500, resp_body: "File Error: #{reason}."}
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
  Format response
  """
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Servy.Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
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

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Dogguito&type=Caramelo
"""

response = Servy.Handler.handle(request)

IO.puts(response)
