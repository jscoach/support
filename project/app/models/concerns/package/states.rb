class Package < ActiveRecord::Base
  module States
    extend ActiveSupport::Concern

    README_MIN_LENGTH = 400

    included do
      scope :pending,   -> { with_state :pending }
      scope :rejected,  -> { with_state :rejected }
      scope :accepted,  -> { with_state :accepted }
      scope :published, -> { with_state :published }

      validates :name, presence: true
      validates :name, uniqueness: true
      validates :state, presence: true

      validate :modified_at_is_after_npm_launch, unless: "modified_at.nil?"
      validate :repo_matches_required_format, unless: "repo.nil?"

      with_options if: Proc.new { |p| p.accepted? or p.published? } do |p|
        p.validates :description, presence: true
        p.validates :is_fork, inclusion: { in: [false] }, unless: :whitelisted?
        p.validates :languages, presence: true, unless: :whitelisted?
        p.validates :last_month_downloads, presence: true
        p.validates :last_week_downloads, presence: true
        p.validates :latest_release, presence: true
        p.validates :manifest, presence: true
        p.validates :modified_at, presence: true
        p.validates :published_at, presence: true
        p.validates :readme, presence: true
        p.validates :readme_plain_text, length: { minimum: README_MIN_LENGTH }, unless: :whitelisted?
        p.validates :repo, presence: true
        p.validates :stars, presence: true
        p.validates :dependents, presence: true
      end

      with_options if: :published? do |p|
        p.validates :collections, presence: true
      end

      state_machine :state, initial: :pending do
        event :pending do
          transition all => :pending
        end

        event :reject do
          transition all => :rejected
        end

        event :accept do
          transition all => :accepted
        end

        event :publish do
          transition :accepted => :published
        end
      end
    end

    # Automatically pick the higher state possible. Could be a `before_save` but this way
    # is more explicit and prevents this issue: http://git.io/v0NGz (only happens on tests)
    def auto_transition(previous_state = self.state)
      return self if valid? and previous_state == "published"

      self.state = "accepted"
      return self if valid? and previous_state != "rejected"

      self.state = "pending"
      return self if previous_state == "pending"
      return self if data_attributes_changed? and previous_state == "rejected"

      self.state = "rejected"
      return self
    end

    # Automatically approve or reject this package by checking validations
    def auto_review
      self.state = "pending" if rejected? # Unreject this package
      auto_transition # Pick the higher state possible
      self.state = "rejected" if pending? # If it can't get higher than pending, reject it
      return self
    end

    private

    # Same as `changed_attributes` but disregards changes to `state`
    def data_attributes_changed?
      changed_attributes.except(:state).size > 0
    end

    # Check if format is valid. For example: "madebyform/react-parts"
    def repo_matches_required_format
      if repo.split("/").size != 2
        errors.add :repo, "must match format `repouser/reponame`: #{ repo }"
      end
    end

    # To prevent eventual date parsing oddities, compare it
    # with the date NPM itself was released
    def modified_at_is_after_npm_launch
      if modified_at < NPM::Utils::LAUNCH_DATE
        errors.add :modified_at, "can't be before 2011: #{ modified_at }"
      end
    end
  end
end
