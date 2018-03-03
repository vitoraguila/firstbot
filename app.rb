require 'json'
require 'sinatra'
require 'sinatra/activerecord'

require './config/database'

Dir["./app/models/*.rb"].each {|file| require file }
Dir["./app/services/**/*.rb"].each {|file| require file }

class App < Sinatra::Base
  get '/sinatra' do
    'Hello world Sinatra!'   
  end

  post '/webhook' do
    result = JSON.parse(request.body.read)["result"]
    if result["contexts"].present?
      response = InterpretService.call(result["action"], result["contexts"][0]["parameters"])
    else
      response = InterpretService.call(result["action"], result["parameters"])
    end

    content_type :json
    {
      "message": {
        "attachment": {
          "type": "template",
          "payload": {
            "template_type": "list",
            "top_element_style": "compact",
            "elements": [
              {
                "title": "Classic T-Shirt Collection",
                "subtitle": "See all our colors",
                "image_url": "https://peterssendreceiveapp.ngrok.io/img/collection.png",          
                "buttons": [
                  {
                    "title": "View",
                    "type": "web_url",
                    "url": "https://peterssendreceiveapp.ngrok.io/collection",
                    "messenger_extensions": true,
                    "webview_height_ratio": "tall",
                    "fallback_url": "https://peterssendreceiveapp.ngrok.io/"            
                  }
                ]
              },
              {
                "title": "Classic White T-Shirt",
                "subtitle": "See all our colors",
                "default_action": {
                  "type": "web_url",
                  "url": "https://peterssendreceiveapp.ngrok.io/view?item=100",
                  "messenger_extensions": true,
                  "webview_height_ratio": "tall",
                  "fallback_url": "https://peterssendreceiveapp.ngrok.io/"
                }
              },
              {
                "title": "Classic Blue T-Shirt",
                "image_url": "https://peterssendreceiveapp.ngrok.io/img/blue-t-shirt.png",
                "subtitle": "100% Cotton, 200% Comfortable",
                "default_action": {
                  "type": "web_url",
                  "url": "https://peterssendreceiveapp.ngrok.io/view?item=101",
                  "messenger_extensions": true,
                  "webview_height_ratio": "tall",
                  "fallback_url": "https://peterssendreceiveapp.ngrok.io/"
                },
                "buttons": [
                  {
                    "title": "Shop Now",
                    "type": "web_url",
                    "url": "https://peterssendreceiveapp.ngrok.io/shop?item=101",
                    "messenger_extensions": true,
                    "webview_height_ratio": "tall",
                    "fallback_url": "https://peterssendreceiveapp.ngrok.io/"            
                  }
                ]        
              }
            ],
             "buttons": [
              {
                "title": "View More",
                "type": "postback",
                "payload": "payload"            
              }
            ]  
          }
        }
      }
    }.to_json
  end
end