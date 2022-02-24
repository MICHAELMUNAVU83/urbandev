
defmodule Urbandev.Rest do
  @moduledoc """
  The Shops context.
  """

  import Ecto.Query, warn: false
  use HTTPotion.Base
  def get_api_url() do
    Application.get_env(:urbandev, :fcm_url)
  end

  def get_api_token() do
    Application.get_env(:urbandev, :fcm_token)
  end

  def get_api_key() do
    Application.get_env(:urbandev, :fcm_key)
  end
  def get_server_key() do
    Application.get_env(:urbandev, :fcm_server_key)
  end

  def valid do
      HTTPotion.start()
      header = [
        Authorization: "key=#{get_server_key()}",
        "Content-Type": "application/json",
        Accept: "application/json"
      ]

      body = %{
            "registration_ids" => [get_api_token()],

            }

    post("https://fcm.googleapis.com/fcm/send", body: Jason.encode!(body), headers: header)
    |> process_response()
  end

def get_token() do
  HTTPotion.start()

  private_key = JsonWebToken.Algorithm.RsaUtil.private_key( "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC7undQZ/LxU5AH\njMmMXrM/GO2YWHAMtCuk+Ab0cSe/1Xel1LVJ95ewmvuWRzz7PBxjEBz+tBUrP+5Z\ninlLfjmTy6ey+bAXVPO2VXWEOnwJ0XVnQMqUOexNKBs4R924me31wmAKGVQlvaAm\nAF5y+SrY3TRk8JGZJbmwHIX7V2dlgamZ1mhLgrzkjEUdYstX8/399CbJKxCp/nLP\n8W9mI1YVEipmhi5korr0ZnefTO8PTgcofOEIlzvAP21JCrsQSf/DeXievNpiLmSN\nKL33Zb8rsxpsLH9B9EC0dR+44krbFB0H0QDpzuWEa/J/bwafy2c+avwQoP4piIkZ\nsd34yRxlAgMBAAECggEAJKb536GD/dkWUFsNCNJ+ha28yddOfTR6JvnkBbrIC3zG\noQKAKMJmA+2mfEdJYTXxxueg+Zu4XFrdku7l0rcAz9nd0qRMXKnR8YIK8Ten+xTB\nqtisFLegasoPUnQ5lm67VpXOQXqDguDckT7WMfVzB6dcsO6FRtTmRbuz7wg4IEmU\nc+SJxdZSNajUqKWdJ9SH42cWnqnOnQSp52RlrasfEmOryoUFoFzDZD1jPDquAkSS\ncSoUjNAMxYOKMXmGgdtpVQatY4wXdUW2cvDkpOU0KVOcY3TLshnawszWALNBirb4\nRAka56PmfDddCtTsjmMGp2TNElIKEK0qJxlY2wfcSwKBgQDcyvhk5QlnHM0DO81q\n1B69oLJD8IgTpXcmr+1bzjp+cmaONL6jxWi0ZEQcChE8f4WV+1Hor+1cpcE1X7Jm\nz7yPIhE/ViDu9580RxdEe3bsiT5Va/jMkr7JvbxMBwqHExn5GW7iXPVaYph4PStC\nkUmwRysLmHmX4fCj6tJd57EezwKBgQDZqcOuQ0oq5UREiuXHe3diUUsrPyTokvFq\njf0SmgtW8zGdF0isiUVqIMJsrTacZ6hBr1z5MFPPPyPDMK+M1ZtFYvR5iq7EIAoq\n2UXuaNG4r1NA4gwzeMTJsJNMNNLeQtR/XPwYO6pGPE70sB++1B/hJvo5u5C9JVjB\np8P7QzT+iwKBgCvM1BPn38Kl0wHGNkzwAZ0qqNKTf9st4wI4ukSRF8eH2FJzojII\n8ml+zoglcx/mSFDlh206oULU2wxEjLaalVRrtLI02tmtI9cSF0qNl5z66PO3NKcY\noWKSEi2e4/bB0lA5PGcJe97PWmHX+KH/AnhG1gI54D1CJCPQbKUWVmu/AoGAW27u\n3mMx4rcQaGKYh6WbztcrZm1OCczAUOx4ZLoFDW93ZfAD/UZkvGIqihBxIl6A1abe\nvWbJrgNt+G6ZL+YDJbCd1fil1YlH/BvtPmsVvikYJedPDMgskjT0i0ydT/Ru41mi\nJGPb8UkgObVKgJUHF0OSVXIvKOVpVWAt+XyP5GUCgYBEYdMBV4VWjdMdkRkJuh7H\nYm4GX8ah6fgQYRkpCIA6OiI2eXWDuReyS6bPOL7rQnQq9Ylmk8sW5TlD5Q8fFZLR\ndeopnix35LcRNwURrvCe9GTE3JSuxLyBsqgeZlE2cTndwr7hQHM+/q5+EAh0ol3p\ncFw2dDuFq8BzuTaXJatDBQ==\n-----END PRIVATE KEY-----\n")
  token = %{
    "iss" => "firebase-adminsdk-dpsy9@afya-cloud.iam.gserviceaccount.com",
    "sub" => "firebase-adminsdk-dpsy9@afya-cloud.iam.gserviceaccount.com",
     "scope" => "https://www.googleapis.com/auth/cloud-platform",

        # The time that the token was issued at
        "iat" => DateTime.to_unix(DateTime.utc_now()),
        # The time the token expires.
        "exp" => DateTime.to_unix( DateTime.utc_now() |> DateTime.add(1800, :second) ),
        # The audience field should always be set to the GCP project id.
        "aud" => "https://oauth2.googleapis.com/token",
    }
          opts = %{
        alg: "RS256",
        typ: "JWT",
        key: private_key
        }

        jwt = JsonWebToken.sign(token, opts)


    header = [

      "Content-Type": "application/json",
      Accept: "application/json"
    ]

    body = %{

          "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer",
          "assertion" => jwt
          }

  post("https://oauth2.googleapis.com/token", body: Jason.encode!(body), headers: header)
  |> process_response()
