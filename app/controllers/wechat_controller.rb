class WechatController < ApplicationController

  def station
    if params[:function] == 'init'
      init_quote
    elsif params[:function] == 'quote'
      block_quote
    elsif params[:function] == 'balance'
      balance
    elsif params[:function] == 'buy1'
      buy_block
    elsif params[:function] == 'sell1'
      sell_block
    else
      render json:{code:200}
    end
  end

  def init_quote
    url = 'http://btc.loogle.org/api/stocks/init'
    res = Faraday.get(url)
    render json:JSON.parse(res.body)
  end

  def block_quote
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

  def buy_block
    url = 'http://btc.loogle.org/api/stocks/buy'
    res = Faraday.get do |req|
      req.url url
      req.params[:block] = params[:block]
    end
    render json:JSON.parse(res.body)
  end

  def sell_block
    url = 'http://btc.loogle.org/api/stocks/sell'
    res = Faraday.get do |req|
      req.url url
      req.params[:block] = params[:block]
    end
    render json:JSON.parse(res.body)
  end
end
