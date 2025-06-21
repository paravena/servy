defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  def full_status(%Servy.Conv{status: status}) do
    "#{status} #{status_reason(status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      202 => "Accepted",
      204 => "No Content",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
      503 => "Service Unavailable",
      504 => "Gateway Timeout"
    }[code]
  end
end
