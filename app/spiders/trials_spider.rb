# frozen_string_literal: true

class TrialsSpider < Kimurai::Base
  @name = 'trial_spider'
  @engine = :mechanize

  def self.process(url)
    unless url.include?('poderjudicialvirtual.com')
      return { error: 'Domain not supported' }
    end

    @start_urls = [url]
    crawl!
  end

  ## From Kimurai::Base Called by TrialsSpider.crawl!
  def parse(response, url:, data: {})
    trial = {}
    trial[:title] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[1]/h1").text.squish
    trial[:court] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[2]/p/text()[1]").text.squish
    trial[:actor] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[2]/p/text()[2]").text.squish
    trial[:defendant] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[2]/p/text()[3]").text.squish
    trial[:expedient] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[3]/p/strong[1]").text.squish
    trial[:summary] = response.xpath("//*[@id='pcont']/div/div/div[2]/div[3]/p/text()[1]").text.squish
    trial[:notifications] = parse_notifications(response)

    self.class.save_trial(trial)
  end

  # Due to the Spider does not return the scraped data, it has to be saved here
  def self.save_trial(trial)
    return unless scrap_valid?(trial)

    notifications = trial.delete(:notifications)
    trial = Trial.create(trial)

    return unless notifications

    notifications.each do |notification|
      notification[:trial] = trial
    end

    Notification.create(notifications)
  end

  def parse_notifications(response)
    response.css('.postDegradado .list-group-item').map do |notification|
      {
        date: notification.css('.name').text.squish,
        content: notification.css('.justify').text.squish
      }
    end
  end

  # Return true if any element has content, false otherwise
  def self.scrap_valid?(trial)
    trial.select { |k, v| v.present? }.any?
  end
end
