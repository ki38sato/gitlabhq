# frozen_string_literal: true

class MicrosoftTeamsService < ChatNotificationService
  def title
    'Microsoft Teams Notification'
  end

  def description
    'Receive event notifications in Microsoft Teams'
  end

  def self.to_param
    'microsoft_teams'
  end

  def help
    'This service sends notifications about projects events to Microsoft Teams channels.<br />
    To set up this service:
    <ol>
      <li><a href="https://msdn.microsoft.com/en-us/microsoft-teams/connectors">Getting started with 365 Office Connectors For Microsoft Teams</a>.</li>
      <li>Paste the <strong>Webhook URL</strong> into the field below.</li>
      <li>Select events below to enable notifications.</li>
    </ol>'
  end

  def webhook_placeholder
    'https://outlook.office.com/webhook/…'
  end

  def event_field(event)
  end

  def default_channel_placeholder
  end

  def default_fields
    [
      { type: 'text', name: 'webhook', placeholder: "e.g. #{webhook_placeholder}" },
      { type: 'checkbox', name: 'notify_only_broken_pipelines' },
      { type: 'checkbox', name: 'notify_only_default_branch' }
    ]
  end

  private

  def notify(message, opts)
    MicrosoftTeams::Notifier.new(webhook).ping(
      title: message.project_name,
      summary: message.summary,
      activity: message.activity,
      attachments: message.attachments
    )
  end

  def custom_data(data)
    super(data).merge(markdown: true)
  end
end
