class WechatController < ApplicationController

  def station
    if params[:function] == 'init'
      init
    elsif params[:function] == 'quote'
      quote
    elsif params[:function] == 'balance'
      balance
    else
      render json:{code:200}
    end
  end

  def init
    url = 'http://btc.loogle.org/api/stocks/init'
    res = Faraday.get(url)
    render json:JSON.parse(res.body)
  end

  def quote
    url = 'http://btc.loogle.org/api/stocks/quote'
    res = Faraday.get do |req|
      req.url url
      req.params[:block] = params[:block]
      req.params[:amount] = params[:amount]
    end
    render json:JSON.parse(res.body)
  end

  def balance
    url = 'http://btc.loogle.org/api/stocks/balance'
    res = Faraday.get(url)
    render json:JSON.parse(res.body)
  end

end