end


def send(token) do
    HTTPotion.start()
    header = [
      Authorization: "Bearer "<>token,
      "Content-Type": "application/json",
      Accept: "application/json"
    ]

    body = %{
           "message" => %{
            "token" => get_api_token(),
            "notification"=> %{
              "title"=> "elixie",
              "body"=> "This is a message from finally did it"
            },

          }

  }

  post(get_api_url(), body: Jason.encode!(body), headers: header)
  |> process_response()
end

def topic(token) do
    HTTPotion.start()
    header = [
      Authorization: "Bearer "<>token,
      "Content-Type": "application/json",
      Accept: "application/json"
    ]

    body = %{
           "message" => %{
             "topic" => "estate",
            "notification"=> %{
              "title"=> "⚠️⚠️Alert⚠️⚠️",
              "body"=> "There has been some development"
            },

          }

  }

  post(get_api_url(), body: Jason.encode!(body), headers: header)
  |> process_response()
end


def create_stream(bottles..stop) do
   Stream.map(bottles..stop, &sing/1) |> Enum.map(&IO.puts/1)
 end

 defp sing(0), do: "No more bottles of beer on the wall, no more bottles of beer.\n#{take_beer(0)}"
 defp sing(1), do: "1 bottle of beer on the wall, 1 bottle of beer.\n#{take_beer(1)}"
 defp sing(n) when is_integer(n) and n > 0 do
   "#{n} bottles of beer on the wall, #{n} bottles of beer.\n#{take_beer(n)}"
 end

 defp take_beer(0), do: "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
 defp take_beer(1), do: "Take one down and pass it around, no more bottles of beer on the wall.\n"
 defp take_beer(2), do: "Take one down and pass it around, 1 bottle of beer on the wall.\n"
 defp take_beer(n) when is_integer(n) and n > 0 do
   "Take one down and pass it around, #{n - 1} bottles of beer on the wall.\n"
 end


def webtopic(topic,title,message) do
    HTTPotion.start()
    oauth = get_token()
          {:ok, _second, %HTTPotion.Response{status_code: _status_code, body: result, headers: _headers}} = oauth
          %{
            "access_token" => token,
            "expires_in" => _expire,
            "token_type" => "Bearer"
            } = Jason.decode!(result)

    header = [
      Authorization: "Bearer "<> token,
      "Content-Type": "application/json",
      Accept: "application/json"
    ]

    body = %{
           "message" => %{
             "topic" => topic,
            "notification"=> %{
              "title"=> title,
              "body"=> message
            },

          }

  }
 IO.inspect get_api_url()
  HTTPotion.post(get_api_url(), body: Jason.encode!(body), headers: header)
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
