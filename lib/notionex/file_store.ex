defmodule Notionex.FileStore do
  @callback get(any()) :: any()
  @callback put(any()) :: any()
  @callback delete(any()) :: any()
end
