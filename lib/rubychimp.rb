require 'mailchimp'

class Rubychimp

  attr_accessor :errors, :mailchimp

  def initialize(api_key)
    @errors    = []
    @mailchimp = Mailchimp::API.new api_key
  end

  def lists_id
    @lists_id ||= lists['data'].collect { |list| list['id'] }
  end

  def subscribed_lists_id(email = nil)
    return [] if email.nil? || email.empty?

    subscribed_lists_id = lists_for_email(email_address: email)
    add_errors(subscribed_lists_id["error"]) if subscribed_lists_id.is_a?(Hash)
    success? ? subscribed_lists_id : []
  end

  def unsubscribed_lists_id(email = nil)
    return [] if email.nil? || email.empty?

      lists_id.reject { |id| subscribed_lists_id(email).include? id }
  end

  def lists_data(ids = nil)
    return [] if ids.nil? || id.empty?

      list_ids = ids.join(", ")
    lists(filters: { list_id: list_ids }, limit: 100)['data'].collect do |list|
      { id: list['id'], name: list['name'] }
    end
  end

  def all_lists
    total_lists = lists['total'].to_i
    limit       = 100
    pages       = (total_lists.to_f / limit).ceil
    limit_left  = total_lists
    list_items  = []

    pages.times do |page|
      limit_to_use = (limit_left > limit) ? limit : limit_left
      l            = lists(limit: limit, start: page, sort_field: 'created')

      l['data'].each do |d|
        list_items << [ d['name'], d['id'] ]
      end

      limit_left = limit_left - limit
    end

    list_items
  end

  def subscribed_lists_data(email = nil)
    return [] if email.nil? || email.empty?

      lists_data subscribed_lists_id email
  end

  def unsubscribed_lists_data(email = nil)
    return [] if email.nil? || email.empty?

      lists_data unsubscribed_lists_id email
  end

  def user_subscribe(list_id = nil, email = nil)
    return false if list_id.nil? || list_id.empty?

      response = list_subscribe(id:            list_id,
                              email_address: email,
                              double_optin:  false)

    add_errors(response["error"]) if response.is_a?(Hash)
    success?
  end

  def user_unsubscribe(list_id = nil, email = nil)
    return false if list_id.nil? || list_id.empty?

      response = list_unsubscribe(id:            list_id,
                                email_address: email,
                                double_optin:  false)

    add_errors(response["error"]) if response.is_a?(Hash)
    success?
  end

  def unsubscribe_all(lists_id = nil, email = nil)
    return false if !lists_id.is_a?(Array) || lists_id.nil? || lists_id.empty?

      lists_id.each do |list_id|
      response = list_unsubscribe(id:            list_id,
                                  email_address: email,
                                  double_optin:  false)
      add_errors(response["error"]) if response.is_a?(Hash)
    end

    success?
  end

  def template_ids
    templates["user"].collect { |template| template["id"] }
  end

  def find_template(id = nil)
    return false if id.nil? || id.empty?

      template_ids.include?(id)
  end

  def error_messages
    messages = ""
    errors.each do |message|
      messages << message
    end
    messages
  end

  def success?
    errors.nil? || errors.empty?
  end

   private

  def method_missing(method_name, *args)
    (args.nil? || args.empty?) ? mailchimp.send(method_name) :
                                 mailchimp.send(method_name, args.last)
  end

  def add_errors(message = nil)
    errors << message
  end

end