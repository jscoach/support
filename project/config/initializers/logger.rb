# Custom logger that currently prints with colors to the console.
# It also sends messages to Slack in production.
module JsCoach
  extend self

  def log(msg)
    Rails.logger.debug msg unless Rails.env.test?
    notifier.ping "", attachments: [{ text: msg }] if Rails.env.production?
  end

  def info(msg)
    Rails.logger.info msg.blue unless Rails.env.test?
    notifier.ping "", attachments: [{ text: msg, color: "#4078c0" }] if Rails.env.production?
  end

  def success(msg)
    Rails.logger.info msg.green unless Rails.env.test?
    notifier.ping "", attachments: [{ text: msg, color: "good" }] if Rails.env.production?
  end

  def warn(msg)
    Rails.logger.warn msg.yellow unless Rails.env.test?
    notifier.ping "", attachments: [{ text: "<!channel> #{ msg }", color: "warning" }] if Rails.env.production?
  end

  def error(msg)
    Rails.logger.error msg.red unless Rails.env.test?
    notifier.ping "", attachments: [{ text: "<!channel> #{ msg }", color: "danger" }] if Rails.env.production?
  end

  private

  def notifier
    @_notifier ||= Slack::Notifier.new Rails.application.secrets.jobs_slack_webhook_url
  end
end
