defmodule Urbandev.Mailer do

  import Ecto.Query, warn: false
  use HTTPotion.Base
  HTTPotion.start()

  def get_api_key do
    Application.get_env(:sendgrid, :api_key)
  end

  def get_api_key2 do
    "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"
  end




  def get_api_url do
    Application.get_env(:sendgrid, :api_url)
  end

  def get_timestamp() do
    Timex.local()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
  end


  def getfunc() do

    HTTPotion.start()
    headers = [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer #{get_api_key()}"
    ]

    body =
      %{
        "foo" => "bar"
      }

      HTTPotion.get("https://api.sendgrid.com/v3/templates", body: Poison.encode!(body), headers: headers)
      |> process_response()



  end
  def welcome_email(email,code) do
    HTTPotion.start()
    headers = [
      "Content-Type": "application/json",
      "Accept": "application/json",
       "Authorization": "Bearer #{get_api_key2()}"
  ]

  html = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
<title> Email </title>
<meta name='viewport' content='width=device-width, initial-scale=1.0'/>
</head>
<body>
<div style='background:#eee;width:100%;height:500px;padding-top:50px;border: 2px dotted #e5e5e5;'>
<table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border-collapse: collapse;border: 2px dotted #e5e5e5;'>
<tr>
<td align='center' bgcolor='gold' style='padding: 10px 0 10px 0;'>
<img src='https://www.thamanionline.com/images/thamani_logo.png' alt='Creating Email' width='400' height='55' style='display: block;' />
</td>
</tr>

<tr>
<td bgcolor='ghostwhite' style='padding: 40px 30px 40px 30px;'>
     <table border='0' cellpadding='0' cellspacing='0' width='100%'>
     <tr>
     <td style='padding: 20px 0 30px 0;'>
     <strong><p>Thanks for joining Thamani Online </p><p> Find below the confirmation code</p><p style='font-size: 20px;color: black;background: gainsboro;text-align: center;'> " <>
    code <> "</p></strong>

     </td>
     </tr>
     <tr>

     </tr>
     </table>
</td>
</tr>

<tr>
<td bgcolor='#ef001d' style='padding: 30px 30px 30px 30px;color: #f5f5f5;'>
      <table border='0' cellpadding='0' cellspacing='0' width='100%'>
     <tr>
     <td width='75%'>
       &copy;
       <script>
           document.write(new Date().getFullYear())
       </script> Thamani Online. All Rights Reserved<br/>

         </td>
       <td width='25%'>
       Thamani Online
      </td>
     </tr>
     </table>
