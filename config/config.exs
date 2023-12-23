import Config

config :notionex,
  base_url: "https://api.notion.com/v1",
  bearer_token: ""

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end
