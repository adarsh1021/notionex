defmodule Notionex.Object.File do
  @type file :: %{
          url: binary,
          expiry_time: binary
        }

  @type external :: %{
          url: binary
        }

  @type t() :: %{
          type: binary,
          file: file,
          external: external
        }
end