</td>
</tr>
</table>
</div>
</body>
</html>"
  body = %{

  "personalizations" => [
    %{
      "to" => [
        %{
          "email" => email,
          "name" => "Support Team"
        }
      ],
      "subject"  => "Thank you for joining our platform"
    }
  ],
  "from" => %{
    "email" => "info@thamanionline.com",
    "name" => "Support Team"
  },
  "subject" => "Your Example Order Confirmation",
  "content" => [
    %{
      "type" => "text/html",
      "value" => html
    }
  ]


  # {'personalizations': [
  #           {'to': [
  #             {'email': 'john_doe@example.com', 'name': 'John Doe'},
  #              {'email': 'julia_doe@example.com', 'name': 'Julia Doe'}
  #                  ],
  #            'cc': [
  #              {'email': 'jane_doe@example.com', 'name': 'Jane Doe'}
  #                  ],
  #            'bcc': [
  #              {'email': 'james_doe@example.com', 'name': 'Jim Doe'}
  #              ]
  #           },
  #           {'from':
  #               {'email': 'sales@example.com', 'name': 'Example Sales Team'},
  #               'to':
  #               [{'email': 'janice_doe@example.com', 'name': 'Janice Doe'}],
  #                'bcc': [{'email': 'jordan_doe@example.com', 'name': 'Jordan Doe'}]
  #           }],
  #               'from': {'email': 'orders@example.com', 'name': 'Example Order Confirmation'},
  #               'reply_to': {'email': 'customer_service@example.com', 'name': 'Example Customer Service Team'},
  #               'subject': 'Your Example Order Confirmation',
  #               'content':
  #                   [{'type': 'text/html', 'value': '<p>Hello from Twilio SendGrid!</p><p>Sending with the email service trusted by developers and marketers for <strong>time-savings</strong>, <strong>scalability</strong>, and <strong>delivery expertise</strong>.</p><p>%open-track%</p>'}],
  #                     'categories': ['cake', 'pie', 'baking'],
  #                      'send_at': 1617260400,
  #                      'batch_id': 'AsdFgHjklQweRTYuIopzXcVBNm0aSDfGHjklmZcVbNMqWert1znmOP2asDFjkl',
  #                      'asm': {'group_id': 12345, 'groups_to_display': [12345]},
  #                      'ip_pool_name': 'transactional email',
  #                      'mail_settings':
  #                         {'bypass_list_management': {'enable': False},
  #                         'footer': {'enable': False},
  #                         'sandbox_mode': {'enable': False}
  #                         },
  #                         'tracking_settings': {
  #                           'click_tracking': {'enable': True, 'enable_text': False},
  #                            'open_tracking': {'enable': True, 'substitution_tag': '%open-track%'},
  #                             'subscription_tracking': {'enable': False}
  #                         }
  #
  #                         }"

  }


  HTTPotion.post("https://api.sendgrid.com/v3//mail/send", body: Poison.encode!(body), headers: headers)
  |> process_response()

  end


    def reset_email(email,code) do
      HTTPotion.start()
      headers = [
        "Content-Type": "application/json",
        "Accept": "application/json",
         "Authorization": "Bearer #{get_api_key()}"
    ]

    html = "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
  <html xmlns='http://www.w3.org/1999/xhtml'>
  <head>
  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
  <title> Email </title>
  <meta name='viewport' content='width=device-width, initial-scale=1.0'/>
  </head>
  <body>
  <div style='background:#eee;width:100%;height:500px;padding-top:50px;border: 2px dotted #e5e5e5;'>
  <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border-collapse: collapse;border: 2px dotted #e5e5e5;'>
  <tr>
  <td align='center' bgcolor='gold' style='padding: 10px 0 10px 0;'>
  <img src='https://www.thamanionline.com/images/thamani_logo.png' alt='Creating Email' width='400' height='55' style='display: block;' />
  </td>
  </tr>

  <tr>
  <td bgcolor='ghostwhite' style='padding: 40px 30px 40px 30px;'>
       <table border='0' cellpadding='0' cellspacing='0' width='100%'>
       <tr>
       <td style='padding: 20px 0 30px 0;'>

         <strong><p>You are about to reset your Thamani online password.If this is not you kindly call us immediately</p><p> Find below the reset code</p><p style='font-size: 20px;color: black;background: gainsboro;text-align: center;'> " <>
        code <> "</p></strong>
       </td>
       </tr>
       <tr>

       </tr>
       </table>
  </td>
  </tr>

  <tr>
  <td bgcolor='#ef001d' style='padding: 30px 30px 30px 30px;color: #f5f5f5;'>
        <table border='0' cellpadding='0' cellspacing='0' width='100%'>
       <tr>
       <td width='75%'>
         &copy;
         <script>
             document.write(new Date().getFullYear())
         </script> Thamani Online. All Rights Reserved<br/>

           </td>
         <td width='25%'>
         Thamani Online
        </td>
       </tr>
       </table>
  </td>
  </tr>
  </table>
  </div>
  </body>
  </html>"
    body = %{

    "personalizations" => [
      %{
        "to" => [
          %{
            "email" => email
          }
        ],
        "subject"  => "resetting of your password "
      }
    ],
    "from" => %{
      "email" => "info@thamanionline.com"
    },
    "content" => [
      %{
        "type" => "text/html",
        "value" => html
      }
    ]


    }


    HTTPotion.post("https://api.sendgrid.com/v3//mail/send", body: Poison.encode!(body), headers: headers)
    |> process_response()

    end

  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
    cond do
      status_code == 201 ->
        {:ok, body, resp}

      true ->
        {:error, resp}
    end
  end



  def send() do
    SendGrid.Email.build()
|> SendGrid.Email.add_to("joss@csdigital.co.ke")
|> SendGrid.Email.put_from("test@thamanionline.co.ke")
|> SendGrid.Email.put_subject("Hello from Elixir")
|> SendGrid.Email.put_text("Sent with Elixir")
|> SendGrid.Mail.send()
  end

end
