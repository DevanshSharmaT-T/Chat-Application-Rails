class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create :generate_uuid_v7

  private

  def generate_uuid_v7
    self.id ||= SecureRandom.uuid_v7 if self.class.attribute_names.include?('id')
  end
end
