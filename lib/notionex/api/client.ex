defmodule Notionex.API.Client do
  @callback request(%Notionex.API.Request{}, keyword) :: {:ok, any()} | {:error, any()}
  @callback request!(%Notionex.API.Request{}, keyword) :: any()
end
