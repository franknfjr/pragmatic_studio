defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  def full_status(%{status: status} = conv) do
      #{status} #{status_reason(status)}
  end

  defp status_reason(%{status: status} = conv) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[status]
  end
end
