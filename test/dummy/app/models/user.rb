class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, length: { minimum: 3 }
  validates :phone, format: { with: /\A[0-9]{3}-[0-9]{3}-[0-9]{4}\z/, message: 'must be in the format 123-456-7890' }
  validates :age, numericality: { greater_than_or_equal_to: 18 }
  validates :homepage, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'must be a valid URL' }
  validates :birthdate, :bio, :receive_emails, :password, presence: true

  validate :testing

  def testing
    # return
    # errors.add(:base, 'This is just a general error')
  end
end
