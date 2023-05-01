defmodule Servy.BearController do
  @spec index(%{resp_body: any, status: any}) :: %{resp_body: <<_::200>>, status: 200}
  def index(conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Doggos #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} dog named #{name}"}
  end
end
