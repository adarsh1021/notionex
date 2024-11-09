defmodule Notionex.API.Client do
  @callback request(%Notionex.API.Request{}, map()) :: {:ok, any()} | {:error, any()}
  @callback request!(%Notionex.API.Request{}, map()) :: any()
end
