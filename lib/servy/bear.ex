defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_hibernating?(bear) do
    bear.hibernating
  end

  def is_grizzly?(bear) do
    bear.type == "Grizzly"
  end

  def order_asc_by_name(bear1, bear2) do
    String.downcase(bear1.name) <= String.downcase(bear2.name)
  end
end
