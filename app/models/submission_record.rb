class SubmissionRecord < ActiveRecord::Base
  mount_uploader :content, SubmissionUploader # Tells rails to use this uploader for this model.
  validates :content, presence: true
  validates :operation, presence: true
  validates :team_id, presence: true
  validates :user, presence: true
  validates :assignment_id, presence: true
end
