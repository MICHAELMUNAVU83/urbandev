
defmodule Urbandev.Rest.Paypal do
  @moduledoc """
  The Shops context.
  """

  import Ecto.Query, warn: false
  use HTTPotion.Base

  def get_timestamp do
    Timex.local()
    |> Timex.format!("{YYYY}{0M}{0D}-{h24}{m}{s}")
  end

  def create_base64_key() do
    username= "sb-n43c0g2374309"
    clientid = "AV0kN6-lJfoBovp_X4p_heEaBxEFGqAse1ucaOWiCXogRwisxlqFretZBRhMCCVMS-qND5TdxeoVP5y_"
    secret = "EHJoRMbWMQ1VpaALJSH6PXOCjHnbIRAU_GwaDcBoSuKg_mY662-F0KP7vWelnrS3PO2mLWeZrNu0rEyy"
    (clientid <> ":" <> secret) |> Base.encode64()
  end

  def create_token() do
  HTTPotion.start()
  header = [
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Accept-Language": "en_US",
      "Authorization": "Basic #{create_base64_key()}"
  ]
 body = %{
   "grant_type" => "client_credentials",

 }

 HTTPotion.post("https://api-m.sandbox.paypal.com/v1/oauth2/token", body: URI.encode_query(body), headers: header)
  |> process_response()
end


def plans() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "total_required" => "yes"
}


HTTPotion.get("https://api-m.sandbox.paypal.com/v1/billing/plans", body: URI.encode_query(body), headers: header)
|> process_response()
end

def create_plans() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}",
    # "PayPal-Request-Id": "PLAN-18062019-001"
]
body = %{

  "product_id" => "PROD-XXCD1234QWER65782",
    "name" => "Video Streaming Service Plan",
    "description" => "Video Streaming Service basic plan",
    "status" => "ACTIVE",
    "billing_cycles" => [
      %{
        "frequency" => %{
          "interval_unit" => "MONTH",
          "interval_count" => 1
        },
        "tenure_type" => "TRIAL",
        "sequence" => 1,
        "total_cycles" => 2,
        "pricing_scheme" => %{
          "fixed_price" => %{
            "value" => "3",
            "currency_code" => "USD"
          }
        }
      },
      %{
        "frequency" => %{
          "interval_unit" => "MONTH",
          "interval_count" => 1
        },
        "tenure_type" => "TRIAL",
        "sequence" => 2,
        "total_cycles" => 3,
        "pricing_scheme" => %{
          "fixed_price" => %{
            "value" => "6",
            "currency_code" => "USD"
          }
        }
      },
      %{
        "frequency" => %{
          "interval_unit" => "MONTH",
          "interval_count" => 1
        },
        "tenure_type" => "REGULAR",
        "sequence" => 3,
        "total_cycles" => 12,
        "pricing_scheme" => %{
          "fixed_price" => %{
            "value" => "10",
            "currency_code" => "USD"
          }
        }
      }
    ],
    "payment_preferences" => %{
      "auto_bill_outstanding" => true,
      "setup_fee" => %{
        "value" => "10",
        "currency_code" => "USD"
      },
      "setup_fee_failure_action" => "CONTINUE",
      "payment_failure_threshold" => 3
    },
    "taxes" => %{
      "percentage" => "10",
      "inclusive" => false
    }
}


HTTPotion.post("https://api-m.sandbox.paypal.com/v1/billing/plans", body: Poison.encode!(body), headers: header)
|> process_response()
end

def identity() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "total_required" => "yes"
}


HTTPotion.get("https://api-m.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1", body: URI.encode_query(body), headers: header)
|> process_response()
end



def billing_plans() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{
  "status" => "ALL",
  # "page_size" => 2,
  # "page" => 1
  "total_required" => "yes"
}


HTTPotion.get("https://api-m.sandbox.paypal.com/v1/payments/billing-plans", body: URI.encode_query(body), headers: header)
|> process_response()
end

def create_billing_plans() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{
  "name" => "Plan with Regular and Trial Payment Definitions",

   "description" => "Plan with regular and trial payment definitions.",

   "type" => "FIXED",

   "payment_definitions" => [

     %{

       "name" => "Regular payment definition",

       "type" => "REGULAR",

       "frequency" => "MONTH",

       "frequency_interval" => "2",

       "amount" => %{

         "value" => "100",

         "currency" => "USD"

       },

       "cycles" => "12",

       "charge_models" => [

         %{

           "type" => "SHIPPING",

           "amount" => %{

             "value" => "10",

             "currency" => "USD"

           }

         },

         %{

           "type" => "TAX",

           "amount" => %{

             "value" => "12",

             "currency" => "USD"

           }

         }

       ]

     },

     %{

       "name" => "Trial payment definition",

       "type" => "TRIAL",

       "frequency" => "WEEK",

       "frequency_interval" => "5",

       "amount" => %{

         "value" => "9.19",

         "currency" => "USD"

       },

       "cycles" => "2",

       "charge_models" => [

         %{

           "type" => "SHIPPING",

           "amount" => %{

             "value" => "1",

             "currency" => "USD"

           }

         },

         %{

           "type" => "TAX",

           "amount" => %{

             "value" => "2",

             "currency" => "USD"

           }

         }

       ]

     }

   ],

   "merchant_preferences" => %{

     "setup_fee" => %{

       "value" => "1",

       "currency" => "USD"

     },

     "return_url" => "https://example.com",

     "cancel_url" => "https://example.com/cancel",

     "auto_bill_amount" => "YES",

     "initial_fail_amount_action" => "CONTINUE",

     "max_fail_attempts" => "0"

   }
}


