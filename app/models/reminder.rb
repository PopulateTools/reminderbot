class Reminder < ApplicationRecord
  validates :chat_id, presence: true
  validates :coded_string, presence: true

  after_create :create_schedule, :schedule_reminder_jobs

  def create_schedule
    sch, text = schedule_from_coded_string(coded_string)
    self.message_text = text
    self.schedule = sch.to_yaml
    save!
  end

  def schedule_reminder_jobs
    s = IceCube::Schedule.from_yaml(self.schedule)
    s.occurrences(1.month.from_now).each do |occurrence|
      SendReminderJob.set(wait_until: occurrence.to_datetime).perform_later(chat_id, message_text)
    end
  end

  def schedule_from_coded_string(cs)
    d, h, message = cs.split("|")
    days = d.split(",")
    hours = h.split(",")

    mapped_days = days.map{|day| days_map[day.to_sym]}.compact

    sch = IceCube::Schedule.new
    hours.each do |hour_string|
      hour, minute = hour_string.split(':')
      rule = IceCube::Rule.weekly.day(mapped_days).hour_of_day(hour.to_i).minute_of_hour(minute.to_i).second_of_minute(0)
      sch.add_recurrence_rule(rule)
    end

    return sch, message
  end

  def days_map
    {
      "L": :monday,
      "M": :tuesday,
      "X": :wednesday,
      "J": :thursday,
      "V": :friday,
      "S": :saturday,
      "D": :sunday,
    }
  end
end
