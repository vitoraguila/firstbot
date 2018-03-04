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
      "speech": response,
      "displayText": response,
      "source": "Slack",
      "message": {
                    "attachment": {
                            "type": "template",
                            "payload": {
                                  "template_type": "generic",
                                  "elements": [
                                          {
                                            "title": "teste",
                                            "image_url": "http://www.hotelflordeminas.com.br/cache/3.png",
                                            "subtitle": "teste subtitulo"
                                          }
                                  ]
                            }
                    },
                    "quick_repliers": [
                            {
                              "content_type": "text",
                              "title": "resposta 1",
                              "payload": "reply1"
                            },
                            {
                              "content_type": "text",
                              "title": "resposta 2",
                              "payload": "reply2"
                            }
                    ]
      }
    }.to_json
  end
end