HTTPotion.post("https://api-m.sandbox.paypal.com/v1/payments/billing-plans", body: Poison.encode!(body), headers: header)
|> process_response()
end

def pay_profiles() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "total_required" => "yes"
}


HTTPotion.get("https://api-m.sandbox.paypal.com/v1/payment-experience/web-profiles", body: URI.encode_query(body), headers: header)
|> process_response()
end

def create_pay_profiles() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "name" => "exampleProfile",

   "presentation" => %{

     "logo_image" => "https://example.com/logo_image/"

   },

   "input_fields" => %{

     "no_shipping" => 1,

     "address_override" => 1

   },

   "flow_config" => %{

     "landing_page_type" => "billing",

     "bank_txn_pending_url" => "https://example.com/flow_config/"

   }
}


HTTPotion.post("https://api-m.sandbox.paypal.com/v1/payment-experience/web-profiles", body: Poison.encode!(body), headers: header)
|> process_response()
end


def update_pay_profiles() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "PayPal-Request-Id": "abcdefgh123",
    "Authorization": "Bearer #{token}"
]
body = %{

  "name" => "Profile_one",

   "presentation" => %{

     "logo_image" => "https://example.com/logo_image/exists"

   },

   "input_fields" => %{

     "no_shipping" => 1,

     "address_override" => 1

   },

   "flow_config" => %{

     "landing_page_type" => "billing",

     "bank_txn_pending_url" => "https://example.com/flow_config/"

   }
}

pid = "XP-XUXB-HEYT-MNTW-2ET2"
HTTPotion.put("https://api-m.sandbox.paypal.com/v1/payment-experience/web-profiles/#{pid}", body: Poison.encode!(body), headers: header)
|> process_response()
end


def delete_pay_profiles() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
      "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "total_required" => "yes"
}

pid = "XP-XUXB-HEYT-MNTW-2ET2"
HTTPotion.delete("https://api-m.sandbox.paypal.com/v1/payment-experience/web-profiles/#{pid}", body: Poison.encode!(body), headers: header)
|> process_response()
end


def get_invoices() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{
 "total_required" => true
}

HTTPotion.get("https://api-m.sandbox.paypal.com/v2/invoicing/invoices", body: Poison.encode!(body), headers: header)
|> process_response()
end

def get_orders() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{
  "intent"=> "CAPTURE",
  "purchase_units" => [
  %{
    "amount" => %{
      "currency_code" => "USD",
      "value" => "100.00"
    }
  }
 ]
}

HTTPotion.post("https://api-m.sandbox.paypal.com/v2/checkout/orders", body: Poison.encode!(body), headers: header)
|> process_response()
end


def create_tracking() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{
  "trackers" => [

     %{

       "transaction_id"=> "123456789",

       "tracking_number"=> "",

       "status"=> "SHIPPED",

       "carrier"=> "FEDEX"

     },

     %{

       "transaction_id"=> "53Y56775AE587553X",

       "tracking_number"=> "",

       "status"=> "SHIPPED",

       "carrier"=> "DE_DHL_PARCEL"

     }

   ]


}
HTTPotion.post("https://api-m.sandbox.paypal.com/v1/shipping/trackers-batch", body: Poison.encode!(body), headers: header)
|> process_response()
end

def get_tracking(id) do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

}
trackid = "8MC585209K746392H-443844607820"

HTTPotion.get("https://api-m.sandbox.paypal.com/v1/shipping/trackers/#{trackid}", body: Poison.encode!(body), headers: header)
|> process_response()
end

def update_tracking(id) do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{

  "transaction_id" => "8MC585209K746392H",
  "tracking_number" => "443844607820",
  "status" => "SHIPPED",
  "carrier" => "FEDEX"

}
trackid = "8MC585209K746392H-443844607820"

HTTPotion.put("https://api-m.sandbox.paypal.com/v1/shipping/trackers/#{trackid}", body: Poison.encode!(body), headers: header)
|> process_response()
end


def payments() do
HTTPotion.start()
{:ok, _ ,%HTTPotion.Response{status_code: status_code, body: body}} = create_token()
token = Poison.decode!(body)["access_token"]

header = [
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "en_US",
    "Authorization": "Bearer #{token}"
]
body = %{


}
trackid = "0VF52814937998046"

HTTPotion.get("https://api-m.sandbox.paypal.com/v2/payments/authorizations/#{trackid}", body: Poison.encode!(body), headers: header)
|> process_response()
end


def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
  cond do
    status_code == 200 ->
      {:ok, body, resp}

    true ->
      {:error, resp}
  end
end


end
