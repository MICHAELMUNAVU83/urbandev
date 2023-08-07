# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :urbandev,
  ecto_repos: [Urbandev.Repo],
  api_key: "FKiBHJIdIgG4GMm3FlTH",
  api_username: "thamani",
  aft_key: "0902d36a02514da9fa33a11586683f8d76e5207ea544363e7d41149e6c9a6718",
  aft_url: "https://api.africastalking.com/version1/messaging",
  fcm_url: "https://fcm.googleapis.com/v1/projects/afya-cloud/messages:send",
  fcm_key: "AIzaSyAixNAuiD6Kn7rYUhoa221lcWNPEQaUw04",
  fcm_key2: "AIzaSyAVIknHV0EiqF5rCFehNVw8tEbrxUpMrOw",
  fcm_server_key: "AAAAjTNRizM:APA91bF_8SR9mImbB0iDpMAT0W4a9hz8VPCHCvFXcwbn6SMfYjNapAsjsQfMXTbIHoZ3SyoC5H6DN8jMUrBAXyf3SH5MOmoB4HNHUFWW7KUU-rr5z8J4ybzAirPBL4EPcfbO3HbvlNyK",
  fcm_token: "eEOe5_qDTrq2lREX24WNUf:APA91bHwYNTfTK_gr4A0TpihcVDI2tAUnZtSId91C1IJFOMQNchlczjz5Io4vwsB77HwS2OpjYqEemdFjMYjS4erJNe7YrXE1YAbowQ4EBufVS8MmftOLZxqNSq2nY3L2pxXYMIInrIv",
  fcm_clientid: "606451370803-eimp9n7im4gpp3j6u6sb14gmlel031i6.apps.googleusercontent.com",
  fcm_client_secret: "UF-wK425cvfECXxa5Y92Usw8",
    # mpesa links
  mpesa_api_url: "https://api.safaricom.co.ke/",
  consumer_key: "pe94wUyIsffE949N3wD2feAT3eFVjxqV",
  consumer_secret: "3mu4YRLvU9hgcNXE",
  pass_key: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
  confirmation_url: "https://thamanionline.com/callbacks/validate",
  validation_url: "https://41.90.105.110:8000/callbacks/validate",
  short_code: "903491",
  stk_short_code: "903491",
  security_cred: "Safaricom119!",
  b2c_initiator_name: "thamanipay",
  b2c_short_code: "903491",
  response_type: "Cancelled",
  certificate_path: "./lib/thamani_web/keys/live_cert.cer",
  initiator_name: "thamanipay",
  b2c_queue_time_out_url: "http://41.90.105.110:8000/callbacks/validate",
  b2c_result_url: "http://41.90.105.110:8000/callbacks/validate",
  b2b_queue_time_out_url: "http://41.90.105.110:8000/callbacks/validate",
  b2b_result_url: "http://41.90.105.110:8000/callbacks/validate",
  balance_queue_time_out_url: "http://41.90.105.110:8000/callbacks/balance",
  balance_result_url: "http://41.90.105.110:8000/callbacks/balance",
  status_queue_time_out_url: "http://41.90.105.110:8000/callbacks/status",
  status_result_url: "http://41.90.105.110:8000/callbacks/status",
  reversal_queue_time_out_url: "http://41.90.105.110:8000/callbacks/validate",
  reversal_result_url: "http://41.90.105.110:8000/callbacks/validate",
  stk_call_back_url: "http://41.90.105.110:8000/callbacks/validate",
  keylock: "WFv3dqP7oC+Od1GxnQFKwkdyf0i6ipSiTfKtARYSQShO0BwcuvPDLOizPRIiUH"



  config :sendgrid,
    api_key: "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",
    api_key2: "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",
    api_url: "https://api.sendgrid.com/v3/"

# Configures the endpoint
config :urbandev, UrbandevWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YNanXo65VdSsQNOrETOGARMflk/WY6lcmoHNYxgRufEPC+vEnyWTc5+fa65mTIA7",
  render_errors: [view: UrbandevWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Urbandev.PubSub,
  live_view: [signing_salt: "Ijn5t5UL"]

  config :rummage_ecto, Rummage.Ecto,
     default_repo: Urbandev.Repo,
     default_per_page: 10

   config :rummage_phoenix,
     Rummage.Phoenix,
     default_per_page: 10,
     default_max_page_links: 10,
     default_helpers: UrbandevWeb.Router.Helpers


     config :pdf_generator,
       # <-- this program actually doe$
    wkhtml_path: "/usr/bin/wkhtmltopdf",
    # <-- only needed for PDF encryp$
    pdftk_path: "/usr/bin/pdftk",
    command_prefix: "/usr/bin/xvfb-run"

    # Configure esbuild (the version is required)
    config :esbuild,
      version: "0.14.0",
      default: [
        args:
          ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
        cd: Path.expand("../assets", __DIR__),
        env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
      ]

                        config :urbandev, Urbandev.Scheduler,
                          jobs: [
                            # Every second
                            # {"* * * * * *", fn -> :ok end}
                            # Every minute
                             # {"* * * * *",      {Estate.Rest, :webtopic, ["estate","cron job","test automated message "]}},
                            # Every 15 minutes
                            # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
                            # Runs on 18, 20, 22, 0, 2, 4, 6:
                            # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
                            # Runs every midnight:
                            # {"@daily",         {Backup, :backup, []}}
                          ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
