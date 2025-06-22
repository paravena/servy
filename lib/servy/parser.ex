defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")
    [request_line | headers_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")
    headers = parse_headers(headers_lines)
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(headers_lines) do
    headers_lines
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [key, value] -> {key |> String.trim(), value |> String.trim()} end)
    |> Enum.into(%{})
  end

  @doc """
  Parses the given params string of the form `key1=value1&key2=value2` into a map with corresponding keys and values.

  ## Examples
      iex> params_string = "name=John&age=30"
      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"name" => "John", "age" => "30"}

      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "")
      %{}
      iex> params_string = "name=John&age=30"
      iex> Servy.Parser.parse_params("multipart/form-data", params_string)
      %{}

      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "name=John&age=30&city=New York")
      %{"name" => "John", "age" => "30", "city" => "New York"}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
