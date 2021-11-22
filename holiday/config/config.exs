import Config

config :holiday, Holiday.Repo,
  database: "holiday_repo",
  username: "user_name",
  password: "pass",
  hostname: "localhost"

config :holiday, ecto_repos: [Holiday.Repo]
