# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 10 breeds of dogs

# for each breed, 10 pets

require 'twitter'
require 'open-uri'

# p client = Twitter::Streaming::Client.new do |config|
#   config.consumer_key        = "1ReT21fSACW4Wr6V03QIlTizE"
#   config.consumer_secret     = "GmbjVXXXlX1JXT39ecL1njqv2ugGqFoSsSbat2TMlCQlKHa069"
#   config.bearer_token        = "AAAAAAAAAAAAAAAAAAAAABQ2WgEAAAAA%2F4CLlg%2BblJ5TeQ0eIYp0YH9XQ%2F4%3Dc4TB9FV2Mseb1hVEZUUJctznrk8F0cnBGBoQvlFB9pXDCIbRLU"
#   config.access_token        = "323729329-iGwHMlPLRyXpWlXdpcKaWdDTuDy0xbXR26TYArUQ"
#   config.access_token_secret = "V9Hd8OP4mzhNEEVIdltDOtOSY0iwr8dWxKKa1DdnxtXAC"
# end

# puts topics = ["mayc", "eth"]
# client.filter(track: topics.join(",")) do |object|
#   puts object.text if object.is_a?(Twitter::Tweet)
# end

# url = 'https://dog.ceo/api/breeds/list/all'
# pets_serialized = URI.open(url).read
# pets_hash = JSON.parse(pets_serialized)

# pets_hash['message'].keys.sample(10).each do |breed|
#   10.times do |number|
#     url_image = "https://dog.ceo/api/breed/#{breed.to_s}/images/random"
#     img_hash = URI.open(url_image).read
#     img_string = JSON.parse(img_hash)
#     pet = Pet.new(
#       breed: breed.to_s,
#       name: Faker::GreekPhilosophers.name,
#       img: img_string['message']
#     )
#     pet.save!
#     p pet
#   end
# end

# puts 'seed done'

# This script uses your bearer token to authenticate and make a Search request

require 'json'
require 'typhoeus'

# The code below sets the bearer token from your environment variables
# To set environment variables on Mac OS X, run the export command below from the terminal:
# export BEARER_TOKEN='YOUR-TOKEN'
bearer_token = ENV[TWITTER_KEY]

# Endpoint URL for the Recent Search API
search_url = "https://api.twitter.com/2/tweets/search/recent"

# Set the query value here. Value can be up to 512 characters
query = "from:tanztanzfarben"

# Add or remove parameters below to adjust the query and response fields within the payload
# See docs for list of param options: https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent
query_params = {
  "query": query, # Required
  "max_results": 30,
  # "start_time": "2020-07-01T00:00:00Z",
  # "end_time": "2020-07-02T18:00:00Z",
  # "expansions": "attachments.poll_ids,attachments.media_keys,author_id",
  "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,id,lang",
  "user.fields": "description"
  # "media.fields": "url",
  # "place.fields": "country_code",
  # "poll.fields": "options"
}

def search_tweets(url, bearer_token, query_params)
  options = {
    method: 'get',
    headers: {
      "User-Agent": "v2RecentSearchRuby",
      "Authorization": "Bearer #{bearer_token}"
    },
    params: query_params
  }

  request = Typhoeus::Request.new(url, options)
  response = request.run

  return response
end

response = search_tweets(search_url, bearer_token, query_params)
# puts response.code, JSON.pretty_generate(JSON.parse(response.body))
result = JSON.parse(response.body)
result['data'].each do |responses|
  puts responses['text']
end
