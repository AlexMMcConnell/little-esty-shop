class NagerDateService

  def self.holidays
    holidays = Hash.new
    content = conn.get("/api/v3/NextPublicHolidays/US")
    body = parse_response(content)
    binding.pry
    body[0..2].each do |holiday|
      holidays[holiday[:name]] = holiday[:date]
    end
    # holidays = {"Thanksgiving Day"=>"2021-11-25",
    #             "Christmas Day"=>"2021-12-24",
    #             "New Year's Day"=>"2021-12-31"}
    holidays
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: false)
  end

  def self.conn
    Faraday.new(url: "https://date.nager.at/")
  end

end
