defmodule Notionex.Object.Page do
  @type t() :: Notionex.Object.t() | %{
    url: binary,
    public_url: binary,
  }

  defstruct Notionex.Object.default_properties ++ [url: nil, public_url: nil]
end
